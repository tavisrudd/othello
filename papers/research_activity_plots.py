#!/usr/bin/env python3
"""Generate readable, dependency-free daily research charts as SVG."""

from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import os
import sqlite3
import subprocess
from collections import defaultdict
from pathlib import Path
from zoneinfo import ZoneInfo


COLORS = [
    "#2563eb", "#dc2626", "#059669", "#9333ea", "#ea580c", "#0891b2",
    "#4f46e5", "#be123c", "#65a30d", "#c026d3", "#0f766e", "#a16207",
]

def stats_for(project: str, args: argparse.Namespace) -> dict:
    command = [
        "agentsview", "stats", "--since", args.since, "--until", args.until,
        "--timezone", args.timezone, "--include-project", project, "--format", "json",
    ]
    import json
    return json.loads(subprocess.check_output(command, text=True))


def date_key(value: str, zone: ZoneInfo) -> dt.date:
    return dt.datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(zone).date()


def collect(args: argparse.Namespace) -> dict:
    zone = ZoneInfo(args.timezone)
    omitted = set(args.omit_date)
    days = defaultdict(lambda: defaultdict(float))
    for project in args.projects:
        report = stats_for(project, args)
        for row in report["temporal"]["hourly_utc"]:
            local = dt.datetime.fromisoformat(row["ts"].replace("Z", "+00:00")).astimezone(zone)
            if local.date().isoformat() in omitted:
                continue
            if row.get("user_messages", 0):
                days[local.date()]["active_hours_set" + str(local.hour)] = 1
            days[local.date()]["user_messages"] += row.get("user_messages", 0)
            days[local.date()]["sessions_started"] += row.get("sessions", 0)

    db_root = os.environ.get("AGENTSVIEW_DATA_DIR", os.path.expanduser("~/.agentsview"))
    connection = sqlite3.connect(f"file:{db_root}/sessions.db?mode=ro", uri=True)
    start = f"{args.since}T00:00:00Z"
    end = f"{args.until}T00:00:00Z"
    rows = connection.execute(
        """
        SELECT s.started_at, m.timestamp, m.role, m.model, m.output_tokens,
               m.context_tokens, m.token_usage, m.has_thinking, m.has_tool_use
        FROM sessions s JOIN messages m ON m.session_id=s.id
        WHERE s.project IN ({}) AND s.started_at >= ? AND s.started_at < ?
        """.format(",".join("?" for _ in args.projects)),
        [*args.projects, start, end],
    )
    for started, timestamp, role, model, output_tokens, context_tokens, usage, has_thinking, has_tool_use in rows:
        if not timestamp:
            continue
        day = date_key(timestamp, zone)
        if day.isoformat() in omitted:
            continue
        if role == "user":
            days[day]["user_turns"] += 1
        if role in {"assistant", "agent"}:
            days[day]["agent_turns"] += 1
        input_tokens = 0
        generated_tokens = output_tokens or 0
        if usage:
            try:
                record = json.loads(usage)
            except json.JSONDecodeError:
                record = {}
            input_tokens = sum(record.get(key, 0) or 0 for key in (
                "input_tokens", "cache_read_input_tokens", "cache_creation_input_tokens"
            ))
            generated_tokens = record.get("output_tokens", generated_tokens) or 0
            days[day]["usage_rows"] += 1
        else:
            # Some providers do not persist a usage JSON record.  Use the
            # recorded context/output columns as a conservative fallback.
            input_tokens = context_tokens or 0
            days[day]["fallback_rows"] += 1
        days[day]["input_tokens"] += input_tokens
        days[day]["output_tokens"] += generated_tokens
        days[day]["total_tokens"] += input_tokens + generated_tokens
        if has_thinking:
            days[day]["thinking_messages"] += 1
        if has_tool_use:
            days[day]["tool_messages"] += 1
        if model:
            days[day]["model:" + model] += input_tokens + generated_tokens
    connection.close()
    if days:
        cursor = min(days)
        while cursor <= max(days):
            days[cursor]
            cursor += dt.timedelta(days=1)

    return {
        day.isoformat(): {
            "active_hours": sum(1 for key in values if key.startswith("active_hours_set")),
            **{key: value for key, value in values.items() if not key.startswith("active_hours_set")},
        }
        for day, values in days.items()
    }


def number(value: float) -> str:
    if value >= 1_000_000:
        return f"{value / 1_000_000:.1f}M"
    if value >= 1_000:
        return f"{value / 1_000:.0f}k"
    return f"{value:.0f}"


def nice_step(value: float, target_ticks: int = 6) -> float:
    raw = max(value, 1) / target_ticks
    magnitude = 10 ** int(len(str(int(raw))) - 1)
    for factor in (1, 2, 5, 10):
        step = factor * magnitude
        if step >= raw:
            return step
    return 10 * magnitude


def chart(
    path: Path,
    title: str,
    subtitle: str,
    data: dict,
    series: list[tuple[str, str, str]],
    ylabel: str,
    bars: bool = False,
    stacked: bool = False,
) -> None:
    width, height = 1600, 760
    left, right, top, bottom = 120, 45, 155, 145
    x0, x1, y0, y1 = left, width - right, height - bottom, top
    days = sorted(data)
    max_value = max((data[day].get(key, 0) for day in days for key, _, _ in series), default=1) or 1
    step = nice_step(max_value)
    ymax = step * max(1, int(max_value / step + 0.999999))
    lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="white"/>',
        f'<text x="{left}" y="42" font-family="sans-serif" font-size="28" font-weight="bold">{html.escape(title)}</text>',
        f'<text x="{left}" y="70" font-family="sans-serif" font-size="16" fill="#555">{html.escape(subtitle)}</text>',
    ]
    legend_step = 600 if len(series) <= 2 else 365
    for index, (_, label, color) in enumerate(series):
        lx = left + (index % (2 if len(series) <= 2 else 4)) * legend_step
        ly = 102 + (index // 4) * 25
        lines.append(f'<line x1="{lx}" y1="{ly-6}" x2="{lx+24}" y2="{ly-6}" stroke="{color}" stroke-width="4"/>')
        lines.append(f'<text x="{lx+34}" y="{ly}" font-family="sans-serif" font-size="15">{html.escape(label)}</text>')

    lines.append(f'<line x1="{x0}" y1="{y0}" x2="{x1}" y2="{y0}" stroke="#6b7280"/>')
    lines.append(f'<line x1="{x0}" y1="{y0}" x2="{x0}" y2="{y1}" stroke="#6b7280"/>')
    for tick in range(0, int(ymax) + 1, int(step)):
        y = y0 - (y0 - y1) * tick / ymax
        lines.append(f'<line x1="{x0}" y1="{y:.1f}" x2="{x1}" y2="{y:.1f}" stroke="#e5e7eb"/>')
        lines.append(f'<text x="{x0-12}" y="{y+5:.1f}" text-anchor="end" font-family="sans-serif" font-size="14">{number(tick)}</text>')

    positions = []
    for index, day in enumerate(days):
        x = x0 + (x1 - x0) * index / max(1, len(days) - 1)
        positions.append(x)
        if index == 0 or index == len(days) - 1 or index % max(1, len(days) // 8) == 0:
            label = day[5:]
            lines.append(f'<line x1="{x:.1f}" y1="{y0}" x2="{x:.1f}" y2="{y0+7}" stroke="#6b7280"/>')
            lines.append(f'<text x="{x:.1f}" y="{y0+28}" text-anchor="middle" font-family="sans-serif" font-size="13" transform="rotate(-35 {x:.1f} {y0+28})">{label}</text>')

    if bars:
        bar_width = max(3, (x1 - x0) / max(1, len(days)) * 0.7)
        if stacked:
            for day, x in zip(days, positions):
                cumulative = 0
                for key, label, color in series:
                    value = data[day].get(key, 0)
                    low = cumulative
                    cumulative += value
                    y_top = y0 - (y0 - y1) * cumulative / ymax
                    y_bottom = y0 - (y0 - y1) * low / ymax
                    lines.append(f'<rect x="{x-bar_width/2:.1f}" y="{y_top:.1f}" width="{bar_width:.1f}" height="{y_bottom-y_top:.1f}" fill="{color}" fill-opacity=".78"><title>{day}: {label}: {value:,.0f}</title></rect>')
        else:
            for key, label, color in series:
                for day, x in zip(days, positions):
                    value = data[day].get(key, 0)
                    y = y0 - (y0 - y1) * value / ymax
                    lines.append(f'<rect x="{x-bar_width/2:.1f}" y="{y:.1f}" width="{bar_width:.1f}" height="{y0-y:.1f}" fill="{color}" fill-opacity=".75"><title>{day}: {label}: {value:,.0f}</title></rect>')
    else:
        for key, label, color in series:
            points = []
            for day, x in zip(days, positions):
                value = data[day].get(key, 0)
                y = y0 - (y0 - y1) * value / ymax
                points.append(f"{x:.1f},{y:.1f}")
                lines.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="3.5" fill="{color}"><title>{html.escape(day + ": " + label)}: {value:,.0f}</title></circle>')
            lines.append(f'<polyline points="{" ".join(points)}" fill="none" stroke="{color}" stroke-width="2.5" stroke-linejoin="round"/>')

    mid = (y0 + y1) / 2
    lines.append(f'<text x="28" y="{mid:.1f}" transform="rotate(-90 28 {mid:.1f})" text-anchor="middle" font-family="sans-serif" font-size="16">{html.escape(ylabel)}</text>')
    lines.append(f'<text x="{(x0+x1)/2:.1f}" y="{height-25}" text-anchor="middle" font-family="sans-serif" font-size="16">Local date (MM-DD, America/Los_Angeles)</text>')
    lines.append('</svg>')
    path.write_text("\n".join(lines))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--since", default="2026-06-01")
    parser.add_argument("--until", default="2026-08-04")
    parser.add_argument("--timezone", default="America/Los_Angeles")
    parser.add_argument("--projects", nargs="+", default=["rust", "othello"])
    parser.add_argument("--output-dir", default="figures/research-activity")
    parser.add_argument("--omit-date", action="append", default=[], help="calendar date to leave blank in the figures")
    args = parser.parse_args()
    output = Path(args.output_dir)
    output.mkdir(parents=True, exist_ok=True)
    data = collect(args)
    subtitle = f"{args.since} through {args.until}; projects: {', '.join(args.projects)}"
    active_total = sum(data[day].get("active_hours", 0) for day in data)
    active_peak = max((data[day].get("active_hours", 0) for day in data), default=0)
    chart(output / "daily-active-hours.svg", "Daily active research hours", subtitle + f"; total: {active_total:,.0f} hours; peak: {active_peak:,.0f}; an active hour has at least one user message", data, [("active_hours", "Active hours", COLORS[0])], "Hours with user activity", bars=True)
    session_activity_total = sum(data[day].get("sessions_started", 0) for day in data)
    chart(output / "daily-session-activity.svg", "Daily session activity", subtitle + f"; total: {session_activity_total:,.0f} active session-hours; README aggregate: 1,234 human sessions", data, [("sessions_started", "Active session-hours", COLORS[0])], "Active session-hours", bars=True)
    user_total = sum(data[day].get("user_turns", 0) for day in data)
    agent_total = sum(data[day].get("agent_turns", 0) for day in data)
    chart(output / "daily-conversation-turns.svg", "Daily conversation turns", subtitle + f"; totals: {user_total:,.0f} user, {agent_total:,.0f} agent turns", data, [("user_turns", "User turns", COLORS[1]), ("agent_turns", "Agent turns", COLORS[2])], "Turns", bars=False)
    total_input = sum(data[day].get("input_tokens", 0) for day in data)
    total_output = sum(data[day].get("output_tokens", 0) for day in data)
    total_tokens = sum(data[day].get("total_tokens", 0) for day in data)
    token_subtitle = (subtitle + f"; input/context: {total_input:,.0f}; generated: {total_output:,.0f}; "
                      f"combined: {total_tokens:,.0f}; provider telemetry, not quota billing")
    chart(output / "daily-token-volume.svg", "Daily recorded API token volume", token_subtitle, data,
          [("input_tokens", "Input/context tokens (including cache reads/writes)", COLORS[0]),
           ("output_tokens", "Generated tokens", COLORS[3])], "Tokens", bars=True, stacked=True)
    models = sorted({key[6:] for row in data.values() for key in row if key.startswith("model:") and row[key] > 0})
    chart(output / "daily-model-token-volume.svg", "Daily recorded API tokens by model", subtitle + "; input plus generated tokens; provider telemetry",
          data, [("model:" + model, model, COLORS[index % len(COLORS)]) for index, model in enumerate(models)], "Tokens", bars=False)
    for old in ("activity-scatter.svg", "model-token-scatter.svg", "daily-sessions-and-turns.svg", "daily-sessions.svg", "daily-output-tokens.svg", "daily-model-output-tokens.svg"):
        stale = output / old
        if stale.exists():
            stale.unlink()
    for path in sorted(output.glob("daily-*.svg")):
        print(path)


if __name__ == "__main__":
    main()
