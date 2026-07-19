#!/usr/bin/env python3
"""Return the next global Codex task ID without matching URLs or hash substrings.

The scan is deliberately fail-closed.  It finds isolated C-number tokens in every
Markdown note, but requires the maximum to be corroborated by an authoritative
live-queue/archive row or a task-card heading.  A larger unindexed token is
reported with provenance instead of silently becoming the allocation maximum.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from pathlib import Path


TOKEN = re.compile(r"(?<![A-Za-z0-9_])C([1-9][0-9]*)(?![A-Za-z0-9_])")
QUEUE_ROW = re.compile(r"^- \*\*C([1-9][0-9]*) ")
TASK_HEADING = re.compile(r"^#{1,6}\s+C([1-9][0-9]*)(?::|\b)")
URL = re.compile(r"https?://\S+")
MARKDOWN_DESTINATION = re.compile(r"\]\([^)]*\)")


def visible_text(line: str) -> str:
    """Remove link destinations, where C-digits are identifiers other than tasks."""
    line = URL.sub("", line)
    return MARKDOWN_DESTINATION.sub("]", line)


def self_test() -> None:
    cases = {
        "C360": [360],
        "`C360`": [360],
        "go C360.": [360],
        "PMC7324030": [],
        "https://pmc.ncbi.nlm.nih.gov/articles/PMC7324030/": [],
        "xC999": [],
        "C999x": [],
        "sha256=aaC5448bb": [],
        "[paper](https://example.test/C888/) and C361": [361],
    }
    for source, expected in cases.items():
        actual = [int(match) for match in TOKEN.findall(visible_text(source))]
        assert actual == expected, (source, actual, expected)
    assert QUEUE_ROW.match("- **C360 `[crowns]` [QUEUED]** — task")
    assert TASK_HEADING.match("# C360: task card")


def scan(notes: Path) -> tuple[dict[int, list[str]], dict[int, list[str]]]:
    occurrences: dict[int, list[str]] = defaultdict(list)
    corroborated: dict[int, list[str]] = defaultdict(list)
    for path in sorted(notes.rglob("*.md")):
        if any(part in {"generated", ".lake", ".git"} for part in path.parts):
            continue
        relative = path.relative_to(notes.parent)
        with path.open(encoding="utf-8") as stream:
            for line_number, raw_line in enumerate(stream, 1):
                line = visible_text(raw_line.rstrip("\n"))
                location = f"{relative}:{line_number}"
                for match in TOKEN.finditer(line):
                    task_id = int(match.group(1))
                    if len(occurrences[task_id]) < 5:
                        occurrences[task_id].append(location)
                for pattern in (QUEUE_ROW, TASK_HEADING):
                    match = pattern.match(line)
                    if match:
                        task_id = int(match.group(1))
                        if len(corroborated[task_id]) < 5:
                            corroborated[task_id].append(location)
    return occurrences, corroborated


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--explain", action="store_true", help="print maxima and provenance as JSON")
    parser.add_argument("--self-test", action="store_true", help="run matcher regression tests only")
    args = parser.parse_args()

    self_test()
    if args.self_test:
        print("PASS next_codex_task_id matcher self-test")
        return

    notes = Path(__file__).resolve().parents[1]
    occurrences, corroborated = scan(notes)
    if not occurrences:
        raise SystemExit("no isolated Codex task IDs found under notes/")
    maximum = max(occurrences)
    if maximum not in corroborated:
        provenance = ", ".join(occurrences[maximum])
        if args.explain:
            print(
                json.dumps(
                    {
                        "error": "maximum task token is not authoritatively indexed",
                        "maximum": f"C{maximum}",
                        "maximum_occurrences": occurrences[maximum],
                    },
                    indent=2,
                    sort_keys=True,
                )
            )
        raise SystemExit(
            f"refusing allocation: maximum C{maximum} has no queue/archive row or task-card heading; "
            f"inspect {provenance}"
        )

    result = {
        "maximum": f"C{maximum}",
        "next": f"C{maximum + 1}",
        "maximum_occurrences": occurrences[maximum],
        "corroborating_occurrences": corroborated[maximum],
    }
    if args.explain:
        print(json.dumps(result, indent=2, sort_keys=True))
    else:
        print(result["next"])


if __name__ == "__main__":
    try:
        main()
    except (OSError, UnicodeError) as error:
        print(f"task-ID scan failed: {error}", file=sys.stderr)
        raise SystemExit(1) from error
