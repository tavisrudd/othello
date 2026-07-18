#!/usr/bin/env python3
"""Exact Node-Kayles probe for adaptive certificates in C84 escape residuals."""

from __future__ import annotations

import argparse
import gc
import itertools
import json
import time
from collections import Counter
from functools import cache
from pathlib import Path

from c84_pairing_locus import s4_representatives
from three_centre_probe import (
    centres,
    conic_point,
    determinant,
    grundy as direct_grundy,
    projective_line,
    residual_graph,
    sigma,
)


def solve(adjacency: tuple[int, ...]) -> dict[str, object]:
    n = len(adjacency)
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))

    def components(mask: int) -> list[int]:
        out = []
        unseen = mask
        while unseen:
            frontier = unseen & -unseen
            component = 0
            while frontier:
                component |= frontier
                unseen &= ~frontier
                neighbours = 0
                bits = frontier
                while bits:
                    bit = bits & -bits
                    neighbours |= adjacency[bit.bit_length() - 1]
                    bits ^= bit
                frontier = neighbours & unseen
            out.append(component)
        return out

    @cache
    def grundy(mask: int) -> int:
        pieces = components(mask)
        if not pieces:
            return 0
        if len(pieces) > 1:
            value = 0
            for piece in pieces:
                value ^= grundy(piece)
            return value
        options = set()
        bits = mask
        while bits:
            bit = bits & -bits
            vertex = bit.bit_length() - 1
            options.add(grundy(mask & ~closed[vertex]))
            bits ^= bit
        value = 0
        while value in options:
            value += 1
        return value

    full = (1 << n) - 1
    value = grundy(full)
    reply_counts = []
    best_component_widths = []
    best_remaining_sizes = []
    if value == 0:
        for first in range(n):
            follower = full & ~closed[first]
            replies = 0
            reply_shapes = []
            bits = follower
            while bits:
                bit = bits & -bits
                second = bit.bit_length() - 1
                grandchild = follower & ~closed[second]
                if grundy(grandchild) == 0:
                    replies += 1
                    pieces = components(grandchild)
                    reply_shapes.append((
                        max((piece.bit_count() for piece in pieces), default=0),
                        grandchild.bit_count(),
                    ))
                bits ^= bit
            reply_counts.append(replies)
            best_width = min(width for width, _ in reply_shapes)
            best_component_widths.append(best_width)
            best_remaining_sizes.append(min(
                size for width, size in reply_shapes if width == best_width
            ))
        assert reply_counts and min(reply_counts) > 0
    return {
        "adaptive_component_width": max(best_component_widths) if best_component_widths else None,
        "adaptive_remaining_vertices": max(best_remaining_sizes) if best_remaining_sizes else None,
        "grundy": value,
        "memo_states": grundy.cache_info().currsize,
        "reply_count_max": max(reply_counts) if reply_counts else None,
        "reply_count_min": min(reply_counts) if reply_counts else None,
        "vertices": n,
    }


def probe(
    q: int,
    label: str,
    limit: int | None,
    summary: bool,
    direct_cross_check: bool,
) -> dict[str, object]:
    parameters = projective_line(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    perms = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in points
    }
    reps, subgroup_points = s4_representatives(q, points, perms)
    selected = reps[label]
    rows = []
    for candidate in points:
        if candidate in selected or candidate in subgroup_points:
            continue
        if any(
            determinant((a, b, candidate), q) == 0
            for a, b in itertools.combinations(selected, 2)
        ):
            continue
        started = time.monotonic()
        _, adjacency, _ = residual_graph((*selected, candidate), parameters, conic, q)
        row = solve(adjacency)
        if direct_cross_check:
            direct_grundy.cache_clear()
            direct_value = direct_grundy(adjacency, (1 << len(adjacency)) - 1)
            assert direct_value == row["grundy"], (candidate, direct_value, row["grundy"])
            row["direct_memo_states"] = direct_grundy.cache_info().currsize
        row["candidate"] = list(candidate)
        row["wall_seconds"] = round(time.monotonic() - started, 6)
        rows.append(row)
        gc.collect()
        if limit is not None and len(rows) >= limit:
            break
    result = {
        "class": label,
        "q": q,
        "rows": rows,
        "selected": [list(point) for point in selected],
    }
    if summary:
        p_rows = [row for row in rows if row["grundy"] == 0]
        result.pop("rows")
        result["summary"] = {
            "grundy_counts": dict(sorted(Counter(row["grundy"] for row in rows).items())),
            "memo_states_max": max(row["memo_states"] for row in rows),
            "p_children": len(p_rows),
            "p_component_width_histogram": dict(sorted(Counter(
                row["adaptive_component_width"] for row in p_rows
            ).items())),
            "p_memo_states_max": max((row["memo_states"] for row in p_rows), default=None),
            "p_remaining_vertices_histogram": dict(sorted(Counter(
                row["adaptive_remaining_vertices"] for row in p_rows
            ).items())),
            "p_reply_count_min_histogram": dict(sorted(Counter(
                row["reply_count_min"] for row in p_rows
            ).items())),
            "rows": len(rows),
            "vertex_counts": dict(sorted(Counter(row["vertices"] for row in rows).items())),
            "wall_seconds_sum": round(sum(row["wall_seconds"] for row in rows), 6),
        }
        if direct_cross_check:
            result["summary"]["direct_memo_states_max"] = max(
                row["direct_memo_states"] for row in rows
            )
    return result


def report_summary(results: list[dict[str, object]]) -> dict[str, object]:
    cases = []
    for result in results:
        summary = result["summary"]
        cases.append({
            "class": result["class"],
            "grundy_counts": summary["grundy_counts"],
            "memo_states_max": summary["memo_states_max"],
            "p_children": summary["p_children"],
            "p_component_width_histogram": summary["p_component_width_histogram"],
            "p_reply_count_min_histogram": summary["p_reply_count_min_histogram"],
            "q": result["q"],
            "rows": summary["rows"],
            "selected": result["selected"],
            "vertex_counts": summary["vertex_counts"],
        })
    return {"cases": cases, "schema": "c84-adaptive-core-v1"}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="+", type=int)
    parser.add_argument("--class", dest="label", choices=tuple("ABCD"), default="D")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--summary", action="store_true")
    parser.add_argument("--direct-cross-check", action="store_true")
    parser.add_argument("--report-summary", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    results = [
        probe(
            q,
            args.label,
            args.limit,
            args.summary,
            args.direct_cross_check,
        )
        for q in args.q
    ]
    result: object = results[0] if len(results) == 1 else {"cases": results}
    if args.report_summary:
        if not args.summary or args.limit is not None:
            parser.error("--report-summary requires --summary and forbids --limit")
        result = report_summary(results)
    if args.check:
        tracked = Path(__file__).resolve().parents[2] / "notes" / (
            "2026-07-17-c84-adaptive-core.json"
        )
        normalized = json.loads(json.dumps(result, sort_keys=True))
        if json.loads(tracked.read_text()) != normalized:
            raise SystemExit("tracked adaptive-core JSON differs from regeneration")
        print(f"OK: {len(results)} class-D fields; tracked adaptive-core JSON matches")
    else:
        print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
