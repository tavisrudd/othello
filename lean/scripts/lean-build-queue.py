#!/usr/bin/env python3
"""Run an explicit queue of Lean targets unattended.

The caller launches one sequence, walks away, and later reads an atomic status file instead of
spending agent turns polling Lake.  A single build-owner lock is acquired before the quiet-state
check and held for the whole run, so two runners cannot both observe a quiet tree and launch.

This is an orchestration tool.  It builds the targets it is given, waits for or refuses a busy
tree, and terminates only the child it started itself.  It never kills, cleans, or rebuilds work
owned by another lane.
"""

from __future__ import annotations

import argparse
import errno
import fcntl
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, NoReturn

LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
MODULE_RE = re.compile(r"[A-Za-z0-9_]+(?:\.[A-Za-z0-9_]+)*\Z")
STATE_ROOT_DEFAULT = Path.home() / ".cache" / "othello-lean-build"

EXIT_OK = 0
EXIT_BUILD_FAILED = 1
EXIT_REFUSED = 2
EXIT_INTERRUPTED = 130

# Lake's `bin/lake` execs `lake.orig`, so `pgrep -x lake` never matches a live build.
BUSY_COMMANDS = ("lake.orig", "lean")

_child: subprocess.Popen[bytes] | None = None
_interrupted = False


def fail(message: str, code: int = EXIT_REFUSED) -> NoReturn:
    print(f"lean-build-queue: {message}", file=sys.stderr)
    raise SystemExit(code)


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def atomic_write_json(path: Path, data: dict[str, Any]) -> None:
    """Replace `path` with `data`, so a reader never sees a torn or half-written state."""
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    with temporary.open("w") as stream:
        json.dump(data, stream, indent=2, sort_keys=True)
        stream.write("\n")
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temporary, path)


def read_json(path: Path) -> dict[str, Any] | None:
    try:
        data = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return None
    return data if isinstance(data, dict) else None


def lock_slug(lean_root: Path) -> str:
    return str(lean_root).strip("/").replace("/", "_") or "root"


def acquire_lock(path: Path, run_id: str, targets: list[str]):
    """Take the build-owner lock, or refuse and name the current owner.

    The lock is an open file description held for the process lifetime: the kernel releases it on
    exit, including an OOM kill, so a crashed run never wedges the queue.
    """
    path.parent.mkdir(parents=True, exist_ok=True)
    stream = path.open("a+")
    try:
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError as error:
        if error.errno not in (errno.EACCES, errno.EAGAIN):
            raise
        stream.seek(0)
        owner = stream.read().strip()
        stream.close()
        fail(f"another build owner holds {path}: {owner or 'unidentified owner'}")
    stream.seek(0)
    stream.truncate()
    json.dump({"run_id": run_id, "pid": os.getpid(), "since": utc_now(), "targets": targets}, stream)
    stream.write("\n")
    stream.flush()
    os.fsync(stream.fileno())
    return stream


def busy_commands(pgrep: str) -> list[str]:
    live = []
    for name in BUSY_COMMANDS:
        result = subprocess.run(
            [pgrep, "-x", name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False
        )
        if result.returncode == 0:
            live.append(name)
        elif result.returncode != 1:
            fail(f"pgrep -x {name} failed with exit code {result.returncode}")
    return live


def wait_for_quiet(pgrep: str, wait_seconds: int, poll_seconds: int) -> None:
    """Block until no foreign Lean/Lake process is live, or refuse.

    Only reached while holding the build-owner lock, and only between our own targets, so anything
    seen here belongs to someone else.  We wait it out; we never touch it.

    An agent sandbox may have a private PID namespace that hides host builds, so a quiet result is
    a second line of defense behind the lock, not proof that the tree is idle.
    """
    waited = 0
    while True:
        if _interrupted:
            raise Interrupted
        live = busy_commands(pgrep)
        if not live:
            return
        if waited >= wait_seconds:
            fail(
                f"a foreign Lean build is live ({', '.join(live)}); "
                f"waited {waited}s. Re-run with --wait-quiet-seconds to queue behind it."
            )
        print(f"waiting for a foreign Lean build to finish ({', '.join(live)})", flush=True)
        _sleep(min(poll_seconds, wait_seconds - waited))
        waited += poll_seconds


def _sleep(seconds: int) -> None:
    """Sleep in short slices so a SIGTERM during a long quiet-wait is noticed promptly."""
    for _ in range(max(seconds, 0)):
        if _interrupted:
            raise Interrupted
        time.sleep(1)


class Interrupted(Exception):
    pass


def _handle_signal(signum: int, _frame: object) -> None:
    global _interrupted
    _interrupted = True
    if _child is not None and _child.poll() is None:
        try:
            os.killpg(os.getpgid(_child.pid), signal.SIGTERM)
        except (ProcessLookupError, PermissionError):
            pass


def spawn_and_wait(argv: list[str], log_path: Path, env: dict[str, str], cwd: Path) -> int:
    """Run one child in its own session, capturing everything to `log_path`."""
    global _child
    if _interrupted:
        raise Interrupted
    with log_path.open("wb") as log:
        log.write(f"$ {' '.join(argv)}\n".encode())
        log.flush()
        _child = subprocess.Popen(
            argv, cwd=cwd, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True
        )
        try:
            code = _child.wait()
        finally:
            _child = None
    if _interrupted:
        raise Interrupted
    return code


def shell_script(threads: int, lake_args: str) -> str:
    # LEAN_NUM_THREADS is exported into the build shell: Lake is a Lean program, so its job pool is
    # Lean's task pool, and this is the only way to size it.
    return f"export LEAN_NUM_THREADS={threads}; exec lake build {lake_args}"


def nix_argv(nix: str, threads: int, lake_args: str) -> list[str]:
    return [nix, "develop", "--command", "bash", "-lc", shell_script(threads, lake_args)]


def build_argv(args: argparse.Namespace, target: str) -> list[str]:
    argv: list[str] = []
    if args.cores:
        argv += [args.taskset_binary, "-c", args.cores]
    # choom selects this build as the OOM victim so the kernel sacrifices a worker of ours instead
    # of an unrelated process.  Containment, not permission to oversubscribe memory.
    argv += [args.choom_binary, "-n", str(args.choom_adjust), "--"]
    argv += [args.time_binary, "-v"]
    argv += nix_argv(args.nix_binary, args.threads, quote(target))
    return argv


def probe_argv(args: argparse.Namespace, targets: list[str]) -> list[str]:
    joined = " ".join(quote(target) for target in targets)
    return nix_argv(args.nix_binary, 1, f"--no-build {joined}")


def quote(value: str) -> str:
    return f"'{value}'"


def telemetry(log_path: Path) -> dict[str, str]:
    """Pull GNU `time -v` wall clock and peak RSS out of a target log."""
    wanted = {
        "Elapsed (wall clock) time": "wall_clock",
        "Maximum resident set size": "max_rss_kbytes",
        "Exit status": "exit_status",
    }
    found: dict[str, str] = {}
    try:
        lines = log_path.read_text(errors="replace").splitlines()
    except OSError:
        return found
    for line in lines:
        for prefix, key in wanted.items():
            # Split on ": ", not ":" -- GNU time labels embed colons, as in
            # "Elapsed (wall clock) time (h:mm:ss or m:ss): 0:01.23".
            if prefix in line and ": " in line:
                found[key] = line.split(": ", 1)[1].strip()
    return found


def tail(log_path: Path, lines: int) -> str:
    try:
        content = log_path.read_text(errors="replace").splitlines()
    except OSError as error:
        return f"(cannot read {log_path}: {error})"
    return "\n".join(content[-lines:])


def toolchain_state(lean_root: Path) -> dict[str, Any]:
    """Record what the run was built from, so a later reader can attribute its artifacts."""
    state: dict[str, Any] = {}
    toolchain = lean_root / "lean-toolchain"
    if toolchain.is_file():
        state["lean_toolchain"] = toolchain.read_text().strip()
    git = shutil.which("git")
    if git is not None:
        head = subprocess.run(
            [git, "rev-parse", "HEAD"], cwd=lean_root, capture_output=True, text=True, check=False
        )
        if head.returncode == 0:
            state["git_head"] = head.stdout.strip()
        dirty = subprocess.run(
            [git, "status", "--porcelain"], cwd=lean_root, capture_output=True, text=True, check=False
        )
        if dirty.returncode == 0:
            state["git_dirty"] = bool(dirty.stdout.strip())
    return state


class Status:
    """The single terminal-status file, rewritten atomically at every transition."""

    def __init__(self, path: Path, run_id: str, targets: list[str]) -> None:
        self.path = path
        self.data: dict[str, Any] = {
            "format": 1,
            "run_id": run_id,
            "state": "running",
            "pid": os.getpid(),
            "started_utc": utc_now(),
            "heartbeat_utc": utc_now(),
            "targets": targets,
            "results": [],
            "current_target": None,
            "finished_utc": None,
            "exit_code": None,
            "failed_target": None,
        }
        self.flush()

    def flush(self) -> None:
        self.data["heartbeat_utc"] = utc_now()
        atomic_write_json(self.path, self.data)

    def start_target(self, target: str) -> None:
        self.data["current_target"] = target
        self.flush()

    def record(self, target: str, outcome: str, **extra: Any) -> None:
        entry = {"target": target, "outcome": outcome}
        entry.update(extra)
        self.data["results"].append(entry)
        self.data["current_target"] = None
        self.flush()

    def finish(self, state: str, exit_code: int, failed_target: str | None = None) -> None:
        self.data["state"] = state
        self.data["exit_code"] = exit_code
        self.data["failed_target"] = failed_target
        self.data["current_target"] = None
        self.data["finished_utc"] = utc_now()
        self.flush()


def command_run(args: argparse.Namespace) -> int:
    lean_root = args.lean_root.expanduser().resolve()
    if not (lean_root / "lakefile.lean").is_file() and not (lean_root / "lakefile.toml").is_file():
        fail(f"{lean_root} is not a Lake package")

    targets = list(dict.fromkeys(args.targets))
    for target in targets:
        if not MODULE_RE.fullmatch(target):
            fail(f"invalid module name: {target!r}")
    aggregate = args.aggregate or targets
    for target in aggregate:
        if not MODULE_RE.fullmatch(target):
            fail(f"invalid aggregate module name: {target!r}")

    home = Path.home().resolve()
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    run_id = f"{stamp}-{uuid.uuid4().hex[:8]}"
    run_dir = (args.run_dir or STATE_ROOT_DEFAULT / f"run-{run_id}").expanduser().resolve()
    # /tmp is tmpfs on this box: run state and logs there count against RAM.
    if not run_dir.is_relative_to(home):
        fail(f"run state must be disk-backed under {home}, not {run_dir}")
    logs = run_dir / "logs"
    logs.mkdir(parents=True, exist_ok=True)

    lock_file = args.lock_file or STATE_ROOT_DEFAULT / "locks" / f"{lock_slug(lean_root)}.lock"
    lock_file = lock_file.expanduser().resolve()

    pgrep = shutil.which(args.pgrep_binary)
    if pgrep is None:
        fail(f"{args.pgrep_binary} is unavailable; cannot check for a live foreign build")

    signal.signal(signal.SIGINT, _handle_signal)
    signal.signal(signal.SIGTERM, _handle_signal)

    # Lock first, quiet check second: the reverse order is the race this runner exists to close.
    lock = acquire_lock(lock_file, run_id, targets)

    env = os.environ.copy()
    env["LEAN_NUM_THREADS"] = str(args.threads)

    manifest = {
        "format": 1,
        "run_id": run_id,
        "created_utc": utc_now(),
        "lean_root": str(lean_root),
        "run_dir": str(run_dir),
        "lock_file": str(lock_file),
        "targets": targets,
        "aggregate": aggregate,
        "resources": {
            "cores": args.cores,
            "lean_num_threads": args.threads,
            "choom_adjust": args.choom_adjust,
        },
        "logs": {target: str(logs / f"{target.split('.')[-1]}.log") for target in targets},
        "source": toolchain_state(lean_root),
    }
    atomic_write_json(run_dir / "manifest.json", manifest)
    status = Status(run_dir / "status.json", run_id, targets)
    print(f"run dir: {run_dir}")
    print(f"status:  {sys.argv[0]} status {run_dir}")

    try:
        for target in targets:
            wait_for_quiet(pgrep, args.wait_quiet_seconds, args.poll_seconds)
            status.start_target(target)
            leaf = target.split(".")[-1]

            probe_log = logs / f"{leaf}.nobuild.log"
            if spawn_and_wait(probe_argv(args, [target]), probe_log, env, lean_root) == 0:
                print(f"already current, skipping {target}", flush=True)
                status.record(target, "skipped-current", log=str(probe_log))
                continue

            log_path = logs / f"{leaf}.log"
            print(f"starting {target}", flush=True)
            code = spawn_and_wait(build_argv(args, target), log_path, env, lean_root)
            if code != 0:
                print(f"FAILED {target}; tail of {log_path} follows", file=sys.stderr)
                print(tail(log_path, args.tail_lines), file=sys.stderr)
                status.record(target, "failed", log=str(log_path), exit_code=code)
                status.finish("failed", EXIT_BUILD_FAILED, failed_target=target)
                return EXIT_BUILD_FAILED
            measured = telemetry(log_path)
            print(f"passed {target} {measured}", flush=True)
            status.record(target, "built", log=str(log_path), **measured)

        wait_for_quiet(pgrep, args.wait_quiet_seconds, args.poll_seconds)
        gate_log = logs / "aggregate-no-build.log"
        status.start_target("<aggregate --no-build gate>")
        print("starting trace-only aggregate gate", flush=True)
        code = spawn_and_wait(probe_argv(args, aggregate), gate_log, env, lean_root)
        if code != 0:
            print(f"FAILED aggregate gate; tail of {gate_log} follows", file=sys.stderr)
            print(tail(gate_log, args.tail_lines), file=sys.stderr)
            status.record("<aggregate>", "failed", log=str(gate_log), exit_code=code)
            status.finish("failed", EXIT_BUILD_FAILED, failed_target="<aggregate>")
            return EXIT_BUILD_FAILED
        status.record("<aggregate>", "gate-passed", log=str(gate_log))
        status.finish("success", EXIT_OK)
        print(f"queue complete; logs in {logs}")
        return EXIT_OK
    except Interrupted:
        print("interrupted; the queue is safe to re-run", file=sys.stderr)
        status.finish("interrupted", EXIT_INTERRUPTED)
        return EXIT_INTERRUPTED
    finally:
        lock.close()


def lock_holder(lock_file: Path) -> dict[str, Any] | None:
    """Report the lock's contents when it is held, or None when nobody holds it.

    Filesystem-based, so it works from an agent sandbox whose PID namespace hides the host's
    processes and makes a `pgrep`/`kill -0` liveness check unreliable.
    """
    if not lock_file.is_file():
        return None
    try:
        stream = lock_file.open("a+")
    except OSError:
        return None
    with stream:
        try:
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            stream.seek(0)
            try:
                data = json.loads(stream.read() or "{}")
            except json.JSONDecodeError:
                return {}
            return data if isinstance(data, dict) else {}
        fcntl.flock(stream.fileno(), fcntl.LOCK_UN)
        return None


def command_status(args: argparse.Namespace) -> int:
    run_dir = args.run_dir.expanduser().resolve()
    status = read_json(run_dir / "status.json")
    if status is None:
        fail(f"no readable status.json in {run_dir}")
    manifest = read_json(run_dir / "manifest.json") or {}

    state = status.get("state")
    if state == "running":
        holder = lock_holder(Path(manifest.get("lock_file", "")))
        if holder is None or holder.get("run_id") != status.get("run_id"):
            # Terminal status is written on exit and on SIGINT/SIGTERM.  "running" with the lock
            # released means the process died without writing one -- an OOM kill or SIGKILL.
            state = "abandoned"
            status["state"] = state
            status["note"] = "no live owner holds the lock; the run died without a terminal status"

    if args.json:
        print(json.dumps(status, indent=2, sort_keys=True))
        return EXIT_OK

    print(f"run_id:  {status.get('run_id')}")
    print(f"state:   {state}")
    print(f"started: {status.get('started_utc')}  heartbeat: {status.get('heartbeat_utc')}")
    if status.get("current_target"):
        print(f"current: {status['current_target']}")
    for entry in status.get("results", []):
        extra = entry.get("wall_clock", "")
        rss = entry.get("max_rss_kbytes", "")
        suffix = f"  {extra} wall, {rss} kB peak" if extra else ""
        print(f"  {entry.get('outcome'):16} {entry.get('target')}{suffix}")
    if status.get("failed_target"):
        print(f"failed:  {status['failed_target']}")
    if status.get("note"):
        print(f"note:    {status['note']}")
    return EXIT_OK


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    subparsers = result.add_subparsers(dest="command", required=True)

    run = subparsers.add_parser("run", help="build an explicit target queue under one owner lock")
    run.add_argument("targets", nargs="+", help="Lean modules to build, in order")
    run.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT)
    run.add_argument("--run-dir", type=Path, default=None, help="durable run state; must be under $HOME")
    run.add_argument("--lock-file", type=Path, default=None)
    run.add_argument("--aggregate", nargs="+", default=None, help="final trace-only gate (default: the targets)")
    run.add_argument("--cores", default=None, help="taskset CPU list, e.g. 20-23")
    run.add_argument(
        "--threads",
        type=int,
        default=1,
        help="LEAN_NUM_THREADS; size it by measured peak RSS, never from nproc",
    )
    run.add_argument("--choom-adjust", type=int, default=1000)
    run.add_argument(
        "--wait-quiet-seconds",
        type=int,
        default=0,
        help="how long to queue behind a foreign Lean build (default: refuse immediately)",
    )
    run.add_argument("--poll-seconds", type=int, default=60)
    run.add_argument("--tail-lines", type=int, default=80)
    run.add_argument("--nix-binary", default="nix")
    run.add_argument("--time-binary", default="/usr/bin/time", help="GNU time, for per-target telemetry")
    run.add_argument("--taskset-binary", default="taskset")
    run.add_argument("--choom-binary", default="choom")
    run.add_argument("--pgrep-binary", default="pgrep")
    run.set_defaults(function=command_run)

    status = subparsers.add_parser("status", help="read a run's status without touching Lake")
    status.add_argument("run_dir", type=Path)
    status.add_argument("--json", action="store_true")
    status.set_defaults(function=command_status)
    return result


def main() -> None:
    args = parser().parse_args()
    raise SystemExit(args.function(args))


if __name__ == "__main__":
    main()
