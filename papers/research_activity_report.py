#!/usr/bin/env python3
"""Summarize human activity and Git output for the mathematical research period.

The activity measure is intentionally conservative and reproducible:
one worked hour = one local clock hour containing at least one role:user message.
An hour shared by several projects is counted once.

This uses the local agentsview installation. It does not read or export
conversation contents; it consumes the aggregate hourly and model statistics.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import sqlite3
import subprocess
from collections import defaultdict
from zoneinfo import ZoneInfo


def run_json(command: list[str]) -> dict:
    return json.loads(subprocess.check_output(command, text=True))


def activity_stats(args: argparse.Namespace) -> dict:
    zone = ZoneInfo(args.timezone)
    model_tokens: defaultdict[str, int] = defaultdict(int)
    agent_sessions: defaultdict[str, int] = defaultdict(int)
    agent_messages: defaultdict[str, int] = defaultdict(int)
    agent_tokens: defaultdict[str, int] = defaultdict(int)
    daily_hours: defaultdict[dt.date, set[tuple[dt.date, int]]] = defaultdict(set)
    daily_user_messages: defaultdict[dt.date, int] = defaultdict(int)
    totals = {"sessions": 0, "messages": 0, "user_messages": 0}

    for project in args.projects:
        report = run_json(
            [
                "agentsview",
                "stats",
                "--since",
                args.since,
                "--until",
                args.until,
                "--timezone",
                args.timezone,
                "--include-project",
                project,
                "--format",
                "json",
            ]
        )
        totals["sessions"] += report["totals"]["sessions_human"]
        totals["messages"] += report["totals"]["messages_total"]
        totals["user_messages"] += report["totals"]["user_messages_total"]

        for model, count in report["model_mix"]["by_tokens"].items():
            model_tokens[model] += count
        for agent, count in report["agent_portfolio"]["by_sessions_human"].items():
            agent_sessions[agent] += count
        for agent, count in report["agent_portfolio"]["by_messages_human"].items():
            agent_messages[agent] += count
        for agent, count in report["agent_portfolio"]["by_tokens_human"].items():
            agent_tokens[agent] += count

        for hourly in report["temporal"]["hourly_utc"]:
            messages = hourly.get("user_messages", 0)
            local = dt.datetime.fromisoformat(
                hourly["ts"].replace("Z", "+00:00")
            ).astimezone(zone)
            daily_user_messages[local.date()] += messages
            if messages:
                daily_hours[local.date()].add((local.date(), local.hour))

    daily = [
        {
            "date": day.isoformat(),
            "active_hours": len(daily_hours[day]),
            "user_messages_in_hourly_series": daily_user_messages[day],
        }
        for day in sorted(daily_hours)
    ]
    return {
        "window": {"since": args.since, "until": args.until, "timezone": args.timezone},
        "projects": args.projects,
        "definition": "one local clock hour with at least one role:user message; overlapping projects count once",
        "totals": totals,
        "active_hours_total": sum(row["active_hours"] for row in daily),
        "daily": daily,
        "model_tokens": dict(sorted(model_tokens.items())),
        "agent_sessions": dict(sorted(agent_sessions.items())),
        "agent_messages": dict(sorted(agent_messages.items())),
        "agent_tokens": dict(sorted(agent_tokens.items())),
    }


def git_stats(args: argparse.Namespace) -> dict:
    base = [
        "git",
        "-C",
        args.git_root,
        "log",
        f"--since={args.since} 00:00",
        f"--until={args.until} 00:00",
    ]
    commits = subprocess.check_output(base + ["--format=%H"], text=True).splitlines()
    days = subprocess.check_output(base + ["--format=%ad", "--date=short"], text=True).splitlines()
    numstat = subprocess.check_output(base + ["--numstat", "--format="], text=True)
    files = insertions = deletions = 0
    for line in numstat.splitlines():
        fields = line.split("\t")
        if len(fields) != 3 or not fields[0].isdigit() or not fields[1].isdigit():
            continue
        insertions += int(fields[0])
        deletions += int(fields[1])
        files += 1
    return {
        "root": args.git_root,
        "commits": len(commits),
        "active_commit_days": len(set(days)),
        "file_change_entries": files,
        "insertions": insertions,
        "deletions": deletions,
    }


PAPER_PATTERNS = {
    "Clebsch I / rigidity": r"clebsch[- ]rigidity|paper i\b|paper 1\b|clebsch code|syndrome rigidity",
    "Clebsch II / factorization": r"clebsch[- ]factorization|paper ii\b|paper 2\b|factorization|quadratic trade",
    "Clebsch III / passages": r"clebsch[- ]passages|paper iii\b|paper 3\b|golden descent|operator realization",
    "Clebsch IV / q=13": r"paper iv\b|paper 4\b|q13|q=13|minimum-word|passant code",
    "Arcs": r"arcs[- ]complete|outside a conic|complete outside|arc paper",
    "Beyond-4 PRS": r"beyond4|reed[- ]solomon|deep holes|prs\b",
    "AME-LU": r"ame[- ]lu|ame state|absolutely maximally entangled|local-unitary",
    "MDS-CSS": r"mds[- ]css|transversal clifford|css code",
    "Golden quantum statistics": r"golden[- ]quantum|quantum statistics|conference interferometer|six-mode",
    "Complete repair ports": r"complete[- ]repair|repair ports|complete ports|repairports",
    "Baer / equivariant completion": r"baer|equivariant extension|robust completion",
    "CGT / Nofil": r"node kayles|nofil|cap game|combinatorial game",
}

PAPER_PATHS = {
    "Clebsch I / rigidity": "papers/clebsch-rigidity",
    "Clebsch II / factorization": "papers/clebsch-factorization",
    "Clebsch III / passages": "papers/clebsch-passages",
    "Clebsch IV / q=13": "papers/q13-passant-code",
    "Arcs": "papers/arcs_complete_outside_conic",
    "Beyond-4 PRS": "papers/beyond4_prs",
    "AME-LU": "papers/ame_lu",
    "MDS-CSS": "papers/mds_css_transversal_groups",
    "Golden quantum statistics": "papers/golden-quantum-statistics",
    "Complete repair ports": "papers/complete-repair-ports",
    "Baer / equivariant completion": "papers/baer-equivariant-extension",
    "CGT / Nofil": "papers/nofil-finite-geometry-outcomes",
}


def editorial_stats(args: argparse.Namespace) -> dict:
    """Estimate explicit push-hard commands and paper editing/review cycles.

    A cycle is one distinct session containing a review/editing term and a paper
    alias. This is an upper-ish estimate of editorial sessions, not a claim that
    every session was a complete read-through. Git commit counts are reported as
    an independent lower-bound cross-check.
    """
    db_root = os.environ.get("AGENTSVIEW_DATA_DIR", os.path.expanduser("~/.agentsview"))
    db_path = os.path.join(db_root, "sessions.db")
    connection = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    query = """
        SELECT s.id, s.project, COALESCE(s.first_message, ''),
               COALESCE(s.display_name, ''), m.content
        FROM sessions s JOIN messages m ON m.session_id = s.id
        WHERE s.project IN ({projects}) AND s.started_at >= ?
          AND s.started_at < ? AND m.role = 'user'
    """.format(projects=", ".join("?" for _ in args.projects))
    rows = connection.execute(
        query, [*args.projects, f"{args.since}T00:00:00Z", f"{args.until}T00:00:00Z"]
    )
    command_pattern = re.compile(r"(?<![A-Za-z0-9_])(ej\d*|tt|aa)(?![A-Za-z0-9_])", re.I)
    cycle_pattern = re.compile(
        r"cold[- ]read|copy[- ]edit|proofread|referee|review|revise|revision|"
        r"edit(?:ing|ed)?|manuscript|style|clarity|rewrite|paper pass|release check|trust gate",
        re.I,
    )
    sessions = {}
    for sid, project, first, name, content in rows:
        record = sessions.setdefault(sid, {"header": first + " " + name, "messages": []})
        record["messages"].append(content)
    connection.close()

    c_items: defaultdict[str, int] = defaultdict(int)
    command_totals: defaultdict[str, int] = defaultdict(int)
    for record in sessions.values():
        match = re.search(r"\bC\d+\b", record["header"], re.I)
        if not match:
            continue
        item = match.group().upper()
        hits = [hit.lower() for message in record["messages"] for hit in command_pattern.findall(message)]
        c_items[item] += len(hits)
        for hit in hits:
            command_totals[hit] += 1

    values = sorted(c_items.values())
    positive = [value for value in values if value]

    def percentile(items: list[int], fraction: float) -> float | None:
        if not items:
            return None
        index = int(max(0, (len(items) * fraction + 0.999999999) // 1 - 1))
        return items[index]

    edit_sessions: defaultdict[str, set[str]] = defaultdict(set)
    related_sessions: defaultdict[str, set[str]] = defaultdict(set)
    for sid, record in sessions.items():
        text = record["header"] + " " + " ".join(record["messages"])
        for paper, pattern in PAPER_PATTERNS.items():
            if re.search(pattern, text, re.I):
                related_sessions[paper].add(sid)
                if cycle_pattern.search(text):
                    edit_sessions[paper].add(sid)

    git_lower_bounds = {}
    for paper, path in PAPER_PATHS.items():
        commits = subprocess.check_output(
            [
                "git", "-C", args.git_root, "log", "--since=" + args.since + " 00:00",
                "--until=" + args.until + " 00:00", "--format=%H", "--", path,
            ],
            text=True,
        ).splitlines()
        git_lower_bounds[paper] = len(commits)

    return {
        "command_definition": "explicit user tokens ej, ej2, ..., tt, aa in C-task research sessions",
        "c_items_with_any_command": len(positive),
        "c_items_total": len(values),
        "command_total": sum(values),
        "command_breakdown": dict(sorted(command_totals.items())),
        "commands_per_c_item_all": {
            "mean": sum(values) / len(values) if values else 0,
            "p90_nearest_rank": percentile(values, 0.90),
            "max": max(values) if values else 0,
            "median": percentile(values, 0.50),
        },
        "commands_per_c_item_positive_only": {
            "mean": sum(positive) / len(positive) if positive else 0,
            "p90_nearest_rank": percentile(positive, 0.90),
            "max": max(positive) if positive else 0,
            "median": percentile(positive, 0.50),
        },
        "paper_cycles": {
            paper: {
                "related_sessions": len(related_sessions[paper]),
                "estimated_edit_review_sessions": len(edit_sessions[paper]),
                "git_commit_lower_bound": git_lower_bounds[paper],
            }
            for paper in PAPER_PATTERNS
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--since", default="2026-06-01")
    parser.add_argument("--until", default="2026-08-04")
    parser.add_argument("--timezone", default="America/Los_Angeles")
    parser.add_argument("--projects", nargs="+", default=["rust", "othello"])
    parser.add_argument("--git-root", default="/home/tavis/src/othello")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    result = {
        "activity": activity_stats(args),
        "editorial": editorial_stats(args),
        "git": git_stats(args),
    }
    if args.json:
        print(json.dumps(result, indent=2, sort_keys=True))
        return
    activity = result["activity"]
    print(f"Projects: {', '.join(activity['projects'])}")
    print(f"Window: {args.since} through {args.until}; {args.timezone}")
    print(f"Sessions: {activity['totals']['sessions']}")
    print(f"Worked hours: {activity['active_hours_total']}")
    print("\nDate       Hours  User messages")
    for row in activity["daily"]:
        print(f"{row['date']}  {row['active_hours']:>5}  {row['user_messages_in_hourly_series']:>13}")
    print("\nModel tokens:")
    for name, count in activity["model_tokens"].items():
        print(f"  {name}: {count:,}")
    print("\nAgent sessions / turns / tokens:")
    for name in activity["agent_sessions"]:
        print(
            f"  {name}: {activity['agent_sessions'][name]:,} sessions, "
            f"{activity['agent_messages'].get(name, 0):,} turns, "
            f"{activity['agent_tokens'].get(name, 0):,} tokens"
        )
    editorial = result["editorial"]
    print("\nPush-hard commands per C item:")
    for label, stats in editorial["commands_per_c_item_all"].items():
        print(f"  all items {label}: {stats}")
    print(f"  explicit command total: {editorial['command_total']:,}")
    print("\nEstimated paper editing/review sessions (Git commits are a lower bound):")
    for paper, stats in editorial["paper_cycles"].items():
        print(
            f"  {paper}: ~{stats['estimated_edit_review_sessions']} editorial sessions; "
            f"{stats['git_commit_lower_bound']} Git commits"
        )
    print("\nGit:")
    for key, value in result["git"].items():
        if key != "root":
            print(f"  {key}: {value:,}" if isinstance(value, int) else f"  {key}: {value}")


if __name__ == "__main__":
    main()
