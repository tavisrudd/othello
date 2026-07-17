#!/usr/bin/env python3
"""Finite checks for C230's Horn-depth composition and minor boundary."""

from __future__ import annotations

import argparse
import itertools
import json
from collections.abc import Iterable
from pathlib import Path


RADIUS = 2


def subsets(items: tuple[int, ...]) -> Iterable[frozenset[int]]:
    for size in range(len(items) + 1):
        yield from map(frozenset, itertools.combinations(items, size))


def binary_rank(columns: tuple[int, ...], indices: frozenset[int]) -> int:
    basis: list[int] = []
    for index in indices:
        value = columns[index]
        for pivot in basis:
            value = min(value, value ^ pivot)
        if value:
            basis.append(value)
            basis.sort(reverse=True)
    return len(basis)


def circuits(columns: tuple[int, ...]) -> tuple[frozenset[int], ...]:
    ground = tuple(range(len(columns)))
    result = []
    for candidate in subsets(ground):
        if not candidate or binary_rank(columns, candidate) == len(candidate):
            continue
        if all(
            binary_rank(columns, candidate - {element}) == len(candidate) - 1
            for element in candidate
        ):
            result.append(candidate)
    return tuple(result)


def rounds(
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> tuple[tuple[frozenset[int], ...], dict[int, int]]:
    active = set(seed)
    layers = [seed]
    arrival = {element: 0 for element in seed}
    while True:
        new = set()
        for circuit in circuit_family:
            if len(circuit) <= radius + 1 and len(circuit - active) == 1:
                new.update(circuit - active)
        if not new:
            return tuple(layers), arrival
        time = len(layers)
        for element in new:
            arrival[element] = time
        active.update(new)
        layers.append(frozenset(active))


def closure(
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> frozenset[int]:
    return rounds(seed, circuit_family, radius)[0][-1]


def residual_closure(
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
    live_element: int,
) -> frozenset[int]:
    """Close after fixing live_element true and removing it from every body."""
    active = set(seed)
    while True:
        new = set()
        for circuit in circuit_family:
            if len(circuit) > radius + 1:
                continue
            missing = (circuit - {live_element}) - active
            if len(missing) == 1:
                new.update(missing)
        if not new:
            return frozenset(active)
        active.update(new)


def bellman_arrival(
    seed: frozenset[int],
    ground: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> dict[int, int | None]:
    """Solve the causal min-max equations by increasing arrival time."""
    result: dict[int, int | None] = {element: None for element in ground}
    for element in seed:
        result[element] = 0
    while True:
        changed = False
        for target in ground - seed:
            candidates = []
            for circuit in circuit_family:
                if target not in circuit or len(circuit) > radius + 1:
                    continue
                helper_times = [result[element] for element in circuit - {target}]
                if all(time is not None for time in helper_times):
                    candidates.append(1 + max(helper_times, default=0))
            value = min(candidates, default=None)
            if value is not None and (result[target] is None or value < result[target]):
                result[target] = value
                changed = True
        if not changed:
            return result


def direct_sum_circuits(
    left: tuple[frozenset[int], ...],
    left_size: int,
    right: tuple[frozenset[int], ...],
) -> tuple[frozenset[int], ...]:
    shifted = tuple(frozenset(element + left_size for element in circuit) for circuit in right)
    return left + shifted


def cumulative_profile(
    size: int,
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
    depth_bound: int,
) -> dict[tuple[int, int], int]:
    ground = frozenset(range(size))
    profile: dict[tuple[int, int], int] = {}
    for seed in subsets(tuple(range(size))):
        layers, _ = rounds(seed, circuit_family, radius)
        depth = len(layers) - 1
        core_size = len(ground - layers[-1])
        if depth <= depth_bound:
            key = (len(seed), core_size)
            profile[key] = profile.get(key, 0) + 1
    return profile


def multiply_profiles(
    left: dict[tuple[int, int], int], right: dict[tuple[int, int], int]
) -> dict[tuple[int, int], int]:
    result: dict[tuple[int, int], int] = {}
    for (left_seed, left_core), left_count in left.items():
        for (right_seed, right_core), right_count in right.items():
            key = (left_seed + right_seed, left_core + right_core)
            result[key] = result.get(key, 0) + left_count * right_count
    return result


def check_small_binary_restrictions() -> int:
    cases = 0
    nonzero_vectors = tuple(range(1, 8))
    for column_set in subsets(nonzero_vectors):
        if not column_set:
            continue
        columns = tuple(sorted(column_set))
        ground = frozenset(range(len(columns)))
        circuit_family = circuits(columns)
        for distinguished in ground:
            remainder = ground - {distinguished}
            deletion_circuits = tuple(
                circuit for circuit in circuit_family if distinguished not in circuit
            )
            for seed in subsets(tuple(sorted(remainder))):
                layers, arrival = rounds(seed, circuit_family, RADIUS)
                terminal = layers[-1]
                bellman = bellman_arrival(seed, ground, circuit_family, RADIUS)
                assert {
                    element: bellman[element]
                    for element in ground
                    if bellman[element] is not None
                } == arrival
                assert {element for element in ground if bellman[element] is None} == (
                    ground - terminal
                )

                deleted = closure(seed, deletion_circuits, RADIUS)
                distinguished_enabled = any(
                    distinguished in circuit
                    and len(circuit) <= RADIUS + 1
                    and circuit - {distinguished} <= deleted
                    for circuit in circuit_family
                )
                predicted = deleted
                if distinguished_enabled:
                    predicted = residual_closure(
                        deleted, circuit_family, RADIUS, distinguished
                    ) | {distinguished}
                assert terminal == predicted

                initially_live = closure(
                    seed | {distinguished}, circuit_family, RADIUS
                ) - {distinguished}
                assert initially_live == residual_closure(
                    seed, circuit_family, RADIUS, distinguished
                )
                cases += 1
    return cases


def check_direct_sum_profiles() -> int:
    catalog = (
        (1, 2, 3),
        (1, 2, 4, 3),
        (1, 2, 4, 3, 7),
    )
    checks = 0
    for left_columns, right_columns in itertools.product(catalog, repeat=2):
        left_circuits = circuits(left_columns)
        right_circuits = circuits(right_columns)
        total_circuits = direct_sum_circuits(
            left_circuits, len(left_columns), right_circuits
        )
        for depth_bound in range(len(left_columns) + len(right_columns) + 1):
            direct = cumulative_profile(
                len(left_columns) + len(right_columns),
                total_circuits,
                RADIUS,
                depth_bound,
            )
            product = multiply_profiles(
                cumulative_profile(
                    len(left_columns), left_circuits, RADIUS, depth_bound
                ),
                cumulative_profile(
                    len(right_columns), right_circuits, RADIUS, depth_bound
                ),
            )
            assert direct == product
            checks += 1
    return checks


def check_minor_witnesses() -> dict[str, object]:
    deletion_names = ("a", "b", "c", "x", "y")
    deletion_columns = (1, 2, 4, 3, 7)
    deletion_circuits = circuits(deletion_columns)
    deletion_seed = frozenset((0, 1, 2))
    deleted_element = 3
    full = closure(deletion_seed, deletion_circuits, RADIUS)
    deleted = closure(
        deletion_seed,
        tuple(circuit for circuit in deletion_circuits if deleted_element not in circuit),
        RADIUS,
    )
    assert full == frozenset(range(5))
    assert deleted == deletion_seed

    contraction_names = ("a", "b", "c", "w")
    contraction_columns = (1, 2, 4, 7)
    contraction_circuits = circuits(contraction_columns)
    contraction_seed = frozenset((1, 2))
    contracted_element = 0
    live = closure(
        contraction_seed | {contracted_element}, contraction_circuits, RADIUS
    ) - {contracted_element}
    # U(3,4)/a is U(2,3), whose sole circuit is {b,c,w}.
    contracted_circuits = (frozenset((1, 2, 3)),)
    contracted = closure(contraction_seed, contracted_circuits, RADIUS)
    assert live == contraction_seed
    assert contracted == frozenset((1, 2, 3))

    return {
        "deletion": {
            "field": "GF(2)",
            "columns": dict(zip(deletion_names, deletion_columns)),
            "radius": RADIUS,
            "seed": [deletion_names[index] for index in sorted(deletion_seed)],
            "distinguished": deletion_names[deleted_element],
            "original_closure": [deletion_names[index] for index in sorted(full)],
            "deletion_closure": [deletion_names[index] for index in sorted(deleted)],
        },
        "contraction": {
            "field": "GF(2)",
            "columns": dict(zip(contraction_names, contraction_columns)),
            "radius": RADIUS,
            "seed": [contraction_names[index] for index in sorted(contraction_seed)],
            "initially_live": contraction_names[contracted_element],
            "original_closure_without_live": [
                contraction_names[index] for index in sorted(live)
            ],
            "same_radius_contraction_closure": [
                contraction_names[index] for index in sorted(contracted)
            ],
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output", type=Path, default=Path(__file__).with_suffix(".json")
    )
    args = parser.parse_args()

    seed_element_cases = check_small_binary_restrictions()
    profile_checks = check_direct_sum_profiles()
    certificate = {
        "task": "C230",
        "radius": RADIUS,
        "theorems_checked": {
            "arrival_times_satisfy_causal_min_max_equations": True,
            "stopping_core_is_infinite_arrival_set": True,
            "element_conditioning_residual_law": True,
            "direct_sum_cumulative_profile_factorization": True,
        },
        "exhaustive_scout": {
            "simple_binary_rank_at_most_3_restrictions": 127,
            "element_seed_cases": seed_element_cases,
            "direct_sum_profile_identities": profile_checks,
        },
        "naive_minor_counterexamples": check_minor_witnesses(),
        "literature_cache": {
            "arXiv:1610.09767": "6aacd2b590e73c571961d6dd921fae9ad7c2378088cabae1171bbd50668b5a50",
            "arXiv:2301.06642": "a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5",
        },
    }
    args.output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
