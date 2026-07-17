#!/usr/bin/env python3
"""Deterministic separator-response checks for C241.

The exhaustive binary check uses a genuine two-dimensional separator.  The
ternary replay checks the same composition law over a second field.
"""

from __future__ import annotations

import argparse
from itertools import combinations, product
import json
from pathlib import Path


INF = 99


def add(u: tuple[int, ...], v: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple((a + b) % q for a, b in zip(u, v, strict=True))


def sub(u: tuple[int, ...], v: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple((a - b) % q for a, b in zip(u, v, strict=True))


def scalar(a: int, u: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple((a * x) % q for x in u)


def support_cost(columns: tuple[tuple[int, ...], ...], target: tuple[int, ...], q: int, radius: int) -> int:
    """Minimum number of listed columns spanning target, truncated at radius."""
    if not any(target):
        return 0
    if not columns:
        return INF
    for used in range(1, min(radius, len(columns)) + 1):
        for indices in combinations(range(len(columns)), used):
            for coefficients in product(range(1, q), repeat=used):
                total = (0,) * len(target)
                for coefficient, index in zip(coefficients, indices, strict=True):
                    total = add(total, scalar(coefficient, columns[index], q), q)
                if total == target:
                    return used
    return INF


def profile(columns: tuple[tuple[int, ...], ...], boundary: tuple[tuple[int, ...], ...], q: int, radius: int) -> tuple[int, ...]:
    return tuple(support_cost(columns, vector, q, radius) for vector in boundary)


def convolution(left: tuple[int, ...], right: tuple[int, ...], boundary: tuple[tuple[int, ...], ...], q: int, radius: int) -> tuple[int, ...]:
    index = {vector: i for i, vector in enumerate(boundary)}
    answer = []
    for target in boundary:
        cost = min(
            left[i] + right[index[sub(target, vector, q)]]
            for i, vector in enumerate(boundary)
        )
        answer.append(cost if cost <= radius else INF)
    return tuple(answer)


def saturate(
    columns: tuple[tuple[int, ...], ...],
    seed_mask: int,
    incoming: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> tuple[int, tuple[int, ...]]:
    """Terminal local Horn closure and its outgoing boundary-cost profile."""
    active = seed_mask
    while True:
        active_columns = tuple(column for i, column in enumerate(columns) if active >> i & 1)
        local_costs = {
            vector: support_cost(active_columns, vector, q, radius)
            for vector in set(boundary) | {
                sub(column, vector, q) for column in columns for vector in boundary
            }
        }
        additions = 0
        for i, column in enumerate(columns):
            if active >> i & 1:
                continue
            cost = min(
                local_costs[sub(column, vector, q)] + incoming[j]
                for j, vector in enumerate(boundary)
            )
            if cost <= radius:
                additions |= 1 << i
        if not additions:
            active_columns = tuple(column for i, column in enumerate(columns) if active >> i & 1)
            return active, profile(active_columns, boundary, q, radius)
        active |= additions


def compose(
    left: tuple[tuple[int, ...], ...],
    right: tuple[tuple[int, ...], ...],
    left_seed: int,
    right_seed: int,
    incoming: tuple[int, ...],
    boundary: tuple[tuple[int, ...], ...],
    q: int,
    radius: int,
) -> tuple[int, int, tuple[int, ...], int]:
    """Least-feedback composition of two terminal response maps."""
    bottom = tuple(0 if not any(vector) else INF for vector in boundary)
    left_output = bottom
    right_output = bottom
    iterations = 0
    while True:
        left_input = convolution(right_output, incoming, boundary, q, radius)
        right_input = convolution(left_output, incoming, boundary, q, radius)
        new_left_active, new_left_output = saturate(left, left_seed, left_input, boundary, q, radius)
        new_right_active, new_right_output = saturate(right, right_seed, right_input, boundary, q, radius)
        iterations += 1
        if (new_left_output, new_right_output) == (left_output, right_output):
            return (
                new_left_active,
                new_right_active,
                convolution(new_left_output, new_right_output, boundary, q, radius),
                iterations,
            )
        left_output, right_output = new_left_output, new_right_output


def vectors(q: int, dimension: int) -> tuple[tuple[int, ...], ...]:
    return tuple(product(range(q), repeat=dimension))


def instance(q: int) -> tuple[tuple[tuple[int, ...], ...], ...]:
    """Three disjoint triples whose pairwise spans meet in a 2-space."""
    dimension = 5
    e = [tuple(int(i == j) for i in range(dimension)) for j in range(dimension)]
    boundary = tuple((a, b, 0, 0, 0) for a, b in product(range(q), repeat=2))
    parts = []
    for private in e[2:]:
        parts.append((private, add(private, e[0], q), add(private, e[1], q)))
    return parts[0], parts[1], parts[2], boundary


def realizable_inputs(context: tuple[tuple[int, ...], ...], boundary: tuple[tuple[int, ...], ...], q: int, radius: int) -> set[tuple[int, ...]]:
    return {
        profile(tuple(column for i, column in enumerate(context) if mask >> i & 1), boundary, q, radius)
        for mask in range(1 << len(context))
    }


def run_field(q: int, exhaustive_profiles: bool) -> dict[str, object]:
    left, right, context, boundary = instance(q)
    radius = 2
    if exhaustive_profiles:
        # Normalize the zero-vector cost to zero; all other abstract inputs are allowed.
        inputs = {
            (0,) + tail
            for tail in product((0, 1, 2, INF), repeat=len(boundary) - 1)
        }
        scope = "all normalized truncated pointwise profiles"
    else:
        inputs = realizable_inputs(context, boundary, q, radius)
        # Add deterministic abstract profiles to exercise non-context-derived table entries.
        inputs |= {
            tuple(0 if i == 0 else ((i + shift) % 3 if i % 2 else INF) for i in range(len(boundary)))
            for shift in range(3)
        }
        scope = "all profiles realized by the third component, plus three abstract profiles"

    checks = 0
    max_iterations = 0
    for seed_mask in range(1 << (len(left) + len(right))):
        left_seed = seed_mask & ((1 << len(left)) - 1)
        right_seed = seed_mask >> len(left)
        for incoming in sorted(inputs):
            direct_active, direct_output = saturate(
                left + right, seed_mask, incoming, boundary, q, radius
            )
            left_active, right_active, output, iterations = compose(
                left, right, left_seed, right_seed, incoming, boundary, q, radius
            )
            combined_active = left_active | (right_active << len(left))
            assert combined_active == direct_active
            assert output == direct_output
            checks += 1
            max_iterations = max(max_iterations, iterations)

    # Full three-component contextual replay: all components may activate and feed back.
    contextual_checks = 0
    all_columns = left + right + context
    for seed_mask in range(1 << len(all_columns)):
        direct_active, _ = saturate(
            all_columns,
            seed_mask,
            tuple(0 if i == 0 else INF for i in range(len(boundary))),
            boundary,
            q,
            radius,
        )
        # The same least-feedback equations, grouped as (left union right) versus context.
        parent_seed = seed_mask & ((1 << 6) - 1)
        context_seed = seed_mask >> 6
        parent_active, context_active, _, _ = compose(
            left + right,
            context,
            parent_seed,
            context_seed,
            tuple(0 if i == 0 else INF for i in range(len(boundary))),
            boundary,
            q,
            radius,
        )
        grouped = parent_active | (context_active << 6)
        assert grouped == direct_active
        contextual_checks += 1

    return {
        "field": f"GF({q})",
        "radius": radius,
        "separator_dimension": 2,
        "separator_vector_count": len(boundary),
        "input_scope": scope,
        "input_profile_count": len(inputs),
        "two-child_response_checks": checks,
        "full_three-component_context_checks": contextual_checks,
        "maximum_feedback_iterations": max_iterations,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=Path(__file__).with_suffix(".json"))
    args = parser.parse_args()
    result = {
        "task": "C241",
        "binary_exhaustive": run_field(2, True),
        "ternary_replay": run_field(3, False),
        "conclusion": "truncated separator-vector terminal response maps compose exactly beyond one-element gluing",
    }
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
