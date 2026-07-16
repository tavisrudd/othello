#!/usr/bin/env python3
"""C225 systemd-managed Lean queue adapter.

The adapter is being rolled out beside the legacy queue.  This first increment implements only
origin resolution; it does not submit services, invoke Lean, or touch legacy run directories.
"""

from __future__ import annotations

import argparse
import json
import os
import pwd
import re
import sys
from dataclasses import dataclass
from typing import Mapping, NoReturn, Sequence


EXIT_INVALID = 125
MAX_VALUE_LENGTH = 128
HARNESS_VALUES = ("codex", "claude", "manual")
SESSION_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.:@+-]{0,127}\Z")
LANE_RE = re.compile(r"[a-z0-9][a-z0-9-]{0,63}\Z")
TASK_RE = re.compile(r"C[0-9]+\Z")


class OriginError(ValueError):
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


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    origin = subparsers.add_parser("resolve-origin", help="print the resolved bounded origin JSON")
    origin.add_argument("--harness", choices=HARNESS_VALUES)
    origin.add_argument("--session-id")
    origin.add_argument("--lane", dest="work_lane")
    origin.add_argument("--task-id")
    return result


def main(argv: Sequence[str] | None = None) -> int:
    args = parser().parse_args(argv)
    try:
        origin = resolve_origin(
            harness=args.harness,
            session_id=args.session_id,
            work_lane=args.work_lane,
            task_id=args.task_id,
            environ=os.environ,
        )
    except OriginError as error:
        print(f"lean-build-systemd: {error}", file=sys.stderr)
        return EXIT_INVALID
    json.dump({"format": 1, "origin": origin}, sys.stdout, sort_keys=True, separators=(",", ":"))
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
