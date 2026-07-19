#!/usr/bin/env python3
"""Atomically reserve contiguous blocks from the global Codex task-ID sequence."""

from __future__ import annotations

import argparse
import fcntl
import json
import multiprocessing
import os
import re
import subprocess
import tempfile
from pathlib import Path
from typing import Any


SCHEMA = "codex-task-id-allocations-v1"
LANE = re.compile(r"[a-z0-9][a-z0-9-]*\Z")
SCRIPT = Path(__file__).resolve()
REPOSITORY = SCRIPT.parents[2]
DEFAULT_STATE = REPOSITORY / "notes" / "codex-task-id-allocations.json"


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def git_common_directory() -> Path:
    result = subprocess.run(
        ["git", "rev-parse", "--git-common-dir"],
        cwd=REPOSITORY,
        check=True,
        capture_output=True,
        text=True,
    )
    path = Path(result.stdout.strip())
    return path if path.is_absolute() else (REPOSITORY / path).resolve()


def default_lock_path() -> Path:
    return git_common_directory() / "codex-task-id-allocations.lock"


def validate_state(state: Any) -> dict[str, Any]:
    if not isinstance(state, dict) or state.get("schema") != SCHEMA:
        raise ValueError(f"state must use schema {SCHEMA}")
    allocations = state.get("allocations")
    if not isinstance(allocations, list) or not allocations:
        raise ValueError("state must contain at least the legacy bootstrap allocation")
    expected_first = 1
    for expected_sequence, allocation in enumerate(allocations, 1):
        if not isinstance(allocation, dict):
            raise ValueError(f"allocation {expected_sequence} is not an object")
        required = {"sequence", "kind", "first", "last", "count", "lane", "purpose"}
        if set(allocation) != required:
            raise ValueError(f"allocation {expected_sequence} has fields {sorted(allocation)}")
        if allocation["sequence"] != expected_sequence:
            raise ValueError(f"allocation sequence drift at entry {expected_sequence}")
        first = allocation["first"]
        last = allocation["last"]
        count = allocation["count"]
        if not all(isinstance(value, int) and value > 0 for value in (first, last, count)):
            raise ValueError(f"allocation {expected_sequence} has invalid numeric bounds")
        if first != expected_first or last != first + count - 1:
            raise ValueError(f"allocation {expected_sequence} is noncontiguous or malformed")
        if allocation["kind"] not in {"legacy-bootstrap", "reservation"}:
            raise ValueError(f"allocation {expected_sequence} has invalid kind")
        if not isinstance(allocation["lane"], str) or not LANE.fullmatch(allocation["lane"]):
            raise ValueError(f"allocation {expected_sequence} has invalid lane")
        if not isinstance(allocation["purpose"], str) or not allocation["purpose"].strip():
            raise ValueError(f"allocation {expected_sequence} has empty purpose")
        expected_first = last + 1
    if state.get("next_id") != expected_first:
        raise ValueError(f"next_id must be {expected_first}")
    return state


def read_state(path: Path) -> dict[str, Any]:
    return validate_state(json.loads(path.read_text(encoding="utf-8")))


def atomic_write(path: Path, state: dict[str, Any]) -> None:
    payload = canonical_bytes(validate_state(state))
    descriptor, temporary_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(payload)
            stream.flush()
            os.fsync(stream.fileno())
        os.chmod(temporary, 0o644)
        os.replace(temporary, path)
        directory = os.open(path.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        temporary.unlink(missing_ok=True)


def reserve_block(
    state_path: Path,
    lock_path: Path,
    count: int,
    lane: str,
    purpose: str,
) -> dict[str, Any]:
    if count <= 0:
        raise ValueError("count must be positive")
    if not LANE.fullmatch(lane):
        raise ValueError("lane must contain lowercase letters, digits, or internal hyphens")
    purpose = " ".join(purpose.split())
    if not purpose or len(purpose) > 240:
        raise ValueError("purpose must contain 1 to 240 normalized characters")
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    descriptor = os.open(lock_path, os.O_CREAT | os.O_RDWR, 0o600)
    try:
        fcntl.flock(descriptor, fcntl.LOCK_EX)
        state = read_state(state_path)
        first = state["next_id"]
        last = first + count - 1
        allocation = {
            "count": count,
            "first": first,
            "kind": "reservation",
            "lane": lane,
            "last": last,
            "purpose": purpose,
            "sequence": len(state["allocations"]) + 1,
        }
        state["allocations"].append(allocation)
        state["next_id"] = last + 1
        atomic_write(state_path, state)
        return allocation
    finally:
        fcntl.flock(descriptor, fcntl.LOCK_UN)
        os.close(descriptor)


def read_locked(state_path: Path, lock_path: Path) -> dict[str, Any]:
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    descriptor = os.open(lock_path, os.O_CREAT | os.O_RDWR, 0o600)
    try:
        fcntl.flock(descriptor, fcntl.LOCK_SH)
        return read_state(state_path)
    finally:
        fcntl.flock(descriptor, fcntl.LOCK_UN)
        os.close(descriptor)


def display_range(first: int, last: int) -> str:
    return f"C{first}" if first == last else f"C{first}-C{last}"


def self_test_worker(arguments: tuple[str, str, int, int]) -> tuple[int, int]:
    state, lock, count, worker = arguments
    allocation = reserve_block(Path(state), Path(lock), count, "test", f"worker {worker}")
    return allocation["first"], allocation["last"]


def self_test() -> None:
    with tempfile.TemporaryDirectory(prefix="codex-task-id-test-") as directory_name:
        directory = Path(directory_name)
        state_path = directory / "state.json"
        lock_path = directory / "state.lock"
        bootstrap = {
            "allocations": [
                {
                    "count": 1,
                    "first": 1,
                    "kind": "legacy-bootstrap",
                    "lane": "legacy",
                    "last": 1,
                    "purpose": "test bootstrap",
                    "sequence": 1,
                }
            ],
            "next_id": 2,
            "schema": SCHEMA,
        }
        atomic_write(state_path, bootstrap)
        counts = (1, 3, 2, 4, 1, 2, 3, 1)
        arguments = [(str(state_path), str(lock_path), count, index) for index, count in enumerate(counts)]
        with multiprocessing.get_context("spawn").Pool(len(counts)) as pool:
            ranges = pool.map(self_test_worker, arguments)
        ordered = sorted(ranges)
        expected = 2
        for first, last in ordered:
            assert first == expected and last >= first
            expected = last + 1
        assert expected == 2 + sum(counts)
        final = read_state(state_path)
        assert final["next_id"] == expected
        assert len(final["allocations"]) == 1 + len(counts)


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    reserve = subparsers.add_parser("reserve", help="atomically reserve a permanent contiguous block")
    reserve.add_argument("--count", type=int, required=True)
    reserve.add_argument("--lane", required=True)
    reserve.add_argument("--purpose", required=True)
    reserve.add_argument("--json", action="store_true")

    subparsers.add_parser("peek", help="show the first currently unreserved ID")
    subparsers.add_parser("check", help="validate the allocation ledger")
    subparsers.add_parser("self-test", help="exercise concurrent block reservation in a temporary ledger")
    args = parser.parse_args()

    if args.command == "self-test":
        self_test()
        print("PASS atomic concurrent task-ID reservation self-test")
        return

    state_path = DEFAULT_STATE
    lock_path = default_lock_path()
    if args.command == "reserve":
        allocation = reserve_block(state_path, lock_path, args.count, args.lane, args.purpose)
        if args.json:
            print(json.dumps(allocation, indent=2, sort_keys=True))
        else:
            block = display_range(allocation["first"], allocation["last"])
            print(
                f"RESERVED {block} count={allocation['count']} "
                f"sequence={allocation['sequence']} lane={allocation['lane']}"
            )
        return

    state = read_locked(state_path, lock_path)
    if args.command == "peek":
        print(f"C{state['next_id']}")
    else:
        latest = state["allocations"][-1]
        print(
            f"PASS {state_path.relative_to(REPOSITORY)} next=C{state['next_id']} "
            f"allocations={len(state['allocations'])} latest={display_range(latest['first'], latest['last'])}"
        )


if __name__ == "__main__":
    main()
