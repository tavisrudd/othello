#!/usr/bin/env python3
"""C225 systemd-managed Lean queue adapter, rolled out beside the legacy queue."""

from __future__ import annotations

import argparse
import ctypes
import ctypes.util
import hashlib
import json
import math
import os
import pwd
import re
import shlex
import stat
import subprocess
import sys
import time
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable, Mapping, NoReturn, Sequence


EXIT_TIMEOUT = 124
EXIT_INVALID = 125
EXIT_ABANDONED = 126
MAX_VALUE_LENGTH = 128
MAX_RECORD_BYTES = 64 * 1024
MAX_ARG_BYTES = 4096
MAX_ARGV_BYTES = 48 * 1024
HARNESS_VALUES = ("codex", "claude", "manual")
SESSION_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.:@+-]{0,127}\Z")
LANE_RE = re.compile(r"[a-z0-9][a-z0-9-]{0,63}\Z")
TASK_RE = re.compile(r"C[0-9]+\Z")
MODULE_RE = re.compile(r"[A-Za-z0-9_]+(?:\.[A-Za-z0-9_]+)*\Z")
BUS_OWNER_RE = re.compile(r":[0-9]+\.[0-9]+\Z")
BOOT_ID_RE = re.compile(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}\Z")
STATE_ROOT_DEFAULT = Path.home() / ".cache" / "othello-lean-build-systemd"
LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
BUSCTL_DEFAULT = Path("/run/current-system/sw/bin/busctl")
BOOT_ID_DEFAULT = Path("/proc/sys/kernel/random/boot_id")
PROC_ROOT_DEFAULT = Path("/proc")
SYSTEMCTL_DEFAULT = Path("/run/current-system/sw/bin/systemctl")
SYSTEMD_RUN_DEFAULT = Path("/run/current-system/sw/bin/systemd-run")
WORKER_DEFAULT = Path(__file__).resolve().with_name("lean-build-systemd-worker.py")
PROFILE_FILE_DEFAULT = Path(__file__).resolve().with_name("lean-build-profiles.json")
LEGACY_STATE_ROOT_DEFAULT = Path.home() / ".cache" / "othello-lean-build"
ACCEPT_TIMEOUT = 10.0


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


class SystemdBusLease:
    """One persistent sd-bus connection holding the C225 subscription and unit reference."""

    def __init__(self) -> None:
        library_name = ctypes.util.find_library("systemd")
        nixos_library = Path("/run/current-system/sw/lib/libsystemd.so.0")
        if library_name is None and nixos_library.is_file():
            library_name = str(nixos_library)
        if library_name is None:
            raise StateError("libsystemd is unavailable")
        self.library = ctypes.CDLL(library_name)
        self.library.sd_bus_open_user.argtypes = [ctypes.POINTER(ctypes.c_void_p)]
        self.library.sd_bus_open_user.restype = ctypes.c_int
        self.library.sd_bus_message_new_method_call.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_char_p,
            ctypes.c_char_p,
            ctypes.c_char_p,
            ctypes.c_char_p,
        ]
        self.library.sd_bus_message_new_method_call.restype = ctypes.c_int
        self.library.sd_bus_message_append_basic.argtypes = [
            ctypes.c_void_p,
            ctypes.c_char,
            ctypes.c_void_p,
        ]
        self.library.sd_bus_message_append_basic.restype = ctypes.c_int
        self.library.sd_bus_call.argtypes = [
            ctypes.c_void_p,
            ctypes.c_void_p,
            ctypes.c_uint64,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
        ]
        self.library.sd_bus_call.restype = ctypes.c_int
        self.library.sd_bus_process.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
        self.library.sd_bus_process.restype = ctypes.c_int
        self.library.sd_bus_wait.argtypes = [ctypes.c_void_p, ctypes.c_uint64]
        self.library.sd_bus_wait.restype = ctypes.c_int
        self.library.sd_bus_add_match.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_char_p,
            ctypes.c_void_p,
            ctypes.c_void_p,
        ]
        self.library.sd_bus_add_match.restype = ctypes.c_int
        self.library.sd_bus_slot_unref.argtypes = [ctypes.c_void_p]
        self.library.sd_bus_slot_unref.restype = ctypes.c_void_p
        self.library.sd_bus_message_unref.argtypes = [ctypes.c_void_p]
        self.library.sd_bus_message_unref.restype = ctypes.c_void_p
        self.library.sd_bus_unref.argtypes = [ctypes.c_void_p]
        self.library.sd_bus_unref.restype = ctypes.c_void_p
        self.bus = ctypes.c_void_p()
        self.referenced_unit: str | None = None
        self.match_slots: list[ctypes.c_void_p] = []
        self.event_count = 0
        callback_type = ctypes.CFUNCTYPE(
            ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p
        )

        def record_event(_message: object, _userdata: object, _error: object) -> int:
            self.event_count += 1
            return 0

        self.match_callback = callback_type(record_event)
        result = self.library.sd_bus_open_user(ctypes.byref(self.bus))
        if result < 0:
            raise StateError(f"cannot open user-manager D-Bus: {os.strerror(-result)}")
        try:
            self._call("Subscribe")
            self._add_match(
                "type='signal',sender='org.freedesktop.systemd1',"
                "interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',"
                "path_namespace='/org/freedesktop/systemd1/unit'"
            )
            self._add_match(
                "type='signal',sender='org.freedesktop.systemd1',"
                "interface='org.freedesktop.systemd1.Manager',member='UnitRemoved',"
                "path='/org/freedesktop/systemd1'"
            )
        except Exception:
            self.close()
            raise

    def _add_match(self, expression: str) -> None:
        slot = ctypes.c_void_p()
        result = self.library.sd_bus_add_match(
            self.bus,
            ctypes.byref(slot),
            expression.encode(),
            ctypes.cast(self.match_callback, ctypes.c_void_p),
            None,
        )
        if result < 0:
            raise StateError(f"cannot install D-Bus signal match: {os.strerror(-result)}")
        self.match_slots.append(slot)

    def _call(self, member: str, string_argument: str | None = None) -> None:
        message = ctypes.c_void_p()
        reply = ctypes.c_void_p()
        result = self.library.sd_bus_message_new_method_call(
            self.bus,
            ctypes.byref(message),
            b"org.freedesktop.systemd1",
            b"/org/freedesktop/systemd1",
            b"org.freedesktop.systemd1.Manager",
            member.encode(),
        )
        if result < 0:
            raise StateError(f"cannot create D-Bus {member} call: {os.strerror(-result)}")
        try:
            if string_argument is not None:
                encoded = ctypes.c_char_p(string_argument.encode())
                result = self.library.sd_bus_message_append_basic(
                    message, b"s", ctypes.cast(encoded, ctypes.c_void_p)
                )
                if result < 0:
                    raise StateError(f"cannot encode D-Bus {member} call: {os.strerror(-result)}")
            result = self.library.sd_bus_call(self.bus, message, 0, None, ctypes.byref(reply))
            if result < 0:
                raise StateError(f"D-Bus {member} failed: {os.strerror(-result)}")
        finally:
            if reply:
                self.library.sd_bus_message_unref(reply)
            self.library.sd_bus_message_unref(message)

    def ref_unit(self, unit: str) -> None:
        if self.referenced_unit is not None:
            raise StateError("D-Bus lease already references a unit")
        self._call("RefUnit", unit)
        self.referenced_unit = unit

    def wait_for_change(self, timeout: float) -> bool:
        """Drain queued signals, then block in sd-bus until one arrives or time expires."""
        previous_events = self.event_count
        while True:
            result = self.library.sd_bus_process(self.bus, None)
            if result < 0:
                raise StateError(f"cannot process user-manager D-Bus: {os.strerror(-result)}")
            if result == 0:
                break
        if self.event_count != previous_events:
            return True
        if timeout <= 0:
            return False
        microseconds = min(int(timeout * 1_000_000), (1 << 64) - 2)
        result = self.library.sd_bus_wait(self.bus, microseconds)
        if result < 0:
            raise StateError(f"cannot wait on user-manager D-Bus: {os.strerror(-result)}")
        if result == 0:
            return False
        while True:
            result = self.library.sd_bus_process(self.bus, None)
            if result < 0:
                raise StateError(f"cannot process user-manager D-Bus: {os.strerror(-result)}")
            if result == 0:
                break
        return True

    def close(self) -> None:
        if not getattr(self, "bus", None):
            return
        if self.referenced_unit is not None:
            try:
                self._call("UnrefUnit", self.referenced_unit)
            except StateError:
                pass
            self.referenced_unit = None
        for slot in self.match_slots:
            self.library.sd_bus_slot_unref(slot)
        self.match_slots.clear()
        try:
            self._call("Unsubscribe")
        except StateError:
            pass
        self.library.sd_bus_unref(self.bus)
        self.bus = ctypes.c_void_p()

    def __enter__(self) -> "SystemdBusLease":
        return self

    def __exit__(self, _type: object, _value: object, _traceback: object) -> None:
        self.close()


def systemd_object_path(unit: str) -> str:
    encoded = "".join(
        chr(byte) if chr(byte).isalnum() else f"_{byte:02x}" for byte in unit.encode()
    )
    return f"/org/freedesktop/systemd1/unit/{encoded}"


def unit_snapshot(
    unit: str,
    *,
    systemctl: Path = SYSTEMCTL_DEFAULT,
    busctl: Path = BUSCTL_DEFAULT,
    run_command: Callable[[Sequence[str]], subprocess.CompletedProcess[str]] = default_run_command,
) -> dict[str, object] | None:
    properties = (
        "Id",
        "LoadState",
        "Transient",
        "InvocationID",
        "WorkingDirectory",
        "Environment",
        "ActiveState",
        "SubState",
        "Result",
        "ExecMainCode",
        "ExecMainStatus",
    )
    command = [str(systemctl), "--user", "show", unit, "--no-pager"]
    command.extend(f"--property={name}" for name in properties)
    result = run_command(command)
    if result.returncode != 0:
        return None
    values: dict[str, str] = {}
    for line in result.stdout.splitlines():
        key, separator, value = line.partition("=")
        if separator:
            values[key] = value
    if values.get("Id") != unit or values.get("LoadState") != "loaded":
        return None

    exec_result = run_command(
        [
            str(busctl),
            "--user",
            "--json=short",
            "get-property",
            "org.freedesktop.systemd1",
            systemd_object_path(unit),
            "org.freedesktop.systemd1.Service",
            "ExecStart",
        ]
    )
    if exec_result.returncode != 0:
        raise StateError("cannot read transient service ExecStart")
    try:
        exec_data = json.loads(exec_result.stdout)
        entries = exec_data["data"]
        argv = entries[0][1]
    except (KeyError, IndexError, TypeError, json.JSONDecodeError) as error:
        raise StateError("malformed transient service ExecStart") from error
    if not isinstance(argv, list) or not all(isinstance(item, str) for item in argv):
        raise StateError("malformed transient service argv")
    try:
        environment = shlex.split(values.get("Environment", ""))
    except ValueError as error:
        raise StateError("malformed transient service environment") from error
    return {**values, "ExecStartArgv": argv, "EnvironmentEntries": environment}


def transient_command(
    submission: Mapping[str, object],
    submission_digest: str,
    *,
    systemd_run: Path = SYSTEMD_RUN_DEFAULT,
) -> list[str]:
    unit = str(submission["unit"])
    origin = submission["origin"]
    if not isinstance(origin, Mapping):
        raise StateError("submission origin is malformed")
    lane = origin.get("work_lane") or "manual"
    task = origin.get("task_id") or "probe"
    harness = origin.get("harness") or "unknown"
    session = str(origin.get("session_id") or "unknown")[:12]
    worker_argv = submission["worker_argv"]
    if not isinstance(worker_argv, list) or not all(isinstance(item, str) for item in worker_argv):
        raise StateError("submission worker argv is malformed")
    return [
        str(systemd_run),
        "--user",
        "--wait",
        "--quiet",
        "--service-type=exec",
        "--expand-environment=no",
        f"--unit={unit.removesuffix('.service')}",
        f"--description=Othello Lean [{lane}/{task}] {harness}:{session}",
        f"--working-directory={submission['lean_root']}",
        f"--setenv=OTHELLO_LEAN_RUN_ID={submission['run_id']}",
        f"--setenv=OTHELLO_LEAN_SUBMISSION_SHA256={submission_digest}",
        "--property=KillMode=mixed",
        "--property=SendSIGKILL=yes",
        "--property=TimeoutStopSec=120s",
        *worker_argv,
    ]


def validate_acceptance_snapshot(
    submission: Mapping[str, object],
    submission_digest: str,
    snapshot: Mapping[str, object],
    current_generation: Mapping[str, object],
) -> dict[str, object]:
    if dict(current_generation) != submission.get("manager_generation"):
        raise StateError("user-manager generation changed before acceptance")
    unit = submission.get("unit")
    if snapshot.get("Id") != unit or snapshot.get("Transient") != "yes":
        raise StateError("transient unit identity mismatch")
    invocation_id = snapshot.get("InvocationID")
    if not isinstance(invocation_id, str) or not re.fullmatch(r"[0-9a-f]{32}", invocation_id):
        raise StateError("transient unit has no valid InvocationID")
    if snapshot.get("WorkingDirectory") != submission.get("lean_root"):
        raise StateError("transient unit working directory mismatch")
    if snapshot.get("ExecStartArgv") != submission.get("worker_argv"):
        raise StateError("transient unit argv mismatch")
    environment = snapshot.get("EnvironmentEntries")
    required_environment = {
        f"OTHELLO_LEAN_RUN_ID={submission.get('run_id')}",
        f"OTHELLO_LEAN_SUBMISSION_SHA256={submission_digest}",
    }
    if not isinstance(environment, list) or not required_environment.issubset(set(environment)):
        raise StateError("transient unit environment nonce mismatch")
    return {
        "format": 1,
        "run_id": submission["run_id"],
        "unit": unit,
        "invocation_id": invocation_id,
        "manager_generation": dict(current_generation),
        "submission_sha256": submission_digest,
    }


def read_status_record(run_dir: Path, effective_uid: int) -> dict[str, object] | None:
    path = run_dir / "status.json"
    try:
        path.lstat()
    except FileNotFoundError:
        return None
    except OSError as error:
        raise StateError(f"cannot inspect status record: {error}") from error
    encoded = read_existing_record(path, effective_uid)
    try:
        data = json.loads(encoded)
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise StateError("status record is malformed") from error
    if not isinstance(data, dict):
        raise StateError("status record must contain one object")
    return data


def read_json_record(path: Path, effective_uid: int) -> dict[str, object]:
    encoded = read_existing_record(path, effective_uid)
    try:
        data = json.loads(encoded)
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise StateError(f"{path.name} is malformed") from error
    if not isinstance(data, dict):
        raise StateError(f"{path.name} must contain one object")
    return data


def read_reattachment_identity(
    run_dir: Path, effective_uid: int
) -> tuple[dict[str, object], dict[str, object], str]:
    verify_private_directory(run_dir, effective_uid)
    submission_path = run_dir / "submission.json"
    encoded = read_existing_record(submission_path, effective_uid)
    try:
        submission = json.loads(encoded)
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise StateError("submission.json is malformed") from error
    if not isinstance(submission, dict) or submission.get("format") != 1:
        raise StateError("submission identity or format mismatch")
    if submission.get("run_dir") != str(run_dir):
        raise StateError("submission run-directory mismatch")
    digest = hashlib.sha256(encoded).hexdigest()
    accepted = read_json_record(run_dir / "accepted.json", effective_uid)
    expected = {
        "format": 1,
        "run_id": submission.get("run_id"),
        "unit": submission.get("unit"),
        "manager_generation": submission.get("manager_generation"),
        "submission_sha256": digest,
    }
    if any(accepted.get(key) != value for key, value in expected.items()):
        raise StateError("accepted identity does not match immutable submission")
    invocation_id = accepted.get("invocation_id")
    if not isinstance(invocation_id, str) or re.fullmatch(r"[0-9a-f]{32}", invocation_id) is None:
        raise StateError("accepted record has no valid InvocationID")
    return submission, accepted, digest


def validate_reattachment_status(
    status: Mapping[str, object] | None, submission: Mapping[str, object]
) -> None:
    if status is not None and (
        status.get("format") != 2 or status.get("run_id") != submission.get("run_id")
    ):
        raise StateError("canonical status identity or format mismatch")


def integer_property(snapshot: Mapping[str, object] | None, name: str) -> int | None:
    if snapshot is None:
        return None
    value = snapshot.get(name)
    try:
        return int(value) if value not in (None, "") else None
    except (TypeError, ValueError):
        return None


def completion_envelope(
    *,
    submission: Mapping[str, object],
    accepted: Mapping[str, object],
    status: Mapping[str, object] | None,
    service: Mapping[str, object] | None,
    client_returncode: int,
) -> dict[str, object]:
    terminal_states = {"success", "failed", "refused", "interrupted"}
    if status is not None:
        if status.get("format") != 2 or status.get("run_id") != submission.get("run_id"):
            raise StateError("canonical status identity or format mismatch")
    if service is not None and service.get("InvocationID") != accepted.get("invocation_id"):
        raise StateError("completion service InvocationID mismatch")
    canonical_state = status.get("state") if status is not None else None
    phase = status.get("phase") if status is not None else None
    queue_exit_code = status.get("queue_exit_code") if status is not None else None
    if canonical_state in terminal_states:
        if not isinstance(queue_exit_code, int):
            raise StateError("terminal canonical status has no integer queue exit code")
        if client_returncode != queue_exit_code:
            raise StateError("queue status and systemd-run exit code conflict")
        effective_state = canonical_state
        adapter_exit_code = queue_exit_code
        reason = status.get("reason")
    elif status is None:
        if client_returncode == 0:
            effective_state, adapter_exit_code = "unknown", EXIT_INVALID
            reason = "service exited successfully without canonical status"
        else:
            effective_state, adapter_exit_code = "failed-before-status", 1
            reason = "worker exited before canonical status creation"
    elif client_returncode != 0:
        effective_state, adapter_exit_code = "abandoned", EXIT_ABANDONED
        reason = "service exited abnormally with nonterminal canonical status"
    else:
        effective_state, adapter_exit_code = "unknown", EXIT_INVALID
        reason = "service exited with nonterminal canonical status"

    origin = submission.get("origin")
    if not isinstance(origin, Mapping):
        raise StateError("submission origin is malformed")
    service_result = service.get("Result") if service is not None else None
    return {
        "format": 1,
        "run_id": submission["run_id"],
        "unit": submission["unit"],
        "invocation_id": accepted["invocation_id"],
        "origin": dict(origin),
        "canonical_state": canonical_state,
        "effective_state": effective_state,
        "phase": phase,
        "queue_exit_code": queue_exit_code,
        "service_result": service_result,
        "service_exit_code": integer_property(service, "ExecMainStatus"),
        "adapter_exit_code": adapter_exit_code,
        "event_id": f"lean-queue:{submission['run_id']}:terminal:1",
        "reason": str(reason)[:MAX_VALUE_LENGTH] if reason is not None else None,
    }


def observation_envelope(
    submission: Mapping[str, object],
    accepted: Mapping[str, object],
    status: Mapping[str, object] | None,
    *,
    effective_state: str,
    adapter_exit_code: int,
    reason: str,
) -> dict[str, object]:
    origin = submission.get("origin")
    if not isinstance(origin, Mapping):
        raise StateError("submission origin is malformed")
    return {
        "format": 1,
        "run_id": submission["run_id"],
        "unit": submission["unit"],
        "invocation_id": accepted["invocation_id"],
        "origin": dict(origin),
        "canonical_state": status.get("state") if status is not None else None,
        "effective_state": effective_state,
        "phase": status.get("phase") if status is not None else None,
        "queue_exit_code": status.get("queue_exit_code") if status is not None else None,
        "service_result": None,
        "service_exit_code": None,
        "adapter_exit_code": adapter_exit_code,
        "event_id": f"lean-queue:{submission['run_id']}:terminal:1",
        "reason": reason[:MAX_VALUE_LENGTH],
    }


def service_client_returncode(service: Mapping[str, object]) -> int:
    result = service.get("Result")
    status = integer_property(service, "ExecMainStatus")
    if result == "success":
        return 0
    if result == "exit-code" and status is not None:
        return status
    return 255


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


def lock_slug(lean_root: Path) -> str:
    return str(lean_root).strip("/").replace("/", "_") or "root"


def managed_worker_argv(
    args: argparse.Namespace, run_dir: Path, lock_file: Path
) -> list[str]:
    argv = [
        os.path.abspath(sys.executable),
        str(WORKER_DEFAULT.absolute()),
        "run",
        *args.targets,
        "--run-dir",
        str(run_dir),
        "--lock-file",
        str(lock_file),
    ]
    for target in args.serial_first:
        argv.extend(("--serial-first", target))
    if args.aggregate is not None:
        argv.append("--aggregate")
        argv.extend(args.aggregate)
    if args.cores is not None:
        argv.extend(("--cores", args.cores))
    argv.extend(
        (
            "--threads",
            str(args.threads),
            "--profile",
            args.profile,
            "--profile-file",
            str(args.profile_file.expanduser().absolute()),
            "--meminfo",
            str(args.meminfo.expanduser().absolute()),
            "--mountinfo",
            str(args.mountinfo.expanduser().absolute()),
            "--tmp-path",
            str(args.tmp_path.expanduser().absolute()),
            "--choom-adjust",
            str(args.choom_adjust),
            "--wait-quiet-seconds",
            str(args.wait_quiet_seconds),
            "--poll-seconds",
            str(args.poll_seconds),
            "--tail-lines",
            str(args.tail_lines),
            "--nix-binary",
            args.nix_binary,
            "--time-binary",
            args.time_binary,
            "--taskset-binary",
            args.taskset_binary,
            "--choom-binary",
            args.choom_binary,
            "--pgrep-binary",
            args.pgrep_binary,
            "--run-quiet-binary",
            args.run_quiet_binary,
        )
    )
    if args.tmp_used_mib is not None:
        argv.extend(("--tmp-used-mib", str(args.tmp_used_mib)))
    return argv


def run_managed_cli(
    args: argparse.Namespace,
    *,
    environ: Mapping[str, str],
    generation_reader: Callable[[], Mapping[str, object]] = manager_generation,
    launcher: Callable[..., tuple[dict[str, object], dict[str, object], str]] | None = None,
) -> tuple[dict[str, object], str]:
    lean_root = args.lean_root.expanduser().absolute()
    if not (lean_root / "lakefile.lean").is_file() and not (lean_root / "lakefile.toml").is_file():
        raise StateError(f"Lean root is not a Lake package: {lean_root}")
    targets = [*args.targets, *args.serial_first, *(args.aggregate or [])]
    invalid = next((target for target in targets if MODULE_RE.fullmatch(target) is None), None)
    if invalid is not None:
        raise StateError(f"invalid Lean module name: {display_value(invalid)}")
    origin = resolve_origin(
        harness=args.harness,
        session_id=args.session_id,
        work_lane=args.work_lane,
        task_id=args.task_id,
        environ=environ,
    )
    identity = uuid.uuid4()
    state_root = args.state_root.expanduser().absolute()
    run_dir = state_root / f"run-{identity.hex}"
    lock_file = (
        args.lock_file.expanduser().absolute()
        if args.lock_file is not None
        else LEGACY_STATE_ROOT_DEFAULT / "locks" / f"{lock_slug(lean_root)}.lock"
    )
    worker_argv = managed_worker_argv(args, run_dir, lock_file)
    actual_run_dir, submission, digest = prepare_submission(
        state_root=state_root,
        lean_root=lean_root,
        worker_argv=worker_argv,
        origin=origin,
        generation=dict(generation_reader()),
        run_uuid=identity,
    )
    if actual_run_dir != run_dir:
        raise StateError("prepared run directory differs from reserved identity")
    launch = launch_accept_and_wait if launcher is None else launcher
    _, completion, diagnostic = launch(
        run_dir=run_dir,
        submission=submission,
        submission_digest=digest,
    )
    return completion, diagnostic


def reattach_and_wait(
    *,
    run_dir: Path,
    timeout: float | None = None,
    effective_uid: int | None = None,
    systemctl: Path = SYSTEMCTL_DEFAULT,
    busctl: Path = BUSCTL_DEFAULT,
    lease_factory: Callable[[], SystemdBusLease] = SystemdBusLease,
    snapshot_reader: Callable[..., dict[str, object] | None] = unit_snapshot,
    generation_reader: Callable[[], Mapping[str, object]] = manager_generation,
    notify_callback: Callable[[dict[str, object]], None] | None = None,
    run_command: Callable[[Sequence[str]], subprocess.CompletedProcess[str]] = default_run_command,
) -> tuple[dict[str, object], str]:
    """Reattach to one accepted invocation and wait on D-Bus without repository polling."""
    if timeout is not None and (not math.isfinite(timeout) or timeout < 0):
        raise StateError("timeout must be a finite nonnegative number")
    uid = os.geteuid() if effective_uid is None else effective_uid
    absolute_run_dir = run_dir.expanduser().absolute()
    submission, accepted, _ = read_reattachment_identity(absolute_run_dir, uid)
    completion_path = absolute_run_dir / "completion.json"
    if completion_path.exists():
        completion = read_json_record(completion_path, uid)
        if (
            completion.get("run_id") != submission.get("run_id")
            or completion.get("unit") != submission.get("unit")
            or completion.get("invocation_id") != accepted.get("invocation_id")
            or completion.get("event_id")
            != f"lean-queue:{submission['run_id']}:terminal:1"
            or completion.get("format") != 1
            or completion.get("origin") != submission.get("origin")
            or not isinstance(completion.get("adapter_exit_code"), int)
        ):
            raise StateError("completion identity mismatch")
        diagnostic = ""
        if notify_callback is not None:
            try:
                notify_callback(completion)
            except Exception as error:
                diagnostic = f"callback failed: {str(error)[:MAX_VALUE_LENGTH]}"
        return completion, diagnostic

    diagnostics: list[str] = []
    deadline = None if timeout is None else time.monotonic() + timeout
    with lease_factory() as lease:
        try:
            current_generation = dict(generation_reader())
        except StateError as error:
            status = read_status_record(absolute_run_dir, uid)
            validate_reattachment_status(status, submission)
            return observation_envelope(
                submission,
                accepted,
                status,
                effective_state="unknown",
                adapter_exit_code=EXIT_INVALID,
                reason=f"user-manager evidence unavailable: {error}",
            ), ""
        if current_generation != submission.get("manager_generation"):
            status = read_status_record(absolute_run_dir, uid)
            validate_reattachment_status(status, submission)
            return observation_envelope(
                submission,
                accepted,
                status,
                effective_state="unknown",
                adapter_exit_code=EXIT_INVALID,
                reason="user-manager generation no longer matches submission",
            ), ""

        unit = str(submission["unit"])
        service = snapshot_reader(unit, systemctl=systemctl, busctl=busctl)
        if service is not None:
            lease.ref_unit(unit)
            service = snapshot_reader(unit, systemctl=systemctl, busctl=busctl)

        while True:
            status = read_status_record(absolute_run_dir, uid)
            validate_reattachment_status(status, submission)
            if service is not None and service.get("InvocationID") != accepted.get("invocation_id"):
                raise StateError("reattached service InvocationID mismatch")
            canonical_terminal = status is not None and status.get("state") in {
                "success",
                "failed",
                "refused",
                "interrupted",
            }
            service_terminal = service is not None and service.get("ActiveState") in {
                "inactive",
                "failed",
            }
            if (canonical_terminal and service is None) or service_terminal:
                client_returncode = (
                    int(status["queue_exit_code"])
                    if service is None and canonical_terminal
                    else service_client_returncode(service)
                )
                completion = completion_envelope(
                    submission=submission,
                    accepted=accepted,
                    status=status,
                    service=service,
                    client_returncode=client_returncode,
                )
                publish_set_once(completion_path, completion, uid)
                if notify_callback is not None:
                    try:
                        notify_callback(completion)
                    except Exception as error:
                        diagnostics.append(f"callback failed: {str(error)[:MAX_VALUE_LENGTH]}")
                if service is not None and (
                    service.get("ActiveState") == "failed" or service.get("Result") != "success"
                ):
                    cleanup = run_command(
                        [str(systemctl), "--user", "reset-failed", unit]
                    )
                    if cleanup.returncode != 0:
                        diagnostics.append(
                            f"cleanup failed: {cleanup.stderr.strip()[:MAX_VALUE_LENGTH]}"
                        )
                return completion, "; ".join(diagnostics)[:MAX_VALUE_LENGTH]
            if service is None:
                return observation_envelope(
                    submission,
                    accepted,
                    status,
                    effective_state="unknown",
                    adapter_exit_code=EXIT_INVALID,
                    reason="unit is absent and canonical status is nonterminal or missing",
                ), ""

            remaining = None if deadline is None else deadline - time.monotonic()
            if remaining is not None and remaining <= 0:
                service = snapshot_reader(unit, systemctl=systemctl, busctl=busctl)
                status = read_status_record(absolute_run_dir, uid)
                validate_reattachment_status(status, submission)
                if service is not None and service.get("InvocationID") != accepted.get("invocation_id"):
                    raise StateError("reattached service InvocationID mismatch")
                if service is not None and service.get("ActiveState") in {"inactive", "failed"}:
                    continue
                return observation_envelope(
                    submission,
                    accepted,
                    status,
                    effective_state="unknown",
                    adapter_exit_code=EXIT_TIMEOUT,
                    reason="caller timeout expired; service was not stopped or reset",
                ), ""
            lease.wait_for_change(remaining if remaining is not None else 24 * 60 * 60)
            service = snapshot_reader(unit, systemctl=systemctl, busctl=busctl)


def launch_accept_and_wait(
    *,
    run_dir: Path,
    submission: Mapping[str, object],
    submission_digest: str,
    effective_uid: int | None = None,
    systemd_run: Path = SYSTEMD_RUN_DEFAULT,
    systemctl: Path = SYSTEMCTL_DEFAULT,
    busctl: Path = BUSCTL_DEFAULT,
    completion_timeout: float | None = None,
    lease_factory: Callable[[], SystemdBusLease] = SystemdBusLease,
    notify_callback: Callable[[dict[str, object]], None] | None = None,
) -> tuple[dict[str, object], dict[str, object], str]:
    uid = os.geteuid() if effective_uid is None else effective_uid
    verify_private_directory(run_dir, uid)
    client: subprocess.Popen[str] | None = None
    with lease_factory() as lease:
        client = subprocess.Popen(
            transient_command(submission, submission_digest, systemd_run=systemd_run),
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        try:
            deadline = time.monotonic() + ACCEPT_TIMEOUT
            snapshot: dict[str, object] | None = None
            while time.monotonic() < deadline:
                snapshot = unit_snapshot(
                    str(submission["unit"]), systemctl=systemctl, busctl=busctl
                )
                if snapshot is not None:
                    lease.ref_unit(str(submission["unit"]))
                    snapshot = unit_snapshot(
                        str(submission["unit"]), systemctl=systemctl, busctl=busctl
                    )
                    if snapshot is not None:
                        break
                if client.poll() is not None:
                    _, stderr = client.communicate(timeout=2)
                    raise StateError(
                        f"systemd-run exited before acceptance: rc={client.returncode}, "
                        f"diagnostic={display_value(stderr.strip())}"
                    )
                time.sleep(0.05)
            if snapshot is None:
                raise StateError("timed out before transient-unit acceptance")
            accepted = validate_acceptance_snapshot(
                submission, submission_digest, snapshot, manager_generation()
            )
            publish_set_once(run_dir / "accepted.json", accepted, uid)
            _, stderr = client.communicate(timeout=completion_timeout)
            service = unit_snapshot(
                str(submission["unit"]), systemctl=systemctl, busctl=busctl
            )
            status = read_status_record(run_dir, uid)
            completion = completion_envelope(
                submission=submission,
                accepted=accepted,
                status=status,
                service=service,
                client_returncode=int(client.returncode),
            )
            publish_set_once(run_dir / "completion.json", completion, uid)
            diagnostics = [stderr.strip()[:MAX_VALUE_LENGTH]] if stderr.strip() else []
            if notify_callback is not None:
                try:
                    notify_callback(completion)
                except Exception as error:
                    diagnostics.append(f"callback failed: {str(error)[:MAX_VALUE_LENGTH]}")
            if service is not None and (
                service.get("ActiveState") == "failed" or service.get("Result") != "success"
            ):
                cleanup = default_run_command(
                    [str(systemctl), "--user", "reset-failed", str(submission["unit"])]
                )
                if cleanup.returncode != 0:
                    diagnostics.append(
                        f"cleanup failed: {cleanup.stderr.strip()[:MAX_VALUE_LENGTH]}"
                    )
            return accepted, completion, "; ".join(diagnostics)[:MAX_VALUE_LENGTH]
        except Exception:
            if client.poll() is None:
                client.terminate()
                try:
                    client.communicate(timeout=2)
                except subprocess.TimeoutExpired:
                    client.kill()
                    client.communicate(timeout=2)
            raise


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
    await_parser = subparsers.add_parser(
        "await", help="reattach to one accepted managed run and emit one bounded JSON envelope"
    )
    await_parser.add_argument("run_dir", type=Path)
    await_parser.add_argument("--timeout", type=float)
    run = subparsers.add_parser(
        "run", help="submit and block on one adjacent systemd-managed Lean queue"
    )
    run.add_argument("targets", nargs="+", help="Lean modules to build, in order")
    run.add_argument("--harness", choices=HARNESS_VALUES)
    run.add_argument("--session-id")
    run.add_argument("--lane", dest="work_lane")
    run.add_argument("--task-id")
    run.add_argument("--state-root", type=Path, default=STATE_ROOT_DEFAULT)
    run.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT)
    run.add_argument("--lock-file", type=Path)
    run.add_argument("--serial-first", action="append", default=[], metavar="MODULE")
    run.add_argument("--aggregate", nargs="+", default=None)
    run.add_argument("--cores", default=None)
    run.add_argument("--threads", type=positive_int, default=1)
    run.add_argument("--profile", default="single")
    run.add_argument("--profile-file", type=Path, default=PROFILE_FILE_DEFAULT)
    run.add_argument("--meminfo", type=Path, default=Path("/proc/meminfo"), help=argparse.SUPPRESS)
    run.add_argument(
        "--mountinfo", type=Path, default=Path("/proc/self/mountinfo"), help=argparse.SUPPRESS
    )
    run.add_argument("--tmp-path", type=Path, default=Path("/tmp"), help=argparse.SUPPRESS)
    run.add_argument("--tmp-used-mib", type=nonnegative_int, default=None, help=argparse.SUPPRESS)
    run.add_argument("--choom-adjust", type=oom_adjust, default=1000)
    run.add_argument("--wait-quiet-seconds", type=nonnegative_int, default=0)
    run.add_argument("--poll-seconds", type=positive_int, default=60)
    run.add_argument("--tail-lines", type=nonnegative_int, default=80)
    run.add_argument("--nix-binary", default="nix")
    run.add_argument("--time-binary", default="/usr/bin/time")
    run.add_argument("--taskset-binary", default="taskset")
    run.add_argument("--choom-binary", default="choom")
    run.add_argument("--pgrep-binary", default="pgrep")
    run.add_argument("--run-quiet-binary", default=str(Path.home() / ".claude/bin/run-quiet"))
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
        elif args.command == "manager-generation":
            payload = {"format": 1, "manager_generation": manager_generation()}
        elif args.command == "await":
            payload, diagnostic = reattach_and_wait(run_dir=args.run_dir, timeout=args.timeout)
            if diagnostic:
                print(f"lean-build-systemd: {diagnostic}", file=sys.stderr)
        else:
            payload, diagnostic = run_managed_cli(args, environ=os.environ)
            if diagnostic:
                print(f"lean-build-systemd: {diagnostic}", file=sys.stderr)
    except (OriginError, StateError) as error:
        print(f"lean-build-systemd: {error}", file=sys.stderr)
        return EXIT_INVALID
    json.dump(payload, sys.stdout, sort_keys=True, separators=(",", ":"))
    sys.stdout.write("\n")
    return (
        int(payload.get("adapter_exit_code", 0))
        if args.command in {"await", "run"}
        else 0
    )


if __name__ == "__main__":
    raise SystemExit(main())
