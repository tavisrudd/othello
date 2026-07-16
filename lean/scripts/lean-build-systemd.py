#!/usr/bin/env python3
"""C225 systemd-managed Lean queue adapter, rolled out beside the legacy queue."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import pwd
import re
import shlex
import stat
import subprocess
import sys
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable, Mapping, NoReturn, Sequence


EXIT_INVALID = 125
MAX_VALUE_LENGTH = 128
MAX_RECORD_BYTES = 64 * 1024
MAX_ARG_BYTES = 4096
MAX_ARGV_BYTES = 48 * 1024
HARNESS_VALUES = ("codex", "claude", "manual")
SESSION_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.:@+-]{0,127}\Z")
LANE_RE = re.compile(r"[a-z0-9][a-z0-9-]{0,63}\Z")
TASK_RE = re.compile(r"C[0-9]+\Z")
BUS_OWNER_RE = re.compile(r":[0-9]+\.[0-9]+\Z")
BOOT_ID_RE = re.compile(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}\Z")
STATE_ROOT_DEFAULT = Path.home() / ".cache" / "othello-lean-build-systemd"
LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
BUSCTL_DEFAULT = Path("/run/current-system/sw/bin/busctl")
BOOT_ID_DEFAULT = Path("/proc/sys/kernel/random/boot_id")
PROC_ROOT_DEFAULT = Path("/proc")


class OriginError(ValueError):
    pass


class StateError(RuntimeError):
    pass


@dataclass(frozen=True)
class Candidate:
    source: str
    value: str


def fail(message: str) -> NoReturn:
    raise OriginError(message)


def display_value(value: str) -> str:
    if len(value) <= MAX_VALUE_LENGTH:
        return repr(value)
    return repr(value[:MAX_VALUE_LENGTH] + "...<truncated>")


def cli_candidate(field: str, value: str | None) -> Candidate | None:
    if value is None:
        return None
    normalized = value.strip()
    if not normalized:
        fail(f"--{field.replace('_', '-')} must not be empty")
    return Candidate(f"cli:--{field.replace('_', '-')}", normalized)


def environment_candidate(environ: Mapping[str, str], name: str) -> Candidate | None:
    value = environ.get(name, "").strip()
    return Candidate(f"env:{name}", value) if value else None


def native_codex_candidate(environ: Mapping[str, str]) -> Candidate | None:
    value = environ.get("CODEX_THREAD_ID", "").strip()
    return Candidate("native:CODEX_THREAD_ID", value) if value else None


def select(field: str, candidates: Sequence[Candidate | None]) -> tuple[str | None, str | None, list[dict[str, str]]]:
    present = [candidate for candidate in candidates if candidate is not None]
    if not present:
        return None, None, []
    winner = present[0]
    conflicts = [
        {
            "field": field,
            "selected_source": winner.source,
            "selected_value": winner.value[:MAX_VALUE_LENGTH],
            "ignored_source": candidate.source,
            "ignored_value": candidate.value[:MAX_VALUE_LENGTH],
        }
        for candidate in present[1:]
        if candidate.value != winner.value
    ]
    return winner.value, winner.source, conflicts


def validate_value(field: str, value: str | None, pattern: re.Pattern[str]) -> None:
    if value is not None and pattern.fullmatch(value) is None:
        fail(f"invalid {field} {display_value(value)}")


def resolve_origin(
    *,
    harness: str | None,
    session_id: str | None,
    work_lane: str | None,
    task_id: str | None,
    environ: Mapping[str, str],
    effective_uid: int | None = None,
) -> dict[str, object]:
    """Resolve one immutable origin object using CLI > environment > native precedence."""
    native_codex = native_codex_candidate(environ)
    resolved_harness, harness_source, conflicts = select(
        "harness",
        (
            cli_candidate("harness", harness),
            environment_candidate(environ, "OTHELLO_HARNESS"),
            Candidate("native:CODEX_THREAD_ID", "codex") if native_codex else None,
        ),
    )
    if resolved_harness not in HARNESS_VALUES:
        if resolved_harness is None:
            fail("harness is required (--harness or OTHELLO_HARNESS; Codex may use CODEX_THREAD_ID)")
        fail(
            f"invalid harness {display_value(resolved_harness)}; "
            f"choose one of {', '.join(HARNESS_VALUES)}"
        )

    resolved_session, session_source, session_conflicts = select(
        "session_id",
        (
            cli_candidate("session_id", session_id),
            environment_candidate(environ, "OTHELLO_SESSION_ID"),
            native_codex if resolved_harness == "codex" else None,
        ),
    )
    conflicts.extend(session_conflicts)
    resolved_lane, lane_source, lane_conflicts = select(
        "work_lane",
        (
            cli_candidate("lane", work_lane),
            environment_candidate(environ, "OTHELLO_LANE"),
        ),
    )
    conflicts.extend(lane_conflicts)
    resolved_task, task_source, task_conflicts = select(
        "task_id",
        (
            cli_candidate("task_id", task_id),
            environment_candidate(environ, "OTHELLO_TASK_ID"),
        ),
    )
    conflicts.extend(task_conflicts)

    validate_value("session ID", resolved_session, SESSION_RE)
    validate_value("work lane", resolved_lane, LANE_RE)
    validate_value("task ID", resolved_task, TASK_RE)

    if resolved_session is None:
        fail(f"session ID is required for {resolved_harness} submissions")
    if resolved_harness == "manual":
        if resolved_lane is not None or resolved_task is not None:
            fail("manual probes must not claim a work lane or C-task")
    else:
        if resolved_lane is None:
            fail(f"work lane is required for {resolved_harness} submissions")
        if resolved_task is None:
            fail(f"C-task is required for {resolved_harness} submissions")

    uid = os.geteuid() if effective_uid is None else effective_uid
    try:
        user = pwd.getpwuid(uid).pw_name
    except KeyError:
        fail(f"effective UID {uid} has no account entry")

    return {
        "user": user,
        "harness": resolved_harness,
        "session_id": resolved_session,
        "work_lane": resolved_lane,
        "task_id": resolved_task,
        "attestation": "caller" if resolved_harness != "manual" else "manual-non-task",
        "resolution": {
            "sources": {
                "harness": harness_source,
                "session_id": session_source,
                "work_lane": lane_source,
                "task_id": task_source,
            },
            "conflicts": conflicts,
        },
    }


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def canonical_json(data: Mapping[str, object]) -> bytes:
    encoded = (json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n").encode()
    if len(encoded) > MAX_RECORD_BYTES:
        raise StateError(f"JSON record exceeds {MAX_RECORD_BYTES} bytes")
    return encoded


def fsync_directory(path: Path) -> None:
    descriptor = os.open(path, os.O_RDONLY | os.O_DIRECTORY | os.O_CLOEXEC)
    try:
        os.fsync(descriptor)
    finally:
        os.close(descriptor)


def verify_private_directory(path: Path, effective_uid: int) -> None:
    if not path.is_absolute():
        raise StateError(f"directory path must be absolute: {path}")
    try:
        metadata = path.lstat()
    except OSError as error:
        raise StateError(f"cannot inspect directory {path}: {error}") from error
    if not stat.S_ISDIR(metadata.st_mode) or stat.S_ISLNK(metadata.st_mode):
        raise StateError(f"not a non-symlink directory: {path}")
    if metadata.st_uid != effective_uid:
        raise StateError(f"directory is not owned by effective UID {effective_uid}: {path}")
    if stat.S_IMODE(metadata.st_mode) != 0o700:
        raise StateError(f"directory mode must be 0700: {path}")


def ensure_state_root(path: Path, effective_uid: int) -> Path:
    absolute = path.expanduser().absolute()
    try:
        absolute.mkdir(mode=0o700)
        fsync_directory(absolute.parent)
    except FileExistsError:
        pass
    except OSError as error:
        raise StateError(f"cannot create state root {absolute}: {error}") from error
    verify_private_directory(absolute, effective_uid)
    return absolute


def read_existing_record(path: Path, effective_uid: int) -> bytes:
    try:
        before = path.lstat()
    except OSError as error:
        raise StateError(f"cannot inspect existing record {path}: {error}") from error
    if not stat.S_ISREG(before.st_mode) or stat.S_ISLNK(before.st_mode):
        raise StateError(f"existing record is not a regular non-symlink file: {path}")
    if before.st_uid != effective_uid or stat.S_IMODE(before.st_mode) != 0o600:
        raise StateError(f"existing record has unsafe owner or mode: {path}")
    if before.st_size > MAX_RECORD_BYTES:
        raise StateError(f"existing record exceeds {MAX_RECORD_BYTES} bytes: {path}")
    flags = os.O_RDONLY | os.O_CLOEXEC
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        descriptor = os.open(path, flags)
    except OSError as error:
        raise StateError(f"cannot open existing record {path}: {error}") from error
    try:
        after = os.fstat(descriptor)
        if (before.st_dev, before.st_ino) != (after.st_dev, after.st_ino):
            raise StateError(f"record changed while opening it: {path}")
        data = os.read(descriptor, MAX_RECORD_BYTES + 1)
    finally:
        os.close(descriptor)
    if len(data) > MAX_RECORD_BYTES:
        raise StateError(f"existing record exceeds {MAX_RECORD_BYTES} bytes: {path}")
    return data


def publish_set_once(path: Path, data: Mapping[str, object], effective_uid: int) -> str:
    """Atomically install canonical JSON without replacing an existing identity record."""
    verify_private_directory(path.parent, effective_uid)
    encoded = canonical_json(data)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.{uuid.uuid4().hex}.tmp")
    flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_CLOEXEC
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    descriptor = os.open(temporary, flags, 0o600)
    installed = False
    try:
        with os.fdopen(descriptor, "wb", closefd=True) as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        try:
            os.link(temporary, path, follow_symlinks=False)
            installed = True
            fsync_directory(path.parent)
        except FileExistsError:
            existing = read_existing_record(path, effective_uid)
            if existing != encoded:
                raise StateError(f"conflicting set-once record already exists: {path}")
        return hashlib.sha256(encoded).hexdigest()
    finally:
        try:
            temporary.unlink()
            if installed:
                fsync_directory(path.parent)
        except FileNotFoundError:
            pass


def parse_busctl_scalar(output: str, expected_type: str) -> str:
    try:
        fields = shlex.split(output)
    except ValueError as error:
        raise StateError(f"malformed busctl output: {display_value(output)}") from error
    if len(fields) != 2 or fields[0] != expected_type:
        raise StateError(f"unexpected busctl scalar: {display_value(output)}")
    return fields[1]


def default_run_command(command: Sequence[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        timeout=5,
        check=False,
    )


def bus_call(
    busctl: Path,
    method: str,
    signature: str,
    argument: str,
    run_command: Callable[[Sequence[str]], subprocess.CompletedProcess[str]],
) -> str:
    command = [
        str(busctl),
        "--user",
        "call",
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
        method,
        signature,
        argument,
    ]
    result = run_command(command)
    if result.returncode != 0:
        diagnostic = result.stderr.strip()[:MAX_VALUE_LENGTH]
        raise StateError(f"user-manager D-Bus query failed: {diagnostic}")
    return result.stdout


def proc_start_ticks(proc_root: Path, pid: int) -> int:
    path = proc_root / str(pid) / "stat"
    try:
        line = path.read_text()
    except OSError as error:
        raise StateError(f"cannot read user-manager process identity: {error}") from error
    _, separator, suffix = line.rpartition(")")
    fields = suffix.split()
    if not separator or len(fields) <= 19:
        raise StateError("malformed user-manager /proc stat record")
    try:
        return int(fields[19])
    except ValueError as error:
        raise StateError("invalid user-manager process start ticks") from error


def manager_generation(
    *,
    busctl: Path = BUSCTL_DEFAULT,
    boot_id_path: Path = BOOT_ID_DEFAULT,
    proc_root: Path = PROC_ROOT_DEFAULT,
    run_command: Callable[[Sequence[str]], subprocess.CompletedProcess[str]] = default_run_command,
) -> dict[str, object]:
    """Read owner -> PID -> start ticks -> owner and accept only a stable manager tuple."""
    try:
        boot_id = boot_id_path.read_text().strip()
    except OSError as error:
        raise StateError(f"cannot read host boot ID: {error}") from error
    if BOOT_ID_RE.fullmatch(boot_id) is None:
        raise StateError("invalid host boot ID")

    owner_1 = parse_busctl_scalar(
        bus_call(busctl, "GetNameOwner", "s", "org.freedesktop.systemd1", run_command), "s"
    )
    if BUS_OWNER_RE.fullmatch(owner_1) is None:
        raise StateError(f"invalid systemd D-Bus owner: {display_value(owner_1)}")
    pid_text = parse_busctl_scalar(
        bus_call(busctl, "GetConnectionUnixProcessID", "s", owner_1, run_command), "u"
    )
    try:
        pid = int(pid_text)
    except ValueError as error:
        raise StateError("invalid systemd D-Bus owner PID") from error
    if pid <= 0:
        raise StateError("invalid systemd D-Bus owner PID")
    start_ticks = proc_start_ticks(proc_root, pid)
    owner_2 = parse_busctl_scalar(
        bus_call(busctl, "GetNameOwner", "s", "org.freedesktop.systemd1", run_command), "s"
    )
    if owner_1 != owner_2:
        raise StateError("user manager changed during generation read")
    return {
        "boot_id": boot_id,
        "dbus_owner": owner_1,
        "manager_pid": pid,
        "manager_start_ticks": start_ticks,
    }


def validate_worker_argv(worker_argv: Sequence[str]) -> list[str]:
    if not worker_argv:
        raise StateError("worker argv must not be empty")
    normalized = list(worker_argv)
    if not Path(normalized[0]).is_absolute():
        raise StateError("worker executable must be absolute")
    total = 0
    for argument in normalized:
        if not isinstance(argument, str) or not argument or "\x00" in argument:
            raise StateError("worker argv contains an invalid argument")
        size = len(argument.encode())
        if size > MAX_ARG_BYTES:
            raise StateError(f"worker argument exceeds {MAX_ARG_BYTES} bytes")
        total += size
    if total > MAX_ARGV_BYTES:
        raise StateError(f"worker argv exceeds {MAX_ARGV_BYTES} bytes")
    return normalized


def prepare_submission(
    *,
    state_root: Path,
    lean_root: Path,
    worker_argv: Sequence[str],
    origin: Mapping[str, object],
    generation: Mapping[str, object],
    effective_uid: int | None = None,
    run_uuid: uuid.UUID | None = None,
) -> tuple[Path, dict[str, object], str]:
    uid = os.geteuid() if effective_uid is None else effective_uid
    root = ensure_state_root(state_root, uid)
    lean = lean_root.expanduser().absolute()
    if not lean.is_dir():
        raise StateError(f"Lean root is not a directory: {lean}")
    argv = validate_worker_argv(worker_argv)
    identity = uuid.uuid4() if run_uuid is None else run_uuid
    run_id = f"run-{identity.hex}"
    unit = f"othello-lean-{identity.hex}.service"
    run_dir = root / run_id
    try:
        run_dir.mkdir(mode=0o700)
        fsync_directory(root)
    except OSError as error:
        raise StateError(f"cannot create managed run directory {run_dir}: {error}") from error
    verify_private_directory(run_dir, uid)

    argv_digest = hashlib.sha256(canonical_json({"argv": argv})).hexdigest()
    submission: dict[str, object] = {
        "format": 1,
        "terminal_revision": 1,
        "run_id": run_id,
        "unit": unit,
        "lean_root": str(lean),
        "run_dir": str(run_dir),
        "worker_argv": argv,
        "worker_argv_sha256": argv_digest,
        "submitted_utc": utc_now(),
        "origin": dict(origin),
        "manager_generation": dict(generation),
    }
    try:
        digest = publish_set_once(run_dir / "submission.json", submission, uid)
    except Exception:
        try:
            run_dir.rmdir()
            fsync_directory(root)
        except OSError:
            pass
        raise
    return run_dir, submission, digest


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    origin = subparsers.add_parser("resolve-origin", help="print the resolved bounded origin JSON")
    origin.add_argument("--harness", choices=HARNESS_VALUES)
    origin.add_argument("--session-id")
    origin.add_argument("--lane", dest="work_lane")
    origin.add_argument("--task-id")
    subparsers.add_parser(
        "manager-generation", help="print the race-checked user-manager generation JSON"
    )
    return result


def main(argv: Sequence[str] | None = None) -> int:
    args = parser().parse_args(argv)
    try:
        if args.command == "resolve-origin":
            payload: dict[str, object] = {
                "format": 1,
                "origin": resolve_origin(
                    harness=args.harness,
                    session_id=args.session_id,
                    work_lane=args.work_lane,
                    task_id=args.task_id,
                    environ=os.environ,
                ),
            }
        else:
            payload = {"format": 1, "manager_generation": manager_generation()}
    except (OriginError, StateError) as error:
        print(f"lean-build-systemd: {error}", file=sys.stderr)
        return EXIT_INVALID
    json.dump(payload, sys.stdout, sort_keys=True, separators=(",", ":"))
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
