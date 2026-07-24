#!/usr/bin/env python3
"""C528: contextual Grundy census by overloaded-line conic type.

For a residual capOVER child C, the continuation is the finite hypergraph game on
its currently legal points:

* a line of residual capacity one forbids every pair on that line;
* a line of residual capacity two forbids every triple on that line.

An overloaded capacity-two line is one of C528's gadgets.  Its isolated Grundy
number is always zero, so this script measures a contextual marginal instead:
the XOR change in the full residual Grundy number when that line's triple
constraint is deleted.  It also tests the stronger collective ablation obtained
by deleting all overloaded constraints of one conic-incidence type.

Exploratory runs may use --limit.  A reproducibility certificate must not.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from functools import lru_cache
from pathlib import Path

import c528_overload_profile as overload


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-23-c528-grundy-conic-census.json"
TYPE_NAME = {0: "external", 1: "tangent", 2: "secant"}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def residual_grundy(game, lines, root: int, omitted: frozenset[int] = frozenset()) -> int:
    """Exact SG of the root continuation, omitting named capacity-two line rules."""
    legal = game.legal_mask(root)
    cells = list(overload.GEOMETRY.bits(legal))
    local = {cell: i for i, cell in enumerate(cells)}
    n = len(cells)
    pair_adj = [0] * n
    cap_two: list[int] = []

    for line_mask, fixed_load in lines:
        on_line = legal & line_mask
        if not on_line:
            continue
        load = fixed_load + (root & line_mask).bit_count()
        local_mask = 0
        for cell in overload.GEOMETRY.bits(on_line):
            local_mask |= 1 << local[cell]
        if load == 1:
            for i in overload.GEOMETRY.bits(local_mask):
                pair_adj[i] |= local_mask ^ (1 << i)
        elif load == 0 and line_mask not in omitted and local_mask.bit_count() >= 3:
            cap_two.append(local_mask)

    incident: list[list[int]] = [[] for _ in range(n)]
    for line_index, line_mask in enumerate(cap_two):
        for i in overload.GEOMETRY.bits(line_mask):
            incident[i].append(line_index)

    memo: dict[int, int] = {}

    def sg(chosen: int, available: int) -> int:
        if chosen in memo:
            return memo[chosen]
        options: set[int] = set()
        moves = available
        while moves:
            bit = moves & -moves
            i = bit.bit_length() - 1
            after = available & ~(bit | pair_adj[i])
            for line_index in incident[i]:
                line_mask = cap_two[line_index]
                if (chosen & line_mask).bit_count() == 1:
                    after &= ~line_mask
            options.add(sg(chosen | bit, after))
            moves ^= bit
        value = 0
        while value in options:
            value += 1
        memo[chosen] = value
        return value

    return sg(0, (1 << n) - 1)


def add_joint(counter: Counter, line_type: int, k: int, delta: int) -> None:
    counter[(TYPE_NAME[line_type], k, delta)] += 1


def summarize_joint(counter: Counter, outcome_flips: Counter) -> list[dict]:
    grouped: dict[tuple[str, int], Counter] = {}
    for (line_type, k, delta), count in counter.items():
        grouped.setdefault((line_type, k), Counter())[delta] += count
    return [
        {
            "type": line_type,
            "k": k,
            "lines": sum(deltas.values()),
            "zero_delta": deltas[0],
            "nonzero_delta": sum(count for delta, count in deltas.items() if delta),
            "p_after_ablation": outcome_flips[(line_type, k)],
            "xor_delta_distribution": dict(sorted(deltas.items())),
        }
        for (line_type, k), deltas in sorted(grouped.items())
    ]


def run_q(q: int, rows: Path, limit: int | None) -> dict:
    game = overload.C20.PrimeGridGame(q)
    lines = overload.CENSUS.projective_lines(game)
    states, _ = overload.C31.load_p_reply_states(rows, q)
    residual, _ = overload.find_residual_and_witnesses(game, lines, states, False)
    residual = sorted(residual)
    if limit is not None:
        residual = residual[:limit]

    joint = Counter()
    line_outcome_flips = Counter()
    line_context = Counter()
    collective = Counter()
    collective_present = Counter()
    collective_zero_delta = Counter()
    collective_outcome_flips = Counter()
    full_dist = Counter()
    gadget_count_full = Counter()
    legal_dist = Counter()
    gadget_dist = Counter()
    gadget_type_totals = Counter()
    gadget_type_max = Counter()
    gadget_type_states = Counter()
    state_digest = hashlib.sha256()

    @lru_cache(maxsize=None)
    def direct_geometry_sg(mask: int) -> int:
        options = {
            direct_geometry_sg(mask | (1 << move))
            for move in overload.GEOMETRY.bits(game.legal_mask(mask))
        }
        value = 0
        while value in options:
            value += 1
        return value

    direct_crosscheck_limit = len(residual) if q <= 17 else min(100, len(residual))
    for root_index, root in enumerate(residual):
        gadgets, legal = overload.overloaded_lines(game, lines, root)
        full = residual_grundy(game, lines, root)
        if root_index < direct_crosscheck_limit:
            assert full == direct_geometry_sg(root)
            assert (full != 0) == game.value(root)
        full_dist[full] += 1
        gadget_count_full[(len(gadgets), full)] += 1
        legal_dist[legal.bit_count()] += 1
        gadget_dist[len(gadgets)] += 1
        root_type_counts = Counter(
            TYPE_NAME[overload.conic_line_type(game, line_mask)]
            for line_mask, _k in gadgets
        )
        for name in TYPE_NAME.values():
            count = root_type_counts[name]
            gadget_type_totals[name] += count
            gadget_type_max[name] = max(gadget_type_max[name], count)
            gadget_type_states[name] += count > 0

        per_line = []
        for line_mask, k in gadgets:
            line_type = overload.conic_line_type(game, line_mask)
            assert line_type in TYPE_NAME
            line_context[(TYPE_NAME[line_type], k, full)] += 1
            ablated = residual_grundy(game, lines, root, frozenset({line_mask}))
            delta = full ^ ablated
            add_joint(joint, line_type, k, delta)
            line_outcome_flips[(TYPE_NAME[line_type], k)] += ablated == 0
            per_line.append((TYPE_NAME[line_type], k, delta))

        per_type = {}
        for line_type, name in TYPE_NAME.items():
            omitted = frozenset(
                line_mask
                for line_mask, _k in gadgets
                if overload.conic_line_type(game, line_mask) == line_type
            )
            if omitted:
                ablated = residual_grundy(game, lines, root, omitted)
                delta = full ^ ablated
                collective[(name, delta)] += 1
                collective_present[name] += 1
                collective_zero_delta[name] += delta == 0
                collective_outcome_flips[name] += ablated == 0
                per_type[name] = delta

        row = {
            "root": root,
            "full_grundy": full,
            "legal": legal.bit_count(),
            "per_line": sorted(per_line),
            "per_type_collective_delta": per_type,
        }
        state_digest.update(
            (json.dumps(row, sort_keys=True, separators=(",", ":")) + "\n").encode()
        )

    return {
        "q": q,
        "states": len(residual),
        "limited": limit is not None,
        "state_rows_sha256": state_digest.hexdigest(),
        "direct_geometry_sg_crosscheck": {
            "states": direct_crosscheck_limit,
            "disagreements": 0,
        },
        "full_grundy_distribution": dict(sorted(full_dist.items())),
        "gadget_count_full_grundy": [
            {"g": g, "full_grundy": grundy, "states": count}
            for (g, grundy), count in sorted(gadget_count_full.items())
        ],
        "legal_point_distribution": dict(sorted(legal_dist.items())),
        "gadget_count_distribution": dict(sorted(gadget_dist.items())),
        "gadget_type_summary": {
            name: {
                "lines": gadget_type_totals[name],
                "max_per_state": gadget_type_max[name],
                "states_present": gadget_type_states[name],
            }
            for name in sorted(TYPE_NAME.values())
        },
        "single_line_joint": [
            {"type": t, "k": k, "xor_delta": d, "lines": count}
            for (t, k, d), count in sorted(joint.items())
        ],
        "single_line_by_type_k": summarize_joint(joint, line_outcome_flips),
        "line_context_full_grundy": [
            {"type": t, "k": k, "full_grundy": grundy, "lines": count}
            for (t, k, grundy), count in sorted(line_context.items())
        ],
        "collective_type_ablation": [
            {"type": t, "xor_delta": d, "states": count}
            for (t, d), count in sorted(collective.items())
        ],
        "collective_type_summary": {
            name: {
                "states_present": collective_present[name],
                "zero_delta": collective_zero_delta[name],
                "nonzero_delta": collective_present[name] - collective_zero_delta[name],
                "p_after_ablation": collective_outcome_flips[name],
            }
            for name in sorted(TYPE_NAME.values())
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, choices=(13, 17, 19), action="append")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check and args.limit is not None:
        parser.error("--check cannot be combined with --limit")
    if args.limit is not None and args.output == OUT:
        parser.error("--limit requires an explicit exploratory --output path")

    selected = set(args.q or (13, 17, 19))
    orders = [
        (q, rows) for q, rows in overload.ORDERS if q in selected
    ]
    helper_paths = (
        ROOT / "rust/scripts/c528_overload_profile.py",
        ROOT / "rust/scripts/c80_response_fibre_census.py",
        ROOT / "notes/2026-07-08-zone-repair-geometry.py",
        ROOT / "notes/2026-07-08-zone-steering-census.py",
        ROOT / "notes/2026-07-08-intrusion-census.py",
    )
    source_paths = {rows for _q, rows in orders}
    source_paths.update(helper_paths)
    sources = {
        str(path.relative_to(ROOT)): {
            "sha256": sha256(path),
            "bytes": path.stat().st_size,
        }
        for path in source_paths
    }
    payload = {
        "schema_version": 1,
        "task": "C528",
        "claim_scope": (
            "Exact full residual SG and overloaded-line ablation census on every capOVER-core "
            "residual child in the frozen q=13/17/19 three-intruder domains. The q19 domain is "
            "in-sample frozen data, not an out-of-sample larger-order test."
        ),
        "metric": (
            "Contextual marginal = full residual SG XOR SG after deleting exactly one "
            "overloaded line's capacity-two triple constraint. Collective type ablation "
            "deletes all overloaded constraints of that conic-incidence type at the root. "
            "Because gadgets overlap and are not disjunctive summands, this is an ablation "
            "influence diagnostic, not a canonical additive Grundy contribution."
        ),
        "sources": dict(sorted(sources.items())),
        "orders": [run_q(q, rows, args.limit) for q, rows in orders],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "C528 Grundy/conic census: MISMATCH"
        print("C528 Grundy/conic census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
