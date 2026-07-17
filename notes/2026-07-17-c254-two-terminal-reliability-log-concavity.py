#!/usr/bin/env python3
"""C254: exact coefficient scout for two-terminal series--parallel networks.

For a two-terminal network G with m edges, ``success(G)[k]`` counts the
k-edge subsets that connect the terminals.  The script enumerates distinct
success profiles, retaining a series/parallel expression as an exact witness.
All arithmetic is integral.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-17-c254-two-terminal-reliability-log-concavity.json"
EDGE_BUDGET = 14


Profile = tuple[int, ...]


@dataclass(frozen=True)
class Witness:
    expression: str
    operation: str
    left: Profile | None = None
    right: Profile | None = None


def convolve(left: Profile, right: Profile) -> Profile:
    answer = [0] * (len(left) + len(right) - 1)
    for i, left_value in enumerate(left):
        for j, right_value in enumerate(right):
            answer[i + j] += left_value * right_value
    return tuple(answer)


def all_subsets(edges: int) -> Profile:
    return tuple(math.comb(edges, size) for size in range(edges + 1))


def complement(profile: Profile) -> Profile:
    return tuple(total - success for total, success in zip(all_subsets(len(profile) - 1), profile))


def series(left: Profile, right: Profile) -> Profile:
    """A series network succeeds exactly when both factors succeed."""
    return convolve(left, right)


def parallel(left: Profile, right: Profile) -> Profile:
    """A parallel network fails exactly when both factors fail."""
    total = all_subsets(len(left) + len(right) - 2)
    joint_failure = convolve(complement(left), complement(right))
    return tuple(value - failure for value, failure in zip(total, joint_failure))


def lc_failures(profile: Profile) -> list[dict[str, int]]:
    return [
        {
            "index": index,
            "left": profile[index] ** 2,
            "right": profile[index - 1] * profile[index + 1],
        }
        for index in range(1, len(profile) - 1)
        if profile[index] ** 2 < profile[index - 1] * profile[index + 1]
    ]


def equality_indices(profile: Profile) -> list[int]:
    return [
        index
        for index in range(1, len(profile) - 1)
        if profile[index] and profile[index] ** 2 == profile[index - 1] * profile[index + 1]
    ]


def enumerate_profiles(edge_budget: int) -> tuple[list[dict[Profile, Witness]], list[dict[str, object]]]:
    profiles: list[dict[Profile, Witness]] = [dict() for _ in range(edge_budget + 1)]
    profiles[1][(0, 1)] = Witness("e", "edge")
    closure_failures: list[dict[str, object]] = []

    for edges in range(2, edge_budget + 1):
        current = profiles[edges]
        for left_edges in range(1, edges // 2 + 1):
            right_edges = edges - left_edges
            for left, right in product(profiles[left_edges], profiles[right_edges]):
                left_witness = profiles[left_edges][left]
                right_witness = profiles[right_edges][right]
                for symbol, operation in (("S", series), ("P", parallel)):
                    result = operation(left, right)
                    failures = lc_failures(result)
                    if failures:
                        closure_failures.append(
                            {
                                "edges": edges,
                                "operation": symbol,
                                "left": left,
                                "right": right,
                                "result": result,
                                "failures": failures,
                                "expression": f"{symbol}({left_witness.expression},{right_witness.expression})",
                            }
                        )
                    candidate = Witness(
                        f"{symbol}({left_witness.expression},{right_witness.expression})",
                        symbol,
                        left,
                        right,
                    )
                    previous = current.get(result)
                    if previous is None or len(candidate.expression) < len(previous.expression):
                        current[result] = candidate
    return profiles, closure_failures


def direct_counterexample_profile() -> Profile:
    """Enumerate subsets of the explicit 14-edge multigraph independently."""
    # Terminals are 0 and 6.  Edges 0--1--6 form the short branch.  The other
    # branch is 0--2--3--4--6, with three parallel edges at every stage.
    edges = [(0, 1), (1, 6)] + [
        edge
        for endpoints in ((0, 2), (2, 3), (3, 4), (4, 6))
        for edge in (endpoints,) * 3
    ]
    profile = [0] * (len(edges) + 1)
    for mask in range(1 << len(edges)):
        reached = {0}
        changed = True
        while changed:
            changed = False
            for index, (left, right) in enumerate(edges):
                if not (mask >> index & 1):
                    continue
                if left in reached and right not in reached:
                    reached.add(right)
                    changed = True
                if right in reached and left not in reached:
                    reached.add(left)
                    changed = True
        if 6 in reached:
            profile[mask.bit_count()] += 1
    return tuple(profile)


def exact_counterexample() -> dict[str, object]:
    edge = (0, 1)
    short_path = series(edge, edge)
    triple = parallel(edge, parallel(edge, edge))
    long_branch = series(triple, series(triple, series(triple, triple)))
    profile = parallel(short_path, long_branch)
    direct = direct_counterexample_profile()
    assert profile == direct
    assert profile[:5] == (0, 0, 1, 12, 147)
    failures = lc_failures(profile)
    assert failures[0] == {"index": 3, "left": 144, "right": 147}
    return {
        "description": "parallel composition of a 2-edge path and four 3-parallel-edge bundles in series",
        "expression": "P(S(e,e),S(P(e,P(e,e)),S(P(e,P(e,e)),S(P(e,P(e,e)),P(e,P(e,e))))))",
        "profile": profile,
        "failures": failures,
        "direct_subset_check": direct == profile,
        "infinite_family": {
            "parameter": "q >= 3 parallel edges per bundle",
            "low_coefficients": ["a_2 = 1", "a_3 = 4q", "a_4 = binom(4q,2) + q^4"],
            "defect": "a_2*a_4 - a_3^2 = q*(q^3 - 8q - 2) > 0",
        },
    }


def main() -> None:
    profiles, closure_failures = enumerate_profiles(EDGE_BUDGET)
    summary = []
    for edges in range(1, EDGE_BUDGET + 1):
        edge_profiles = profiles[edges]
        profiles_with_equality = sum(bool(equality_indices(profile)) for profile in edge_profiles)
        summary.append(
            {
                "edges": edges,
                "distinct_profiles": len(edge_profiles),
                "profiles_with_internal_equality": profiles_with_equality,
            }
        )

    result = {
        "edge_budget": EDGE_BUDGET,
        "profile_counts": summary,
        "closure_failure_count": len(closure_failures),
        "first_closure_failure": closure_failures[0] if closure_failures else None,
        "exact_counterexample": exact_counterexample(),
    }
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
