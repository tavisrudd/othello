#!/usr/bin/env python3
"""Find likely token waste in recent agent sessions without dumping transcripts.

The Codex data has two complementary views:

* ordinary sessions expose tool inputs through ``asg +show --expand-tool-calls``;
* Codex auto-review sessions mirror tool calls *and results* inside transcript deltas.

This program reads both, pairs obvious mirrors, and emits capped aggregates.  It never
prints a complete message, command result, or transcript.  It is intentionally a
heuristic audit: a repeated call is evidence to inspect, not proof that it was useless.
"""

from __future__ import annotations

import argparse
import bisect
import collections
import dataclasses
import json
import re
import subprocess
import sys
from typing import Any, Iterable, TextIO


AUTO_REVIEW_PREFIX = "The following is the Codex agent history"
EVENT_RE = re.compile(
    r"(?m)^\s*\[(?P<index>\d+)\]\s+"
    r"(?:(?:tool\s+(?P<tool>\S+)\s+(?P<kind>call|result))|"
    r"(?:user|assistant)):\s*"
)
SPACE_RE = re.compile(r"\s+")
ORIGINAL_TOKEN_RES = (
    re.compile(r"original[_ ]token[_ ]count[\"']?\s*[:=]\s*(\d+)", re.I),
    re.compile(r"original token count:\s*(\d+)", re.I),
)


@dataclasses.dataclass(frozen=True)
class Event:
    session_id: str
    event_index: int
    tool: str
    kind: str
    text: str

    @property
    def chars(self) -> int:
        return len(self.text)

    @property
    def lines(self) -> int:
        return self.text.count("\n") + (1 if self.text else 0)

    @property
    def reported_tokens(self) -> int | None:
        values = [
            int(match.group(1))
            for pattern in ORIGINAL_TOKEN_RES
            for match in pattern.finditer(self.text)
        ]
        return max(values) if values else None


def run_json(command: list[str]) -> Any:
    """Run asg and decode JSON without echoing its potentially huge stdout."""
    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    assert process.stdout is not None
    try:
        value = json.load(process.stdout)
    except json.JSONDecodeError as exc:
        process.kill()
        stderr = process.stderr.read(1000) if process.stderr else ""
        raise RuntimeError(f"invalid JSON from {' '.join(command)}: {stderr}") from exc
    stderr = process.stderr.read(2000) if process.stderr else ""
    returncode = process.wait()
    if returncode:
        raise RuntimeError(
            f"command failed ({returncode}): {' '.join(command)}\n{stderr}"
        )
    return value


def extract_origin_prompt(first_message: str) -> str | None:
    if not first_message.startswith(AUTO_REVIEW_PREFIX):
        return None
    match = re.search(
        r">>> TRANSCRIPT START\s+\[1\]\s+user:\s*(.*?)(?:\s*\[2\]\s+assistant:|$)",
        first_message,
        re.S,
    )
    return compact(match.group(1)) if match else None


def compact(text: str, limit: int | None = None) -> str:
    value = SPACE_RE.sub(" ", text).strip()
    if limit is not None and len(value) > limit:
        return value[: max(0, limit - 1)] + "…"
    return value


def transcript_events(session_id: str, messages: Iterable[dict[str, Any]]) -> list[Event]:
    events: list[Event] = []
    for message in messages:
        if message.get("role") != "user":
            continue
        content = message.get("content") or ""
        markers = list(EVENT_RE.finditer(content))
        for position, marker in enumerate(markers):
            tool = marker.group("tool")
            kind = marker.group("kind")
            if tool is None or kind is None:
                continue
            end = markers[position + 1].start() if position + 1 < len(markers) else len(content)
            body = content[marker.end() : end].strip()
            events.append(
                Event(session_id, int(marker.group("index")), tool, kind, body)
            )
    return events


def direct_call_events(session_id: str, messages: Iterable[dict[str, Any]]) -> list[Event]:
    events: list[Event] = []
    fallback_index = 0
    for message in messages:
        for call in message.get("tool_calls") or []:
            fallback_index += 1
            body = call.get("input_json") or ""
            events.append(
                Event(
                    session_id,
                    int(message.get("ordinal", fallback_index)),
                    call.get("tool_name") or "unknown",
                    "call",
                    body,
                )
            )
            result = call.get("result_content")
            if result is not None:
                events.append(
                    Event(
                        session_id,
                        int(message.get("ordinal", fallback_index)),
                        call.get("tool_name") or "unknown",
                        "result",
                        result,
                    )
                )
    return events


def parsed_input(event: Event) -> Any:
    return _maybe_json(event.text)


def _maybe_json(text: str) -> Any:
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return None


def call_subject(event: Event) -> str:
    parsed = parsed_input(event)
    if isinstance(parsed, dict):
        for key in ("cmd", "command", "path", "cell_id", "target"):
            if key in parsed:
                return compact(str(parsed[key]), 240)
    return compact(event.text, 240)


def normalized_call(event: Event) -> str:
    parsed = parsed_input(event)
    if isinstance(parsed, dict):
        parsed = dict(parsed)
        # Dynamic handles should not hide structurally repeated polling.
        for key in ("cell_id", "session_id", "yield_time_ms", "timeout_ms"):
            if key in parsed:
                parsed[key] = f"<{key}>"
        text = json.dumps(parsed, sort_keys=True, separators=(",", ":"))
    else:
        text = compact(event.text)
    return f"{event.tool}:{text}"


POLL_RE = re.compile(
    r"(?:^|[;&|]\s*|\b)(?:ps\b|pgrep\b|df\b|free\b|git\s+status\b|"
    r"git\s+diff\b|tmux\s+capture-pane\b)",
    re.I,
)
BUILD_RE = re.compile(
    r"(?:lake\s+(?:build|env\s+lean)|nix\s+develop|make\s+(?:test|ci|release)|cargo\s+(?:build|test))",
    re.I,
)
BROAD_RE = re.compile(
    r"(?:git\s+ls-files(?:\s|$)|ps\s+-e(?:o|f)?\b|rg\s+--files(?:\s|$)|"
    r"find\s+[^|;]*(?:$|\s+-print)|git\s+diff\s*(?:$|[;&|]))",
    re.I,
)


def command_flags(event: Event) -> set[str]:
    subject = call_subject(event)
    flags: set[str] = set()
    if event.tool in {"wait", "wait_agent"}:
        flags.add("wait")
    if POLL_RE.search(subject):
        flags.add("poll")
    if BUILD_RE.search(subject):
        flags.add("build")
    if BROAD_RE.search(subject):
        flags.add("broad-output-risk")
    return flags


def print_table(rows: list[list[str]], headers: list[str], out: TextIO) -> None:
    widths = [len(header) for header in headers]
    for row in rows:
        for index, value in enumerate(row):
            widths[index] = max(widths[index], len(value))
    print("  ".join(h.ljust(widths[i]) for i, h in enumerate(headers)), file=out)
    print("  ".join("-" * width for width in widths), file=out)
    for row in rows:
        print("  ".join(value.ljust(widths[i]) for i, value in enumerate(row)), file=out)


def analyze(args: argparse.Namespace) -> dict[str, Any]:
    if args.session:
        sessions = [{"id": session_id} for session_id in args.session]
    else:
        listing_command = [
            "asg",
            "+list",
            "--since",
            args.since,
            "--limit",
            str(args.max_sessions),
            "--json",
        ]
        if args.before:
            listing_command.extend(["--before", args.before])
        if args.project:
            listing_command.extend(["--project", args.project])
        if args.agent:
            listing_command.extend(["--agent", args.agent])
        sessions = run_json(listing_command)

    loaded: list[dict[str, Any]] = []
    review_prompts: set[str] = set()
    for summary in sessions:
        shown = run_json(
            ["asg", "+show", summary["id"], "--json", "--expand-tool-calls"]
        )
        metadata = shown["session"]
        first_user_message = next(
            (
                message.get("content") or ""
                for message in shown["messages"]
                if message.get("role") == "user"
            ),
            metadata.get("first_message") or "",
        )
        origin = extract_origin_prompt(first_user_message)
        if origin:
            review_prompts.add(origin)
        loaded.append(
            {
                "summary": summary,
                "metadata": metadata,
                "messages": shown["messages"],
                "origin": origin,
                "direct_prompt": compact(first_user_message),
            }
        )

    calls: list[Event] = []
    results: list[Event] = []
    session_rows: list[dict[str, Any]] = []
    for item in loaded:
        metadata = item["metadata"]
        first = item["direct_prompt"]
        is_review = item["origin"] is not None
        mirrored = not is_review and any(
            first == prompt or first.startswith(prompt[:160]) for prompt in review_prompts
        )
        if is_review:
            events = transcript_events(metadata["id"], item["messages"])
            source = "review-trace"
        elif mirrored:
            events = []
            source = "mirrored-skip"
        else:
            events = direct_call_events(metadata["id"], item["messages"])
            source = "direct"
        these_calls = [event for event in events if event.kind == "call"]
        these_results = [event for event in events if event.kind == "result"]
        calls.extend(these_calls)
        results.extend(these_results)
        session_rows.append(
            {
                "id": metadata["id"],
                "source": source,
                "messages": metadata.get("message_count", 0),
                "review_rounds": (
                    sum(message.get("role") == "assistant" for message in item["messages"])
                    if is_review
                    else 0
                ),
                "review_context_tokens": sum(
                    message.get("context_tokens") or 0
                    for message in item["messages"]
                    if is_review and message.get("role") == "assistant"
                ),
                "review_output_tokens": sum(
                    message.get("output_tokens") or 0
                    for message in item["messages"]
                    if is_review and message.get("role") == "assistant"
                ),
                "all_context_tokens": sum(
                    message.get("context_tokens") or 0
                    for message in item["messages"]
                    if message.get("role") == "assistant"
                ),
                "all_output_tokens": sum(
                    message.get("output_tokens") or 0
                    for message in item["messages"]
                    if message.get("role") == "assistant"
                ),
                "review_decisions": collections.Counter(
                    (
                        (parsed.get("outcome") or "unknown")
                        if isinstance(parsed := _maybe_json(message.get("content") or ""), dict)
                        else "unparsed"
                    )
                    for message in item["messages"]
                    if is_review and message.get("role") == "assistant"
                ),
                "input_chars": sum(
                    (message.get("content_length") or 0)
                    for message in item["messages"]
                    if message.get("role") == "user"
                ),
                "peak_context_tokens": metadata.get("peak_context_tokens") or 0,
                "output_tokens": metadata.get("total_output_tokens") or 0,
                "calls": len(these_calls),
                "result_chars": sum(event.chars for event in these_results),
                "first_message": compact(item["origin"] or first, 100),
            }
        )

    exact = collections.Counter(normalized_call(event) for event in calls)
    repeated = [(key, count) for key, count in exact.items() if count > 1]
    repeated.sort(key=lambda pair: (-pair[1], pair[0]))
    nonwait_repeated = [
        (key, count)
        for key, count in repeated
        if not key.startswith("wait:") and not key.startswith("wait_agent:")
    ]
    flags = collections.Counter()
    flagged_patterns: dict[str, dict[str, Any]] = {}
    for event in calls:
        event_flags = command_flags(event)
        flags.update(event_flags)
        if event_flags:
            key = normalized_call(event)
            pattern = flagged_patterns.setdefault(
                key,
                {
                    "count": 0,
                    "tool": event.tool,
                    "flags": set(),
                    "subject": call_subject(event),
                },
            )
            pattern["count"] += 1
            pattern["flags"].update(event_flags)

    largest_results = sorted(
        results,
        key=lambda event: (event.reported_tokens or 0, event.chars),
        reverse=True,
    )
    by_tool = collections.Counter(event.tool for event in calls)
    calls_by_session_tool: dict[tuple[str, str], list[Event]] = collections.defaultdict(list)
    for call in calls:
        calls_by_session_tool[(call.session_id, call.tool)].append(call)
    for group in calls_by_session_tool.values():
        group.sort(key=lambda event: event.event_index)

    def preceding_call(result: Event) -> Event | None:
        group = calls_by_session_tool.get((result.session_id, result.tool), [])
        positions = [event.event_index for event in group]
        offset = bisect.bisect_left(positions, result.event_index) - 1
        return group[offset] if offset >= 0 else None
    session_rows.sort(
        key=lambda row: (row["peak_context_tokens"], row["result_chars"]), reverse=True
    )
    review_context_tokens = sum(row["review_context_tokens"] for row in session_rows)
    review_output_tokens = sum(row["review_output_tokens"] for row in session_rows)
    all_context_tokens = sum(row["all_context_tokens"] for row in session_rows)
    all_output_tokens = sum(row["all_output_tokens"] for row in session_rows)
    review_model_tokens = review_context_tokens + review_output_tokens
    all_model_tokens = all_context_tokens + all_output_tokens
    return {
        "parameters": vars(args),
        "sessions": session_rows,
        "summary": {
            "sessions_listed": len(sessions),
            "sessions_analyzed": sum(row["source"] != "mirrored-skip" for row in session_rows),
            "mirrors_skipped": sum(row["source"] == "mirrored-skip" for row in session_rows),
            "tool_calls": len(calls),
            "tool_results_with_bodies": len(results),
            "tool_result_chars": sum(event.chars for event in results),
            "review_rounds": sum(row["review_rounds"] for row in session_rows),
            "review_context_tokens": review_context_tokens,
            "review_output_tokens": review_output_tokens,
            "all_context_tokens": all_context_tokens,
            "all_output_tokens": all_output_tokens,
            "review_model_tokens": review_model_tokens,
            "all_model_tokens": all_model_tokens,
            "review_token_share_percent": (
                100.0 * review_model_tokens / all_model_tokens if all_model_tokens else 0.0
            ),
            "review_input_chars": sum(
                row["input_chars"]
                for row in session_rows
                if row["source"] == "review-trace"
            ),
            "review_decisions": dict(
                sum(
                    (row["review_decisions"] for row in session_rows),
                    collections.Counter(),
                )
            ),
            "calls_by_tool": dict(by_tool.most_common()),
            "flags": dict(flags),
        },
        "repeated_calls": [
            {"count": count, "normalized": compact(key, 300)}
            for key, count in repeated
        ],
        "repeated_nonwait_calls": [
            {"count": count, "normalized": compact(key, 300)}
            for key, count in nonwait_repeated
        ],
        "flagged_patterns": [
            {
                "count": pattern["count"],
                "tool": pattern["tool"],
                "flags": sorted(pattern["flags"]),
                "subject": pattern["subject"],
            }
            for _, pattern in sorted(
                flagged_patterns.items(),
                key=lambda pair: (-pair[1]["count"], pair[0]),
            )
        ],
        "largest_results": [
            {
                "session_id": event.session_id,
                "event_index": event.event_index,
                "tool": event.tool,
                "chars": event.chars,
                "lines": event.lines,
                "reported_tokens": event.reported_tokens,
                "command": call_subject(call)
                if (call := preceding_call(event))
                else "(call not recovered)",
                "preview": compact(event.text, 180),
            }
            for event in largest_results
        ],
    }


def capped_report(report: dict[str, Any], top: int) -> dict[str, Any]:
    """Return a JSON-safe report whose variable-size sections are all bounded."""
    bounded = dict(report)
    for key in (
        "sessions",
        "repeated_calls",
        "repeated_nonwait_calls",
        "flagged_patterns",
        "largest_results",
    ):
        bounded[key] = report[key][:top]
    return bounded


def render(report: dict[str, Any], args: argparse.Namespace, out: TextIO) -> None:
    summary = report["summary"]
    print("ASG session waste audit", file=out)
    print(
        f"window={args.since}..{args.before or 'now'} agent={args.agent or 'all'} "
        f"sessions={summary['sessions_listed']} analyzed={summary['sessions_analyzed']} "
        f"mirrors-skipped={summary['mirrors_skipped']}",
        file=out,
    )
    print(
        f"calls={summary['tool_calls']} results-with-bodies={summary['tool_results_with_bodies']} "
        f"result-chars={summary['tool_result_chars']:,}",
        file=out,
    )
    print(
        f"approval-review-rounds={summary['review_rounds']:,} "
        f"approval-context-tokens={summary['review_context_tokens']:,} "
        f"approval-token-share={summary['review_token_share_percent']:.1f}% "
        f"approval-input-chars={summary['review_input_chars']:,} "
        f"decisions={summary['review_decisions']}",
        file=out,
    )
    print(f"flags={summary['flags']}", file=out)

    print("\nHighest-context sessions", file=out)
    rows = []
    for row in report["sessions"][: args.top]:
        rows.append(
            [
                row["id"].replace("codex:", "")[:12],
                row["source"],
                f"{row['peak_context_tokens']:,}",
                str(row["review_rounds"]),
                f"{row['review_context_tokens']:,}",
                f"{row['input_chars']:,}",
                str(row["calls"]),
                f"{row['result_chars']:,}",
                row["first_message"],
            ]
        )
    print_table(
        rows,
        [
            "session",
            "source",
            "peak ctx",
            "reviews",
            "review ctx",
            "input chars",
            "calls",
            "result chars",
            "prompt",
        ],
        out,
    )

    print("\nMost repeated normalized calls", file=out)
    repeat_rows = [
        [str(row["count"]), row["normalized"]]
        for row in report["repeated_calls"][: args.top]
    ]
    print_table(repeat_rows, ["count", "call"], out) if repeat_rows else print("(none)", file=out)

    print("\nMost repeated non-wait calls", file=out)
    nonwait_rows = [
        [str(row["count"]), row["normalized"]]
        for row in report["repeated_nonwait_calls"][: args.top]
    ]
    print_table(nonwait_rows, ["count", "call"], out) if nonwait_rows else print("(none)", file=out)

    print("\nLargest tool results", file=out)
    result_rows = [
        [
            row["session_id"].replace("codex:", "")[:12],
            str(row["event_index"]),
            row["tool"],
            f"{row['reported_tokens']:,}" if row["reported_tokens"] is not None else "?",
            f"{row['chars']:,}",
            f"{row['lines']:,}",
            row["command"],
        ]
        for row in report["largest_results"][: args.top]
    ]
    print_table(
        result_rows,
        ["session", "event", "tool", "reported tok", "captured chars", "lines", "command"],
        out,
    ) if result_rows else print("(no result bodies recovered)", file=out)

    print("\nMost repeated flagged patterns", file=out)
    flag_rows = [
        [
            str(row["count"]),
            row["tool"],
            ",".join(row["flags"]),
            row["subject"],
        ]
        for row in report["flagged_patterns"][: args.top]
    ]
    print_table(flag_rows, ["count", "tool", "flags", "subject"], out) if flag_rows else print("(none)", file=out)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--since", default="yesterday", help="asg date expression")
    parser.add_argument("--before", help="asg exclusive end date")
    parser.add_argument("--agent", default="codex")
    parser.add_argument("--project", help="defaults to asg's cwd inference")
    parser.add_argument(
        "--session",
        action="append",
        help="exact session ID to analyze; repeat to supply a main/review pair",
    )
    parser.add_argument("--max-sessions", type=int, default=100)
    parser.add_argument("--top", type=int, default=12, help="maximum rows per report section")
    parser.add_argument("--json", action="store_true", help="emit the capped report as JSON")
    args = parser.parse_args()
    if args.max_sessions < 1 or args.max_sessions > 1000:
        parser.error("--max-sessions must be in 1..1000")
    if args.top < 1 or args.top > 100:
        parser.error("--top must be in 1..100")
    return args


def main() -> int:
    args = parse_args()
    try:
        report = analyze(args)
    except (OSError, RuntimeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    if args.json:
        json.dump(capped_report(report, args.top), sys.stdout, indent=2)
        print()
    else:
        render(report, args, sys.stdout)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
