#!/usr/bin/env python3
"""C246: realizable separator profiles and contextual minimality checks."""

from __future__ import annotations

import argparse
from itertools import combinations, product
import json
from pathlib import Path


INF = 99


def add(left: tuple[int, ...], right: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple((a + b) % q for a, b in zip(left, right, strict=True))


def sub(left: tuple[int, ...], right: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple((a - b) % q for a, b in zip(left, right, strict=True))


def scalar(coefficient: int, vector: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple(coefficient * value % q for value in vector)


def vectors(q: int, dimension: int) -> tuple[tuple[int, ...], ...]:
    return tuple(product(range(q), repeat=dimension))


def projective_representatives(
    boundary: tuple[tuple[int, ...], ...], q: int
) -> tuple[tuple[int, ...], ...]:
    answer = []
    for vector in boundary:
        if not any(vector):
            continue
        first = next(value for value in vector if value)
        normalized = scalar(pow(first, -1, q), vector, q)
        if normalized == vector:
            answer.append(vector)
    return tuple(answer)


def support_cost(
    columns: tuple[tuple[int, ...], ...], target: tuple[int, ...], q: int, radius: int
) -> int:
    if not any(target):
        return 0
    for used in range(1, min(radius, len(columns)) + 1):
        for indices in combinations(range(len(columns)), used):
            for coefficients in product(range(1, q), repeat=used):
                total = (0,) * len(target)
                for coefficient, index in zip(coefficients, indices, strict=True):
                    total = add(total, scalar(coefficient, columns[index], q), q)
                if total == target:
                    return used
    return INF


def profile(
    columns: tuple[tuple[int, ...], ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> tuple[int, ...]:
    return tuple(support_cost(columns, vector, q, radius) for vector in boundary)


def convolution(
    left: tuple[int, ...],
    right: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> tuple[int, ...]:
    index = {vector: position for position, vector in enumerate(boundary)}
    answer = []
    for target in boundary:
        cost = min(
            left[position] + right[index[sub(target, vector, q)]]
            for position, vector in enumerate(boundary)
        )
        answer.append(cost if cost <= radius else INF)
    return tuple(answer)


def is_admissible(
    candidate: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> bool:
    index = {vector: position for position, vector in enumerate(boundary)}
    if candidate[0] != 0:
        return False
    if any(value == 0 for value in candidate[1:]):
        return False
    for vector in boundary[1:]:
        for coefficient in range(1, q):
            if candidate[index[scalar(coefficient, vector, q)]] != candidate[index[vector]]:
                return False
    for left in boundary:
        for right in boundary:
            left_cost = candidate[index[left]]
            right_cost = candidate[index[right]]
            if left_cost == INF or right_cost == INF or left_cost + right_cost > radius:
                continue
            if candidate[index[add(left, right, q)]] > left_cost + right_cost:
                return False
    return True


def canonical_realizer(
    candidate: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
) -> tuple[tuple[int, ...], ...]:
    """Direct-sum circuit gadgets realizing an admissible profile."""
    index = {vector: position for position, vector in enumerate(boundary)}
    representatives = projective_representatives(boundary, q)
    private_dimension = sum(
        candidate[index[vector]] - 1
        for vector in representatives
        if candidate[index[vector]] != INF
    )
    total_dimension = len(boundary[0]) + private_dimension
    columns: list[tuple[int, ...]] = []
    offset = len(boundary[0])
    for vector in representatives:
        cost = candidate[index[vector]]
        if cost == INF:
            continue
        if cost == 1:
            columns.append(vector + (0,) * private_dimension)
            continue
        private_indices = tuple(range(offset, offset + cost - 1))
        for private_index in private_indices:
            column = [0] * total_dimension
            column[private_index] = 1
            columns.append(tuple(column))
        last = list(vector + (0,) * private_dimension)
        for private_index in private_indices:
            last[private_index] = -1 % q
        columns.append(tuple(last))
        offset += cost - 1
    assert offset == total_dimension
    return tuple(columns)


def expanded_boundary(
    boundary: tuple[tuple[int, ...], ...], total_dimension: int
) -> tuple[tuple[int, ...], ...]:
    return tuple(vector + (0,) * (total_dimension - len(vector)) for vector in boundary)


def admissible_profiles(q: int, dimension: int, radius: int) -> tuple[tuple[int, ...], ...]:
    boundary = vectors(q, dimension)
    representatives = projective_representatives(boundary, q)
    index = {vector: position for position, vector in enumerate(boundary)}
    answer = []
    for values in product((*range(1, radius + 1), INF), repeat=len(representatives)):
        candidate = [0] + [INF] * (len(boundary) - 1)
        for representative, value in zip(representatives, values, strict=True):
            for coefficient in range(1, q):
                candidate[index[scalar(coefficient, representative, q)]] = value
        result = tuple(candidate)
        if is_admissible(result, boundary, q, radius):
            answer.append(result)
    return tuple(answer)


def realizability_sweep(q: int, dimension: int, radius: int) -> dict[str, object]:
    boundary = vectors(q, dimension)
    candidates = admissible_profiles(q, dimension, radius)
    max_columns = 0
    observer_checks = 0
    for candidate in candidates:
        columns = canonical_realizer(candidate, boundary, q)
        lifted_boundary = expanded_boundary(boundary, len(columns[0]) if columns else dimension)
        assert profile(columns, lifted_boundary, q, radius) == candidate
        max_columns = max(max_columns, len(columns))

        # A fresh-coordinate padding observer turns any finite cost c into the threshold r.
        for vector, cost in zip(boundary[1:], candidate[1:], strict=True):
            if cost == INF:
                continue
            padding = radius - cost
            old_dimension = len(lifted_boundary[0])
            padded_columns = tuple(column + (0,) * padding for column in columns)
            padding_columns = tuple(
                (0,) * old_dimension
                + tuple(int(position == index) for position in range(padding))
                for index in range(padding)
            )
            target = vector + (0,) * (old_dimension - dimension) + (1,) * padding
            assert support_cost(padded_columns + padding_columns, target, q, radius) == radius
            observer_checks += 1

    distinguishing_pairs = 0
    for left in candidates:
        for right in candidates:
            if left == right:
                continue
            if any(a < b for a, b in zip(left, right, strict=True)):
                distinguishing_pairs += 1
    return {
        "field": f"GF({q})",
        "separator_dimension": dimension,
        "radius": radius,
        "projective_boundary_points": len(projective_representatives(boundary, q)),
        "scalar_invariant_positive_candidates": (radius + 1) ** len(projective_representatives(boundary, q)),
        "admissible_and_realized_profiles": len(candidates),
        "maximum_columns_in_canonical_realizer": max_columns,
        "fresh_padding_observer_checks": observer_checks,
        "ordered_unequal_profile_pairs_with_a_strict_coordinate": distinguishing_pairs,
    }


def saturate(
    columns: tuple[tuple[int, ...], ...],
    seed_mask: int,
    incoming: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> tuple[int, tuple[int, ...]]:
    active = seed_mask
    lifted_boundary = expanded_boundary(boundary, len(columns[0]) if columns else len(boundary[0]))
    while True:
        active_columns = tuple(column for index, column in enumerate(columns) if active >> index & 1)
        additions = 0
        for index, column in enumerate(columns):
            if active >> index & 1:
                continue
            cost = min(
                support_cost(active_columns, sub(column, vector, q), q, radius) + incoming[position]
                for position, vector in enumerate(lifted_boundary)
            )
            if cost <= radius:
                additions |= 1 << index
        if not additions:
            return active, profile(active_columns, lifted_boundary, q, radius)
        active |= additions


def raw_response_nonminimality(q: int, radius: int) -> dict[str, object]:
    boundary = vectors(q, 1)
    boundary_vector = (1,)
    private = radius - 1
    dimension = 1 + private
    padding = tuple(
        (0,) + tuple(int(position == index) for position in range(private))
        for index in range(private)
    )
    target = boundary_vector + (1,) * private
    left = padding + (target,)
    right = padding
    left_seed = (1 << private) - 1
    right_seed = (1 << private) - 1
    raw_differences = 0
    effective_agreements = 0
    for cost in (*range(1, radius + 1), INF):
        incoming = (0,) + (cost,) * (q - 1)
        left_active, left_raw = saturate(left, left_seed, incoming, boundary, q, radius)
        right_active, right_raw = saturate(right, right_seed, incoming, boundary, q, radius)
        left_effective = convolution(incoming, left_raw, boundary, q, radius)
        right_effective = convolution(incoming, right_raw, boundary, q, radius)
        assert left_effective == right_effective
        effective_agreements += 1
        if left_raw != right_raw:
            assert cost == 1
            assert left_active != right_active
            raw_differences += 1
    assert raw_differences == 1
    return {
        "field": f"GF({q})",
        "separator_dimension": 1,
        "radius": radius,
        "realizable_inputs_checked": radius + 1,
        "raw_response_differences": raw_differences,
        "effective_response_agreements": effective_agreements,
        "left_extra_activation_at_masked_input": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=Path(__file__).with_suffix(".json"))
    args = parser.parse_args()
    result = {
        "task": "C246",
        "realizability": [
            realizability_sweep(q, 2, radius)
            for q in (2, 3)
            for radius in (1, 2, 3)
        ],
        "raw_response_nonminimality": [
            raw_response_nonminimality(q, radius)
            for q in (2, 3)
            for radius in (1, 2, 3)
        ],
        "conclusion": (
            "realizable profiles are exactly positive projectively invariant truncated subadditive "
            "profiles; the fully abstract structural map is incoming convolved with local response"
        ),
    }
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
