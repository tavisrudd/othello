#!/usr/bin/env python3
"""C528: exact mex-spectrum probe for the frozen capOVER residual cores.

The full rooted game signatures grow rapidly (C549), while the root Grundy
values stay at most five (C528).  This probe discards follower identity but
retains the exact set of follower nimbers seen by mex.  It also records the
nimber spectrum at every descendant depth and tests the cheapest local
defect signature of a root move:

    (number of incident active triples, load-one conflict degree).

Exploratory runs may use --limit.  The reproducibility certificate may not.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from pathlib import Path

import c528_overload_profile as overload
import c549_private_boundary_signatures as signatures


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-23-c528-mex-skeleton-probe.json"
SCRIPT = Path(__file__).resolve()
ORDERS = tuple((q, rows) for q, rows in overload.ORDERS if q in (17, 19))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def mex(values: set[int]) -> int:
    value = 0
    while value in values:
        value += 1
    return value


def exact_game(
    pair_adj: list[int], gadgets: list[int]
) -> tuple[int, set[int], list[int], Counter, Counter, int]:
    """Return root SG/options, depth SG maxima/distributions, and state count."""
    n = len(pair_adj)
    incident: list[list[int]] = [[] for _ in range(n)]
    for gadget_index, gadget in enumerate(gadgets):
        for vertex in overload.GEOMETRY.bits(gadget):
            incident[vertex].append(gadget_index)

    memo: dict[int, int] = {}
    option_memo: dict[int, set[int]] = {}

    def visit(chosen: int, available: int) -> int:
        known = memo.get(chosen)
        if known is not None:
            return known
        options: set[int] = set()
        moves = available
        while moves:
            bit = moves & -moves
            vertex = bit.bit_length() - 1
            after = available & ~(bit | pair_adj[vertex])
            for gadget_index in incident[vertex]:
                gadget = gadgets[gadget_index]
                if (chosen & gadget).bit_count() == 1:
                    after &= ~gadget
            options.add(visit(chosen | bit, after))
            moves ^= bit
        value = mex(options)
        memo[chosen] = value
        option_memo[chosen] = options
        return value

    full = (1 << n) - 1
    root = visit(0, full)
    root_moves = []
    for vertex in range(n):
        bit = 1 << vertex
        after = full & ~(bit | pair_adj[vertex])
        for gadget_index in incident[vertex]:
            after &= ~gadgets[gadget_index]
        root_moves.append(visit(bit, after))
    depth_max = Counter()
    depth_dist = Counter()
    for chosen, value in memo.items():
        depth = chosen.bit_count()
        depth_max[depth] = max(depth_max[depth], value)
        depth_dist[(depth, value)] += 1
    return root, option_memo[0], root_moves, depth_max, depth_dist, len(memo)


def add_counter(target: Counter, source: Counter) -> None:
    target.update(source)


def run_q(q: int, rows: Path, limit: int | None) -> dict:
    game = overload.C20.PrimeGridGame(q)
    lines = overload.CENSUS.projective_lines(game)
    states, _ = overload.C31.load_p_reply_states(rows, q)
    residual, _ = overload.find_residual_and_witnesses(game, lines, states, False)
    residual = sorted(residual)
    if limit is not None:
        residual = residual[:limit]

    root_sg = Counter()
    root_height = Counter()
    root_height_sg = Counter()
    root_height_sg_options = Counter()
    root_height_minus_sg = Counter()
    height_sg_parity_violations = 0
    root_option_sets = Counter()
    root_option_width = Counter()
    descendant_depth_dist = Counter()
    descendant_depth_max = Counter()
    descendant_global_sg = Counter()
    local_signature_values: dict[tuple[int, int], Counter] = defaultdict(Counter)
    local_signature_impure_roots = Counter()
    root_rows = hashlib.sha256()
    visited = 0

    for root in residual:
        cells, pair_adj, gadgets = signatures.static_residual(game, lines, root)
        value, options, root_moves, depth_max, depth_dist, state_count = exact_game(
            pair_adj, gadgets
        )
        height = max(depth_max)
        visited += state_count
        root_sg[value] += 1
        root_height[height] += 1
        root_height_sg[(height, value)] += 1
        option_key = tuple(sorted(options))
        root_height_sg_options[(height, value, option_key)] += 1
        root_height_minus_sg[height - value] += 1
        height_sg_parity_violations += (height - value) % 2 != 0
        root_option_sets[option_key] += 1
        root_option_width[len(options)] += 1
        add_counter(descendant_depth_dist, depth_dist)
        for depth, maximum in depth_max.items():
            descendant_depth_max[depth] = max(descendant_depth_max[depth], maximum)
        for (_depth, descendant_value), count in depth_dist.items():
            descendant_global_sg[descendant_value] += count

        incident_count = [0] * len(cells)
        for gadget in gadgets:
            for vertex in overload.GEOMETRY.bits(gadget):
                incident_count[vertex] += 1

        move_values: list[tuple[tuple[int, int], int]] = []
        for vertex, child_value in enumerate(root_moves):
            local = (incident_count[vertex], pair_adj[vertex].bit_count())
            local_signature_values[local][child_value] += 1
            move_values.append((local, child_value))

        per_root_local: dict[tuple[int, int], set[int]] = defaultdict(set)
        for local, child_value in move_values:
            per_root_local[local].add(child_value)
        for local, values in per_root_local.items():
            if len(values) > 1:
                local_signature_impure_roots[local] += 1

        row = {
            "root": root,
            "height": height,
            "sg": value,
            "options": option_key,
            "depth_max": sorted(depth_max.items()),
            "local_moves": sorted(
                (local[0], local[1], child_value)
                for local, child_value in move_values
            ),
        }
        root_rows.update(
            (json.dumps(row, sort_keys=True, separators=(",", ":")) + "\n").encode()
        )

    return {
        "q": q,
        "states": len(residual),
        "limited": limit is not None,
        "visited_chosen_sets": visited,
        "root_rows_sha256": root_rows.hexdigest(),
        "root_sg": dict(sorted(root_sg.items())),
        "root_height": dict(sorted(root_height.items())),
        "root_height_sg": [
            {"height": height, "sg": value, "count": count}
            for (height, value), count in sorted(root_height_sg.items())
        ],
        "root_height_sg_options": [
            {
                "height": height,
                "sg": value,
                "options": list(options),
                "count": count,
            }
            for (height, value, options), count
            in sorted(root_height_sg_options.items())
        ],
        "root_height_minus_sg": dict(sorted(root_height_minus_sg.items())),
        "height_sg_parity_violations": height_sg_parity_violations,
        "root_option_sets": [
            {"options": list(options), "count": count, "mex": mex(set(options))}
            for options, count in sorted(root_option_sets.items())
        ],
        "root_option_width": dict(sorted(root_option_width.items())),
        "descendant_sg": dict(sorted(descendant_global_sg.items())),
        "descendant_depth_max": dict(sorted(descendant_depth_max.items())),
        "descendant_depth_sg": [
            {"depth": depth, "sg": value, "count": count}
            for (depth, value), count in sorted(descendant_depth_dist.items())
        ],
        "local_move_signature": [
            {
                "triple_incidence": local[0],
                "pair_degree": local[1],
                "moves": sum(values.values()),
                "child_sg": dict(sorted(values.items())),
                "impure_roots": local_signature_impure_roots[local],
            }
            for local, values in sorted(local_signature_values.items())
        ],
    }


def build(limit: int | None, selected_q: int | None = None) -> dict:
    selected = tuple(
        (q, rows) for q, rows in ORDERS if selected_q is None or q == selected_q
    )
    results = [run_q(q, rows, limit) for q, rows in selected]
    sources = {
        str(path.relative_to(ROOT)): {
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        }
        for path in (
            SCRIPT,
            Path(overload.__file__).resolve(),
            Path(signatures.__file__).resolve(),
            *(rows for _q, rows in selected),
        )
    }
    return {
        "task": "C528",
        "kind": "mex_skeleton_probe",
        "limited": limit is not None,
        "sources": sources,
        "orders": results,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int)
    parser.add_argument("--q", type=int, choices=[17, 19])
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = build(args.limit, args.q)
    encoded = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        if args.limit is not None or args.q is not None:
            raise SystemExit("--check does not accept --limit or --q")
        if OUT.read_text() != encoded:
            raise SystemExit(f"FAIL: {OUT} differs from regenerated output")
        print(f"PASS {OUT}")
    else:
        if args.limit is not None or args.q is not None:
            print(encoded, end="")
        else:
            OUT.write_text(encoded)
            print(f"WROTE {OUT}")


if __name__ == "__main__":
    main()
