#!/usr/bin/env python3
"""Strict managed-worker substrate for the side-by-side C225 queue.

The current command is a non-Lean lock fixture used to validate adoption and status ordering. It
never invokes Lake or the legacy queue.
"""

from __future__ import annotations

import argparse
import fcntl
import hashlib
import importlib.util
import json
import os
import pwd
import stat
import sys
import time
import uuid
from pathlib import Path
from typing import Mapping, NoReturn, Sequence


ADAPTER_PATH = Path(__file__).resolve().with_name("lean-build-systemd.py")
SPEC = importlib.util.spec_from_file_location("lean_build_systemd_adapter", ADAPTER_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError(f"cannot load C225 adapter from {ADAPTER_PATH}")
ADAPTER = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = ADAPTER
SPEC.loader.exec_module(ADAPTER)

EXIT_OK = 0
EXIT_FAILED = 1
EXIT_REFUSED = 2
EXIT_INVALID = 125


class AdoptionError(RuntimeError):
    pass


def fail(message: str) -> NoReturn:
    raise AdoptionError(message)


def current_argv() -> list[str]:
    return [os.path.abspath(sys.executable), str(Path(__file__).absolute()), *sys.argv[1:]]


def validate_private_directory(path: Path, effective_uid: int, label: str) -> os.stat_result:
    if not path.is_absolute():
        fail(f"{label} path must be absolute")
    try:
        metadata = path.lstat()
    except OSError as error:
        fail(f"cannot inspect {label}: {error}")
    if not stat.S_ISDIR(metadata.st_mode) or stat.S_ISLNK(metadata.st_mode):
        fail(f"{label} must be a non-symlink directory")
    if metadata.st_uid != effective_uid:
        fail(f"{label} is not owned by effective UID {effective_uid}")
    if stat.S_IMODE(metadata.st_mode) != 0o700:
        fail(f"{label} mode must be 0700")
    return metadata


def read_submission(path: Path, effective_uid: int) -> tuple[dict[str, object], bytes]:
    try:
        before = path.lstat()
    except OSError as error:
        fail(f"cannot inspect submission.json: {error}")
    if not stat.S_ISREG(before.st_mode) or stat.S_ISLNK(before.st_mode):
        fail("submission.json must be a regular non-symlink file")
    if before.st_uid != effective_uid or stat.S_IMODE(before.st_mode) != 0o600:
        fail("submission.json has unsafe owner or mode")
    if before.st_size > ADAPTER.MAX_RECORD_BYTES:
        fail("submission.json is oversized")
    flags = os.O_RDONLY | os.O_CLOEXEC
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        descriptor = os.open(path, flags)
    except OSError as error:
        fail(f"cannot open submission.json: {error}")
    try:
        after = os.fstat(descriptor)
        if (before.st_dev, before.st_ino) != (after.st_dev, after.st_ino):
            fail("submission.json changed while opening")
        encoded = os.read(descriptor, ADAPTER.MAX_RECORD_BYTES + 1)
    finally:
        os.close(descriptor)
    if len(encoded) > ADAPTER.MAX_RECORD_BYTES:
        fail("submission.json is oversized")
    try:
        data = json.loads(encoded)
    except (UnicodeDecodeError, json.JSONDecodeError):
        fail("submission.json is malformed")
    if not isinstance(data, dict):
        fail("submission.json must contain one object")
    return data, encoded


def adopt_managed_run(
    run_dir: Path,
    *,
    environ: Mapping[str, str],
    expected_argv: Sequence[str] | None = None,
    expected_cwd: Path | None = None,
    effective_uid: int | None = None,
) -> tuple[dict[str, object], str]:
    """Validate the immutable adapter record before status, lock, or child activity."""
    uid = os.geteuid() if effective_uid is None else effective_uid
    absolute_run_dir = run_dir.expanduser().absolute()
    validate_private_directory(absolute_run_dir.parent, uid, "state root")
    validate_private_directory(absolute_run_dir, uid, "run directory")
    submission, encoded = read_submission(absolute_run_dir / "submission.json", uid)
    digest = hashlib.sha256(encoded).hexdigest()

    required = {
        "format",
        "terminal_revision",
        "run_id",
        "unit",
        "lean_root",
        "run_dir",
        "worker_argv",
        "worker_argv_sha256",
        "origin",
        "manager_generation",
    }
    missing = required - set(submission)
    if missing:
        fail(f"submission.json is missing {sorted(missing)}")
    if submission["format"] != 1 or submission["terminal_revision"] != 1:
        fail("unsupported submission format or terminal revision")
    if submission["run_dir"] != str(absolute_run_dir):
        fail("submission run-directory path mismatch")
    run_id = submission["run_id"]
    unit = submission["unit"]
    if not isinstance(run_id, str) or not run_id.startswith("run-"):
        fail("invalid submission run ID")
    suffix = run_id.removeprefix("run-")
    if len(suffix) != 32 or any(character not in "0123456789abcdef" for character in suffix):
        fail("invalid submission run ID")
    if unit != f"othello-lean-{suffix}.service":
        fail("submission unit/run identity mismatch")
    if environ.get("OTHELLO_LEAN_RUN_ID") != run_id:
        fail("run-ID environment nonce mismatch")
    if environ.get("OTHELLO_LEAN_SUBMISSION_SHA256") != digest:
        fail("submission-digest environment nonce mismatch")

    argv = list(current_argv() if expected_argv is None else expected_argv)
    if submission["worker_argv"] != argv:
        fail("worker argv does not match immutable submission")
    expected_argv_digest = hashlib.sha256(ADAPTER.canonical_json({"argv": argv})).hexdigest()
    if submission["worker_argv_sha256"] != expected_argv_digest:
        fail("worker argv digest mismatch")
    origin = submission["origin"]
    if not isinstance(origin, dict):
        fail("submission origin is malformed")
    try:
        effective_user = pwd.getpwuid(uid).pw_name
    except KeyError:
        fail(f"effective UID {uid} has no account entry")
    if origin.get("user") != effective_user:
        fail("submission effective-account mismatch")
    lean_root = Path(str(submission["lean_root"]))
    if not lean_root.is_absolute():
        fail("submission Lean root is not absolute")
    worker_cwd = Path.cwd().absolute() if expected_cwd is None else expected_cwd.absolute()
    if lean_root != worker_cwd:
        fail("worker working directory does not match submission Lean root")
    try:
        (absolute_run_dir / "status.json").lstat()
    except FileNotFoundError:
        pass
    except OSError as error:
        fail(f"cannot inspect status path before adoption: {error}")
    else:
        fail("status.json already exists before managed-worker adoption")
    return submission, digest


def fsync_directory(path: Path) -> None:
    descriptor = os.open(path, os.O_RDONLY | os.O_DIRECTORY | os.O_CLOEXEC)
    try:
        os.fsync(descriptor)
    finally:
        os.close(descriptor)


def replace_status(path: Path, status_data: Mapping[str, object]) -> None:
    encoded = ADAPTER.canonical_json(status_data)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.{uuid.uuid4().hex}.tmp")
    flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_CLOEXEC
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    descriptor = os.open(temporary, flags, 0o600)
    try:
        with os.fdopen(descriptor, "wb", closefd=True) as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
        fsync_directory(path.parent)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


class StatusWriter:
    def __init__(self, run_dir: Path, submission: Mapping[str, object]) -> None:
        now = ADAPTER.utc_now()
        self.path = run_dir / "status.json"
        self.data: dict[str, object] = {
            "format": 2,
            "run_id": submission["run_id"],
            "state": "queued",
            "phase": "initializing",
            "queue_exit_code": None,
            "targets": [],
            "results": [],
            "current_target": None,
            "failed_target": None,
            "created_utc": now,
            "started_utc": None,
            "finished_utc": None,
            "updated_utc": now,
            "telemetry": {},
            "diagnostic_paths": {},
        }
        ADAPTER.publish_set_once(self.path, self.data, os.geteuid())

    def update(self, **changes: object) -> None:
        self.data.update(changes)
        self.data["updated_utc"] = ADAPTER.utc_now()
        replace_status(self.path, self.data)


def acquire_fixture_lock(path: Path, timeout: float) -> object | None:
    path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    stream = path.open("a+")
    deadline = time.monotonic() + timeout
    while True:
        try:
            fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            return stream
        except BlockingIOError:
            if time.monotonic() >= deadline:
                stream.close()
                return None
            time.sleep(0.02)


def run_fixture(args: argparse.Namespace) -> int:
    run_dir = args.run_dir.expanduser().absolute()
    try:
        submission, _ = adopt_managed_run(run_dir, environ=os.environ)
    except AdoptionError as error:
        print(f"lean-build-systemd-worker: {error}", file=sys.stderr)
        return EXIT_INVALID

    try:
        writer = StatusWriter(run_dir, submission)
    except ADAPTER.StateError as error:
        print(f"lean-build-systemd-worker: {error}", file=sys.stderr)
        return EXIT_INVALID
    writer.update(state="queued", phase="waiting-for-lock")
    lock = acquire_fixture_lock(args.fixture_lock.expanduser().absolute(), args.lock_timeout)
    if lock is None:
        writer.update(
            state="refused",
            phase="finished",
            queue_exit_code=EXIT_REFUSED,
            finished_utc=ADAPTER.utc_now(),
        )
        return EXIT_REFUSED
    try:
        writer.update(state="running", phase="quiet-preflight", started_utc=ADAPTER.utc_now())
    finally:
        fcntl.flock(lock.fileno(), fcntl.LOCK_UN)
        lock.close()
    writer.update(
        state="success",
        phase="finished",
        queue_exit_code=EXIT_OK,
        finished_utc=ADAPTER.utc_now(),
    )
    return EXIT_OK


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    fixture = subparsers.add_parser("fixture", help="exercise adoption/status/lock ordering only")
    fixture.add_argument("--run-dir", type=Path, required=True)
    fixture.add_argument("--fixture-lock", type=Path, required=True)
    fixture.add_argument("--lock-timeout", type=float, default=5.0)
    return result


def main(argv: Sequence[str] | None = None) -> int:
    args = parser().parse_args(argv)
    if args.command == "fixture":
        return run_fixture(args)
    return EXIT_INVALID


if __name__ == "__main__":
    raise SystemExit(main())
