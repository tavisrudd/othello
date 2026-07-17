#!/usr/bin/env python3
"""C245: exhaustive ordinary-LC sweeps for pointed represented matroids.

The simple sweeps fix the target by projective transitivity and inspect every
restriction containing it.  The multiplicity sweep also admits loops and
parallel elements, represented by a weak composition of the helper multiset.
"""

from __future__ import annotations

from itertools import product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-17-c245-pointed-profile-log-concavity.json"


def projective_points(prime: int, rank: int) -> tuple[tuple[int, ...], ...]:
    """Canonical nonzero vectors modulo scalar multiplication over GF(prime)."""
    points = []
    for vector in product(range(prime), repeat=rank):
        if not any(vector):
            continue
        first = next(value for value in vector if value)
        inverse = pow(first, -1, prime)
        normalized = tuple(value * inverse % prime for value in vector)
        if normalized == vector:
            points.append(vector)
    return tuple(points)


def vector_rank(vectors: tuple[tuple[int, ...], ...], prime: int) -> int:
    if not vectors:
        return 0
    rows = [list(vector) for vector in vectors]
    width = len(rows[0])
    pivot_row = 0
    for column in range(width):
        pivot = next((index for index in range(pivot_row, len(rows)) if rows[index][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        inverse = pow(rows[pivot_row][column], -1, prime)
        rows[pivot_row] = [value * inverse % prime for value in rows[pivot_row]]
        for index in range(len(rows)):
            if index == pivot_row or not rows[index][column]:
                continue
            factor = rows[index][column]
            rows[index] = [
                (value - factor * pivot_value) % prime
                for value, pivot_value in zip(rows[index], rows[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def rank_table(columns: tuple[tuple[int, ...], ...], prime: int) -> list[int]:
    answer = [0] * (1 << len(columns))
    for mask in range(1 << len(columns)):
        selected = tuple(columns[index] for index in range(len(columns)) if mask >> index & 1)
        answer[mask] = vector_rank(selected, prime)
    return answer


def lc_failure(profile: list[int]) -> dict[str, int] | None:
    for index in range(1, len(profile) - 1):
        if profile[index] ** 2 < profile[index - 1] * profile[index + 1]:
            return {
                "index": index,
                "left": profile[index] ** 2,
                "right": profile[index - 1] * profile[index + 1],
            }
    return None


def exhaustive_simple(prime: int, ambient_rank: int) -> dict[str, object]:
    points = projective_points(prime, ambient_rank)
    target = points[0]
    helpers = tuple(point for point in points if point != target)
    ranks = rank_table(helpers, prime)
    ranks_with_target = [
        vector_rank(
            tuple(helpers[index] for index in range(len(helpers)) if mask >> index & 1)
            + (target,),
            prime,
        )
        for mask in range(1 << len(helpers))
    ]

    # degree_zeta[k][H] counts successful k-subsets of H.
    degree_zeta = [[0] * (1 << len(helpers)) for _ in range(len(helpers) + 1)]
    for mask, (rank, target_rank) in enumerate(zip(ranks, ranks_with_target)):
        if rank == target_rank:
            degree_zeta[mask.bit_count()][mask] = 1
    for index in range(len(helpers)):
        bit = 1 << index
        for mask in range(1 << len(helpers)):
            if mask & bit:
                previous = mask ^ bit
                for degree in range(len(helpers) + 1):
                    degree_zeta[degree][mask] += degree_zeta[degree][previous]

    pointed_noncoloops = 0
    size_counts = [0] * (len(helpers) + 2)
    counterexample = None
    for helper_mask in range(1 << len(helpers)):
        if ranks[helper_mask] != ranks_with_target[helper_mask]:
            continue
        pointed_noncoloops += 1
        size_counts[helper_mask.bit_count() + 1] += 1
        profile = [degree_zeta[degree][helper_mask] for degree in range(len(helpers) + 1)]
        failure = lc_failure(profile)
        if failure is not None:
            counterexample = {
                "helper_mask": helper_mask,
                "profile": profile,
                "failure": failure,
            }
            break

    assert counterexample is None
    return {
        "field": f"GF({prime})",
        "ambient_rank": ambient_rank,
        "projective_points": len(points),
        "fixed_target": target,
        "all_helper_restrictions": 1 << len(helpers),
        "pointed_noncoloop_cases": pointed_noncoloops,
        "ground_size_distribution": size_counts,
        "lc_counterexample": counterexample,
    }


def weak_compositions(total: int, parts: int):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in weak_compositions(total - first, parts - 1):
            yield (first, *rest)


def exhaustive_binary_multisets(rank: int, max_helpers: int) -> dict[str, object]:
    """All pointed GF(2) vector multisets in fixed coordinates up to max_helpers."""
    zero = (0,) * rank
    points = projective_points(2, rank)
    types = (zero, *points)
    target = points[0]
    configurations = 0
    pointed_noncoloops = 0
    size_counts = [0] * (max_helpers + 2)
    counterexample = None
    for helper_count in range(max_helpers + 1):
        for multiplicities in weak_compositions(helper_count, len(types)):
            configurations += 1
            helpers = tuple(
                vector for vector, count in zip(types, multiplicities) for _ in range(count)
            )
            ranks = rank_table(helpers, 2)
            full = (1 << len(helpers)) - 1
            if ranks[full] != vector_rank(helpers + (target,), 2):
                continue
            pointed_noncoloops += 1
            size_counts[helper_count + 1] += 1
            profile = [0] * (helper_count + 1)
            for mask, rank in enumerate(ranks):
                selected = tuple(
                    helpers[index] for index in range(len(helpers)) if mask >> index & 1
                )
                if rank == vector_rank(selected + (target,), 2):
                    profile[mask.bit_count()] += 1
            failure = lc_failure(profile)
            if failure is not None:
                counterexample = {
                    "multiplicities_for_zero_then_projective_types": multiplicities,
                    "profile": profile,
                    "failure": failure,
                }
                break
        if counterexample is not None:
            break

    assert counterexample is None
    return {
        "field": "GF(2)",
        "coordinate_rank": rank,
        "helper_types_including_zero": len(types),
        "max_helpers": max_helpers,
        "multiset_configurations": configurations,
        "pointed_noncoloop_cases": pointed_noncoloops,
        "ground_size_distribution": size_counts,
        "lc_counterexample": counterexample,
    }


def main() -> None:
    result = {
        "simple_binary_rank_at_most_four": exhaustive_simple(2, 4),
        "simple_ternary_rank_at_most_three": exhaustive_simple(3, 3),
        "binary_with_loops_and_parallels_rank_at_most_three": exhaustive_binary_multisets(3, 8),
    }
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
