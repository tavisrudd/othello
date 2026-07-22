#!/usr/bin/env python3
"""Independent certificate replay for the C80 pointed-cubic bridge."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
CERTIFICATE = ROOT / "notes/2026-07-22-c80-pointed-cubic-bridge.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_candidate(record):
    counts = [count for _ratio, count in record["quotient_counts"]]
    factorial_third = sum(math.comb(count, 3) for count in counts)
    assert factorial_third == record["quotient_factorial_third"]
    assert record["q3"] == (max(counts, default=0) >= 3)
    assert record["q3"] == (factorial_third > 0)
    assert record["moments"][2] == record["word_trace_three"]
    triple_excess = record["moments"][2] - 10 * record["moments"][0]
    assert triple_excess == record["triple_word_excess"]
    assert triple_excess == 6 * sum(record["unordered_triple_fixed_counts"])
    assert record["unordered_triple_fixed_counts"] == [
        1 if discriminant == 0 else (2 if pow(discriminant, 8, 17) == 1 else 0)
        for discriminant in record["unordered_triple_discriminants"]
    ]


def main() -> int:
    payload = json.loads(CERTIFICATE.read_text())
    for relative, expected in payload["sources"].items():
        assert sha256(ROOT / relative) == expected

    q11 = payload["q11"]
    assert q11["pointed_states"] == 4
    assert q11["vertex_orbit_sizes"] == [1, 1, 5, 5, 5, 5]
    assert q11["winning_edge_orbital_sizes"] == [1] + [5] * 8
    assert q11["perfect_matchings_per_state"] == 2

    q17 = payload["q17"]
    assert q17["score9_transitions"] == 28
    assert q17["primitive_candidates"] == 112
    assert sum(profile["count"] for profile in q17["profiles"]) == 112
    assert q17["moment_pair_is_value_pure_on_this_corpus"]
    assert q17["clean_moment_pairs"] == [[74, 60], [80, 50]]
    assert q17["zero_triple_fixed_packet"] == {
        "definition": "all four unordered triple products have no fixed conic parameter",
        "empty_transitions": 4,
        "impure_transitions": 0,
        "prior_triple_gate": [
            {
                "packet_size": 1,
                "prior_triple_fixed_points": 0,
                "transitions": 24,
            },
            {
                "packet_size": 0,
                "prior_triple_fixed_points": 2,
                "transitions": 4,
            },
        ],
        "reply_dependent_conditions": 3,
        "unique_clean_reply_transitions": 24,
        "without_primitive_restriction": [
            {
                "all_clean": True,
                "all_p": True,
                "primitive_members": 0,
                "size": 0,
                "transitions": 4,
            },
            {
                "all_clean": False,
                "all_p": False,
                "primitive_members": 1,
                "size": 5,
                "transitions": 24,
            },
        ],
    }
    assert q17["q3_clean_contingency"] == [
        {"clean": False, "count": 57, "q3": False},
        {"clean": True, "count": 18, "q3": False},
        {"clean": False, "count": 27, "q3": True},
        {"clean": True, "count": 10, "q3": True},
    ]
    for profile in q17["profiles"]:
        assert profile["q3"] == (profile["quotient_factorial_third"] > 0)

    witnesses = q17["independence_witnesses"]
    same_trace = witnesses["same_tr_B3_different_Q3"]
    same_q3 = witnesses["same_Q3_different_tr_B3"]
    for record in same_trace + same_q3:
        check_candidate(record)
    assert same_trace[0]["word_trace_three"] == same_trace[1]["word_trace_three"]
    assert same_trace[0]["q3"] != same_trace[1]["q3"]
    assert same_q3[0]["q3"] == same_q3[1]["q3"]
    assert same_q3[0]["word_trace_three"] != same_q3[1]["word_trace_three"]

    print("C80 pointed cubic bridge independent replay: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
