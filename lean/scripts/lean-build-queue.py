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
import shlex
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
PROFILE_FILE_DEFAULT = Path(__file__).resolve().with_name("lean-build-profiles.json")
MOUNTINFO_DEFAULT = Path("/proc/self/mountinfo")

EXIT_OK = 0
EXIT_BUILD_FAILED = 1
EXIT_REFUSED = 2
EXIT_INTERRUPTED = 130

# Lake's `bin/lake` execs `lake.orig`, so `pgrep -x lake` never matches a live build.
BUSY_COMMANDS = ("lake.orig", "lean")

_child: subprocess.Popen[bytes] | None = None
_interrupted = False


class Refused(Exception):
    def __init__(self, message: str, code: int = EXIT_REFUSED) -> None:
        super().__init__(message)
        self.code = code


def fail(message: str, code: int = EXIT_REFUSED) -> NoReturn:
    raise Refused(message, code)


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


def read_meminfo(path: Path) -> dict[str, int]:
    """Read selected /proc/meminfo values as MiB."""
    values: dict[str, int] = {}
    try:
        lines = path.read_text().splitlines()
    except OSError as error:
        fail(f"cannot read memory information from {path}: {error}")
    for line in lines:
        fields = line.split()
        if len(fields) >= 2 and fields[0] in {"MemTotal:", "MemAvailable:"}:
            values[fields[0][:-1]] = int(fields[1]) // 1024
    if set(values) != {"MemTotal", "MemAvailable"}:
        fail(f"{path} does not contain MemTotal and MemAvailable")
    return values


def _unescape_mount(value: str) -> str:
    return value.replace("\\040", " ").replace("\\011", "\t").replace("\\134", "\\")


def filesystem_type(path: Path, mountinfo: Path) -> tuple[str, Path]:
    """Return the longest matching mount point and its filesystem type."""
    resolved = path.expanduser().resolve()
    existing = resolved
    while not existing.exists() and existing != existing.parent:
        existing = existing.parent
    matches: list[tuple[int, str, Path]] = []
    try:
        lines = mountinfo.read_text().splitlines()
    except OSError as error:
        fail(f"cannot read mount information from {mountinfo}: {error}")
    for line in lines:
        try:
            left, right = line.split(" - ", 1)
            left_fields = left.split()
            mount_point = Path(_unescape_mount(left_fields[4])).resolve()
            fs_type = right.split()[0]
        except (IndexError, ValueError):
            continue
        if existing == mount_point or existing.is_relative_to(mount_point):
            matches.append((len(str(mount_point)), fs_type, mount_point))
    if not matches:
        fail(f"cannot identify the filesystem containing {resolved}")
    _, fs_type, mount_point = max(matches)
    return fs_type, mount_point


def load_profiles(path: Path) -> dict[str, dict[str, Any]]:
    data = read_json(path)
    if data is None or not isinstance(data.get("profiles"), dict):
        fail(f"no readable resource profiles in {path}")
    profiles = data["profiles"]
    if not all(isinstance(name, str) and isinstance(profile, dict) for name, profile in profiles.items()):
        fail(f"malformed resource profiles in {path}")
    return profiles


def resource_plan(args: argparse.Namespace) -> dict[str, Any]:
    profiles = load_profiles(args.profile_file.expanduser().resolve())
    if args.profile not in profiles:
        fail(f"unknown resource profile {args.profile!r}; choose one of {', '.join(sorted(profiles))}")
    profile = profiles[args.profile]
    required = {"verified_max_threads", "reserve_mib"}
    if not required.issubset(profile):
        fail(f"resource profile {args.profile!r} is missing {sorted(required - set(profile))}")

    verified_max = int(profile["verified_max_threads"])
    reserve_mib = int(profile["reserve_mib"])
    if args.threads > verified_max:
        fail(
            f"profile {args.profile!r} permits at most {verified_max} threads; "
            f"requested {args.threads}"
        )

    memory = read_meminfo(args.meminfo)
    tmp_fs_type, tmp_mount = filesystem_type(args.tmp_path, args.mountinfo)
    measured_tmp_used = shutil.disk_usage(args.tmp_path).used // (1024 * 1024)
    tmp_used_mib = args.tmp_used_mib if args.tmp_used_mib is not None else measured_tmp_used
    tmp_ram_mib = tmp_used_mib if tmp_fs_type in {"tmpfs", "ramfs"} else 0
    worker_peak = profile.get("worker_peak_mib")
    workload_peak_mib = 0
    if worker_peak is not None:
        worker_peak = int(worker_peak)
        workload_peak_mib = args.threads * worker_peak
        checker_peak = int(profile.get("shared_checker_peak_mib", 0))
        sibling_peak = int(profile.get("concurrent_sibling_peak_mib", worker_peak))
        if checker_peak:
            workload_peak_mib = max(
                workload_peak_mib,
                checker_peak + max(0, args.threads - 1) * sibling_peak,
            )

    required_total_mib = reserve_mib + tmp_ram_mib + workload_peak_mib
    if required_total_mib >= memory["MemTotal"]:
        fail(
            f"resource profile {args.profile!r} is unsafe: requires {required_total_mib} MiB "
            f"including reserve/tmpfs, host has {memory['MemTotal']} MiB"
        )
    if workload_peak_mib and memory["MemAvailable"] < workload_peak_mib + 1024:
        fail(
            f"insufficient memory currently available for {args.profile!r}: "
            f"need at least {workload_peak_mib + 1024} MiB, have {memory['MemAvailable']} MiB"
        )
    return {
        "profile": args.profile,
        "description": profile.get("description", ""),
        "threads": args.threads,
        "verified_max_threads": verified_max,
        "reserve_mib": reserve_mib,
        "worker_peak_mib": worker_peak,
        "workload_peak_mib": workload_peak_mib,
        "tmp_used_mib": tmp_used_mib,
        "tmp_ram_mib": tmp_ram_mib,
        "tmp_filesystem": tmp_fs_type,
        "tmp_mount": str(tmp_mount),
        "required_total_mib": required_total_mib,
        "mem_total_mib": memory["MemTotal"],
        "mem_available_mib": memory["MemAvailable"],
    }


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
        try:
            _child = subprocess.Popen(
                argv, cwd=cwd, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True
            )
        except OSError as error:
            fail(f"cannot start {argv[0]}: {error}")
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


def build_inner_argv(args: argparse.Namespace, target: str, threads: int) -> list[str]:
    argv: list[str] = []
    if args.cores:
        argv += [args.taskset_binary, "-c", args.cores]
    # choom selects this build as the OOM victim so the kernel sacrifices a worker of ours instead
    # of an unrelated process.  Containment, not permission to oversubscribe memory.
    argv += [args.choom_binary, "-n", str(args.choom_adjust), "--"]
    argv += [args.time_binary, "-v"]
    argv += nix_argv(args.nix_binary, threads, quote(target))
    return argv


def build_argv(args: argparse.Namespace, target: str, threads: int) -> list[str]:
    """Every real Lake build is captured by the shared bounded-output wrapper."""
    return [args.run_quiet_binary, shlex.join(build_inner_argv(args, target, threads))]


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
    if lines == 0:
        return ""
    try:
        content = log_path.read_text(errors="replace").splitlines()
    except OSError as error:
        return f"(cannot read {log_path}: {error})"
    return "\n".join(content[-lines:])


def quiet_evidence(root: Path) -> tuple[Path, Path, Path]:
    runs = sorted(path for path in root.iterdir() if path.is_dir()) if root.is_dir() else []
    if len(runs) != 1:
        fail(f"run-quiet produced {len(runs)} result directories under {root}, expected one")
    run = runs[0]
    return run, run / "stdout.log", run / "stderr.log"


def diagnostic_tail(stdout_log: Path, stderr_log: Path, lines: int) -> str:
    chunks = [tail(stderr_log, lines), tail(stdout_log, lines)]
    combined = "\n".join(chunk for chunk in chunks if chunk)
    return "\n".join(combined.splitlines()[-lines:]) if lines else ""


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

    serial_targets = list(dict.fromkeys(args.serial_first))
    targets = list(dict.fromkeys([*serial_targets, *args.targets]))
    for target in targets:
        if not MODULE_RE.fullmatch(target):
            fail(f"invalid module name: {target!r}")
    aggregate = args.aggregate or targets
    for target in aggregate:
        if not MODULE_RE.fullmatch(target):
            fail(f"invalid aggregate module name: {target!r}")

    plan = resource_plan(args)
    home = Path.home().resolve()
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    run_id = f"{stamp}-{uuid.uuid4().hex[:8]}"
    run_dir = (args.run_dir or STATE_ROOT_DEFAULT / f"run-{run_id}").expanduser().resolve()
    if not run_dir.is_relative_to(home):
        fail(f"run state must be disk-backed under {home}, not {run_dir}")
    run_fs_type, run_mount = filesystem_type(run_dir, args.mountinfo)
    if run_fs_type in {"tmpfs", "ramfs"}:
        fail(f"run state must be disk-backed; {run_dir} is on {run_fs_type} at {run_mount}")
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
    # Popen(cwd=...) changes the process directory but does not rewrite an explicitly inherited
    # PWD.  Wrappers such as run-quiet may treat PWD as authoritative and otherwise start
    # `nix develop` from the caller's directory (for example rust/) instead of this Lake package.
    env["PWD"] = str(lean_root)
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
            "plan": plan,
        },
        "serial_first": serial_targets,
        "logs": {target: str(logs / f"{target}.log") for target in targets},
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
            probe_log = logs / f"{target}.nobuild.log"
            if spawn_and_wait(probe_argv(args, [target]), probe_log, env, lean_root) == 0:
                print(f"already current, skipping {target}", flush=True)
                status.record(target, "skipped-current", log=str(probe_log))
                continue

            log_path = logs / f"{target}.log"
            quiet_root = logs / f"{target}.quiet" / run_id
            target_env = env.copy()
            target_env["RUN_QUIET_LOGDIR"] = str(quiet_root)
            print(f"starting {target}", flush=True)
            target_threads = 1 if target in serial_targets else args.threads
            code = spawn_and_wait(
                build_argv(args, target, target_threads), log_path, target_env, lean_root
            )
            quiet_dir, stdout_log, stderr_log = quiet_evidence(quiet_root)
            if code != 0:
                print(f"FAILED {target}; bounded run-quiet tail follows", file=sys.stderr)
                print(diagnostic_tail(stdout_log, stderr_log, args.tail_lines), file=sys.stderr)
                status.record(
                    target,
                    "failed",
                    log=str(log_path),
                    quiet_dir=str(quiet_dir),
                    exit_code=code,
                )
                status.finish("failed", EXIT_BUILD_FAILED, failed_target=target)
                return EXIT_BUILD_FAILED
            measured = telemetry(stderr_log)
            print(f"passed {target} {measured}", flush=True)
            status.record(
                target,
                "built",
                log=str(log_path),
                quiet_dir=str(quiet_dir),
                threads=target_threads,
                **measured,
            )

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
    except Refused as error:
        print(f"lean-build-queue: {error}", file=sys.stderr)
        status.finish("refused", error.code)
        return error.code
    finally:
        lock.close()


def command_plan(args: argparse.Namespace) -> int:
    print(json.dumps(resource_plan(args), indent=2, sort_keys=True))
    return EXIT_OK


def command_detached_run(args: argparse.Namespace) -> int:
    """Launch `run` in its own session and return its durable status location."""
    lean_root = args.lean_root.expanduser().resolve()
    if not (lean_root / "lakefile.lean").is_file() and not (lean_root / "lakefile.toml").is_file():
        fail(f"{lean_root} is not a Lake package")

    home = Path.home().resolve()
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    run_dir = (
        args.run_dir or STATE_ROOT_DEFAULT / f"run-{stamp}-{uuid.uuid4().hex[:8]}"
    ).expanduser().resolve()
    if not run_dir.is_relative_to(home):
        fail(f"run state must be disk-backed under {home}, not {run_dir}")
    run_fs_type, run_mount = filesystem_type(run_dir, args.mountinfo)
    if run_fs_type in {"tmpfs", "ramfs"}:
        fail(f"run state must be disk-backed; {run_dir} is on {run_fs_type} at {run_mount}")
    if run_dir.exists():
        fail(f"refusing to reuse detached run directory {run_dir}")
    run_dir.mkdir(parents=True)

    child_args = [argument for argument in sys.argv[1:] if argument != "--detach"]
    if args.run_dir is None:
        child_args += ["--run-dir", str(run_dir)]
    launcher_log = run_dir / "launcher.log"
    child_env = os.environ.copy()
    child_env["PWD"] = str(lean_root)
    with launcher_log.open("wb") as log:
        try:
            child = subprocess.Popen(
                [sys.executable, str(Path(__file__).resolve()), *child_args],
                cwd=lean_root,
                env=child_env,
                stdin=subprocess.DEVNULL,
                stdout=log,
                stderr=subprocess.STDOUT,
                start_new_session=True,
            )
        except OSError as error:
            fail(f"cannot start detached queue: {error}")

    atomic_write_json(
        run_dir / "detached.json",
        {
            "format": 1,
            "launcher_pid": child.pid,
            "launched_utc": utc_now(),
            "lean_root": str(lean_root),
            "run_dir": str(run_dir),
            "launcher_log": str(launcher_log),
        },
    )
    print(f"detached pid: {child.pid}")
    print(f"run dir:      {run_dir}")
    print(f"status:       {Path(__file__).resolve()} status {run_dir}")
    return EXIT_OK


def command_pack(args: argparse.Namespace) -> int:
    """Create a disk-backed Lake artifact archive without racing another build."""
    lean_root = args.lean_root.expanduser().resolve()
    if not (lean_root / "lakefile.lean").is_file() and not (lean_root / "lakefile.toml").is_file():
        fail(f"{lean_root} is not a Lake package")
    destination = args.destination.expanduser().resolve()
    home = Path.home().resolve()
    if not destination.is_relative_to(home):
        fail(f"artifact archive must be disk-backed under {home}, not {destination}")
    fs_type, mount = filesystem_type(destination, args.mountinfo)
    if fs_type in {"tmpfs", "ramfs"}:
        fail(f"artifact archive must be disk-backed; {destination} is on {fs_type} at {mount}")
    if destination.exists():
        fail(f"refusing to overwrite existing artifact archive {destination}")
    destination.parent.mkdir(parents=True, exist_ok=True)

    pgrep = shutil.which(args.pgrep_binary)
    if pgrep is None:
        fail(f"{args.pgrep_binary} is unavailable; cannot check for a live foreign build")
    lock_file = (
        args.lock_file or STATE_ROOT_DEFAULT / "locks" / f"{lock_slug(lean_root)}.lock"
    ).expanduser().resolve()
    run_id = f"pack-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}-{uuid.uuid4().hex[:8]}"
    lock = acquire_lock(lock_file, run_id, ["<lake pack>"])
    try:
        wait_for_quiet(pgrep, 0, 60)
        quiet_root = destination.parent / ".lean-pack-logs" / run_id
        env = os.environ.copy()
        env["RUN_QUIET_LOGDIR"] = str(quiet_root)
        inner = [
            args.nix_binary,
            "develop",
            "--command",
            "lake",
            "pack",
            str(destination),
        ]
        try:
            result = subprocess.run(
                [args.run_quiet_binary, shlex.join(inner)],
                cwd=lean_root,
                env=env,
                capture_output=True,
                text=True,
                check=False,
            )
        except OSError as error:
            fail(f"cannot start {args.run_quiet_binary}: {error}")
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(result.stderr, end="", file=sys.stderr)
        if result.returncode != 0:
            return EXIT_BUILD_FAILED
        if not destination.is_file():
            fail(f"lake pack reported success but did not create {destination}")
        print(f"artifact archive: {destination}")
        return EXIT_OK
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


def positive_int(value: str) -> int:
    parsed = int(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return parsed


def nonnegative_int(value: str) -> int:
    parsed = int(value)
    if parsed < 0:
        raise argparse.ArgumentTypeError("must be a nonnegative integer")
    return parsed


def oom_adjust(value: str) -> int:
    parsed = int(value)
    if not -1000 <= parsed <= 1000:
        raise argparse.ArgumentTypeError("must be between -1000 and 1000")
    return parsed


def add_resource_arguments(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--threads",
        type=positive_int,
        default=1,
        help="LEAN_NUM_THREADS; bounded by the selected measured resource profile",
    )
    parser.add_argument("--profile", default="single", help="named profile from --profile-file")
    parser.add_argument("--profile-file", type=Path, default=PROFILE_FILE_DEFAULT)
    parser.add_argument("--meminfo", type=Path, default=Path("/proc/meminfo"), help=argparse.SUPPRESS)
    parser.add_argument(
        "--mountinfo", type=Path, default=MOUNTINFO_DEFAULT, help=argparse.SUPPRESS
    )
    parser.add_argument("--tmp-path", type=Path, default=Path("/tmp"), help=argparse.SUPPRESS)
    parser.add_argument("--tmp-used-mib", type=nonnegative_int, default=None, help=argparse.SUPPRESS)


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    subparsers = result.add_subparsers(dest="command", required=True)

    run = subparsers.add_parser("run", help="build an explicit target queue under one owner lock")
    run.add_argument("targets", nargs="+", help="Lean modules to build, in order")
    run.add_argument(
        "--serial-first",
        action="append",
        default=[],
        metavar="MODULE",
        help="build a heavy shared dependency first with one thread; repeat as needed",
    )
    run.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT)
    run.add_argument("--run-dir", type=Path, default=None, help="durable run state; must be under $HOME")
    run.add_argument("--lock-file", type=Path, default=None)
    run.add_argument("--aggregate", nargs="+", default=None, help="final trace-only gate (default: the targets)")
    run.add_argument("--cores", default=None, help="taskset CPU list, e.g. 20-23")
    add_resource_arguments(run)
    run.add_argument("--choom-adjust", type=oom_adjust, default=1000)
    run.add_argument(
        "--wait-quiet-seconds",
        type=nonnegative_int,
        default=0,
        help="how long to queue behind a foreign Lean build (default: refuse immediately)",
    )
    run.add_argument("--poll-seconds", type=positive_int, default=60)
    run.add_argument("--tail-lines", type=nonnegative_int, default=80)
    run.add_argument("--nix-binary", default="nix")
    run.add_argument("--time-binary", default="/usr/bin/time", help="GNU time, for per-target telemetry")
    run.add_argument("--taskset-binary", default="taskset")
    run.add_argument("--choom-binary", default="choom")
    run.add_argument("--pgrep-binary", default="pgrep")
    run.add_argument("--run-quiet-binary", default=str(Path.home() / ".claude/bin/run-quiet"))
    run.add_argument(
        "--detach",
        action="store_true",
        help="launch an unattended queue process; status.json records its terminal exit state",
    )
    run.set_defaults(
        function=lambda args: command_detached_run(args) if args.detach else command_run(args)
    )

    plan = subparsers.add_parser("plan", help="validate and print a resource plan; never runs Lake")
    add_resource_arguments(plan)
    plan.set_defaults(function=command_plan)

    pack = subparsers.add_parser("pack", help="quietly create a disk-backed lake pack archive")
    pack.add_argument("destination", type=Path)
    pack.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT)
    pack.add_argument("--lock-file", type=Path, default=None)
    pack.add_argument("--mountinfo", type=Path, default=MOUNTINFO_DEFAULT, help=argparse.SUPPRESS)
    pack.add_argument("--nix-binary", default="nix")
    pack.add_argument("--pgrep-binary", default="pgrep")
    pack.add_argument("--run-quiet-binary", default=str(Path.home() / ".claude/bin/run-quiet"))
    pack.set_defaults(function=command_pack)

    status = subparsers.add_parser("status", help="read a run's status without touching Lake")
    status.add_argument("run_dir", type=Path)
    status.add_argument("--json", action="store_true")
    status.set_defaults(function=command_status)
    return result


def main() -> None:
    args = parser().parse_args()
    try:
        code = args.function(args)
    except Refused as error:
        print(f"lean-build-queue: {error}", file=sys.stderr)
        code = error.code
    raise SystemExit(code)


if __name__ == "__main__":
    main()
