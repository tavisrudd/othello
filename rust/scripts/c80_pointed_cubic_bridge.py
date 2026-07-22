#!/usr/bin/env python3
"""C80: compare the two cubic signals in the q=11/q=17 response records."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
import sys
from collections import Counter
from itertools import product
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
Q11 = ROOT / "notes/2026-07-22-c80-c447-cloud-packet.json"
OUT = ROOT / "notes/2026-07-22-c80-pointed-cubic-bridge.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def q11_orbital_summary():
    payload = json.loads(Q11.read_text())
    summaries = []
    for class_record in payload["classes"]:
        for endpoint in class_record["endpoints"]:
            graph = endpoint["winning_response_graph"]
            decomposition = graph["c5_orbital_decomposition"]
            orbital_count = sum(decomposition["winning_edge_orbit_type_counts"].values())
            summaries.append(
                {
                    "class": class_record["class"],
                    "endpoint": endpoint["endpoint_parameter"],
                    "orbit_sizes": sorted(
                        orbit["size"] for orbit in endpoint["square_c5_opponent_orbits"]
                    ),
                    "orbital_sizes": [1] + [5] * (orbital_count - 1),
                    "quotient_edge_counts": graph["quotient_edge_counts"],
                    "perfect_matchings": graph["perfect_matching_count"],
                }
            )
    first = summaries[0]
    assert len(summaries) == 4
    assert all(summary["orbit_sizes"] == [1, 1, 5, 5, 5, 5] for summary in summaries)
    assert all(summary["orbital_sizes"] == [1] + [5] * 8 for summary in summaries)
    assert all(summary["quotient_edge_counts"] == first["quotient_edge_counts"] for summary in summaries)
    assert all(summary["perfect_matchings"] == 2 for summary in summaries)
    return {
        "pointed_states": len(summaries),
        "vertex_orbit_sizes": first["orbit_sizes"],
        "winning_edge_orbital_sizes": first["orbital_sizes"],
        "quotient_edge_counts": first["quotient_edge_counts"],
        "perfect_matchings_per_state": 2,
    }


def word_trace_three(game, intruders):
    permutations = [game.sigma_perm(intruder) for intruder in intruders]
    return sum(
        permutations[i][permutations[j][permutations[k][point]]] == point
        for i, j, k in product(range(len(permutations)), repeat=3)
        for point in game.params
    )


def quotient_collision(c77, q, s5, reply):
    directions = [c77.direction(reply, point, q) for point in s5]
    finite_nonzero = [value for value in directions if value not in (0, q)]
    counts = Counter(
        left * pow(right, -1, q) % q
        for left in finite_nonzero
        for right in finite_nonzero
        if left != right
    )
    factorial_third = sum(math.comb(count, 3) for count in counts.values())
    return tuple(sorted(counts.items())), factorial_third


def q17_summary(rows_path: Path):
    c79 = load_module(ROOT / "rust/scripts/c79_primitive_repair.py", "c80_c79")
    c77 = load_module(ROOT / "rust/scripts/c77_forced_reply_algebra.py", "c80_c77")
    geometry = load_module(ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c80_geometry")
    c31 = geometry.load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(17)
    states, _row_counts = c31.load_p_reply_states(rows_path, 17)
    steering = c31.Steering(game)

    profiles = Counter()
    candidates = []
    transitions = 0
    for mask, row in states:
        for move in geometry.bits(game.legal_mask(mask)):
            child = mask | (1 << move)
            score = int(geometry.best_replies(game, steering, child)[0]["score"])
            if score != 9 or geometry.kind(game, move) != "intruder":
                continue
            transitions += 1
            s5 = tuple(geometry.cell(game, point) for point in row["t4"]) + (
                geometry.cell(game, move),
            )
            packet = []
            for reply in geometry.bits(game.legal_mask(child) & ~game.conic_mask):
                order = geometry.prod_order(game, move, reply)
                if order not in (16, 18):
                    continue
                grand = child | (1 << reply)
                features = game.state_features(grand, geometry.intruders(game, grand))
                intruders = (*geometry.intruders(game, child), reply)
                moments = c79.permutation_moments(game, intruders)
                direct_trace_three = word_trace_three(game, intruders)
                assert moments[2] == direct_trace_three
                quotient_counts, factorial_third = quotient_collision(
                    c77, 17, s5, geometry.cell(game, reply)
                )
                quotient_max = max((count for _ratio, count in quotient_counts), default=0)
                q3 = quotient_max >= 3
                assert q3 == (factorial_third > 0)
                clean = geometry.clean_empty(features)
                p_value = not game.value(grand)
                assert not clean or p_value
                record = {
                    "root": row["canon"],
                    "move": list(geometry.cell(game, move)),
                    "reply": list(geometry.cell(game, reply)),
                    "moments": list(moments),
                    "word_trace_three": direct_trace_three,
                    "quotient_counts": [list(item) for item in quotient_counts],
                    "quotient_factorial_third": factorial_third,
                    "q3": q3,
                    "clean": clean,
                    "p": p_value,
                    "zone_edges": features["zone_edges"],
                }
                packet.append(record)
                candidates.append(record)
                profiles[(moments[1], moments[2], q3, factorial_third, clean, p_value)] += 1
            assert len(packet) == 4

    assert transitions == 28
    assert len(candidates) == 112

    same_trace_different_q3 = None
    same_q3_different_trace = None
    for left_index, left in enumerate(candidates):
        for right in candidates[left_index + 1 :]:
            if left["word_trace_three"] == right["word_trace_three"] and left["q3"] != right["q3"]:
                same_trace_different_q3 = [left, right]
                break
        if same_trace_different_q3:
            break
    for left_index, left in enumerate(candidates):
        for right in candidates[left_index + 1 :]:
            if left["q3"] == right["q3"] and left["word_trace_three"] != right["word_trace_three"]:
                same_q3_different_trace = [left, right]
                break
        if same_q3_different_trace:
            break
    assert same_trace_different_q3 is not None
    assert same_q3_different_trace is not None

    outcomes_by_moment_pair = {}
    for record in candidates:
        pair = tuple(record["moments"][1:3])
        outcomes_by_moment_pair.setdefault(pair, set()).add((record["clean"], record["p"]))
    assert all(len(outcomes) == 1 for outcomes in outcomes_by_moment_pair.values())
    clean_moment_pairs = sorted(
        list(pair)
        for pair, outcomes in outcomes_by_moment_pair.items()
        if outcomes == {(True, True)}
    )
    assert clean_moment_pairs == [[74, 60], [80, 50]]
    q3_clean_contingency = Counter((record["q3"], record["clean"]) for record in candidates)

    return {
        "score9_transitions": transitions,
        "primitive_candidates": len(candidates),
        "identity_checks": {
            "tr_B3_equals_ordered_triple_word_fixed_points": len(candidates),
            "Q3_iff_positive_third_factorial_quotient_collision": len(candidates),
        },
        "moment_pair_is_value_pure_on_this_corpus": True,
        "clean_moment_pairs": clean_moment_pairs,
        "q3_clean_contingency": [
            {"q3": key[0], "clean": key[1], "count": count}
            for key, count in sorted(q3_clean_contingency.items())
        ],
        "profiles": [
            {
                "tr_B2": key[0],
                "tr_B3": key[1],
                "q3": key[2],
                "quotient_factorial_third": key[3],
                "clean": key[4],
                "p": key[5],
                "count": count,
            }
            for key, count in sorted(profiles.items())
        ],
        "independence_witnesses": {
            "same_tr_B3_different_Q3": same_trace_different_q3,
            "same_Q3_different_tr_B3": same_q3_different_trace,
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=Path, default=ROWS)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = {
        "claim": (
            "tr(B^3) is a third word trace in the conic permutation algebra, while Q3 is the "
            "support of a third factorial moment of quotient multiplicities; neither determines "
            "the other on the q=17 score-9 primitive-candidate corpus."
        ),
        "sources": {
            str(args.rows.relative_to(ROOT)): sha256(args.rows),
            str(Q11.relative_to(ROOT)): sha256(Q11),
        },
        "q11": q11_orbital_summary(),
        "q17": q17_summary(args.rows),
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered
        print("C80 pointed cubic bridge: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
