#!/usr/bin/env python3
"""Finite checks for C231's exact 2-sum repair-interface convolution."""

from __future__ import annotations

import argparse
import itertools
import json
from collections.abc import Iterable
from pathlib import Path


RADII = tuple(range(1, 6))
INFINITY = 10**9


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


def glue_binary_representations(
    left: tuple[int, ...], right: tuple[int, ...]
) -> tuple[int, ...]:
    """Represent the 2-sum after identifying and deleting p=bit 0.

    Both components live in GF(2)^3 with p represented by 1. The private
    coordinates of the right component move from bits 1,2 to bits 3,4.
    """
    shifted_right = tuple((value & 1) | ((value >> 1) << 3) for value in right[1:])
    return left[1:] + shifted_right


def two_sum_circuits(
    left_circuits: tuple[frozenset[int], ...],
    left_size: int,
    right_circuits: tuple[frozenset[int], ...],
) -> tuple[frozenset[int], ...]:
    result: set[frozenset[int]] = set()
    for circuit in left_circuits:
        if 0 not in circuit:
            result.add(frozenset(element - 1 for element in circuit))
    for circuit in right_circuits:
        if 0 not in circuit:
            result.add(
                frozenset(left_size - 1 + element - 1 for element in circuit)
            )
    for left_circuit in left_circuits:
        if 0 not in left_circuit:
            continue
        left_part = frozenset(element - 1 for element in left_circuit - {0})
        for right_circuit in right_circuits:
            if 0 not in right_circuit:
                continue
            right_part = frozenset(
                left_size - 1 + element - 1 for element in right_circuit - {0}
            )
            result.add(left_part | right_part)
    return tuple(sorted(result, key=lambda value: (len(value), tuple(sorted(value)))))


def parallel_step(
    active: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> frozenset[int]:
    result = set(active)
    for circuit in circuit_family:
        if len(circuit) <= radius + 1 and len(circuit - active) == 1:
            result.update(circuit - active)
    return frozenset(result)


def rounds(
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> tuple[tuple[frozenset[int], ...], dict[int, int]]:
    active = seed
    layers = [active]
    arrival = {element: 0 for element in seed}
    while True:
        enlarged = parallel_step(active, circuit_family, radius)
        if enlarged == active:
            return tuple(layers), arrival
        for element in enlarged - active:
            arrival[element] = len(layers)
        active = enlarged
        layers.append(active)


def split_active(
    active: frozenset[int], left_size: int
) -> tuple[frozenset[int], frozenset[int]]:
    left = frozenset(element + 1 for element in active if element < left_size - 1)
    right = frozenset(
        element - (left_size - 1) + 1
        for element in active
        if element >= left_size - 1
    )
    return left, right


def internal_cost(
    target: int,
    active: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
) -> int:
    return min(
        (
            len(circuit) - 1
            for circuit in circuit_family
            if 0 not in circuit and target in circuit and circuit - {target} <= active
        ),
        default=INFINITY,
    )


def assisted_cost(
    target: int,
    active: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
) -> int:
    return min(
        (
            len(circuit) - 2
            for circuit in circuit_family
            if 0 in circuit
            and target in circuit
            and circuit - {0, target} <= active
        ),
        default=INFINITY,
    )


def interface_cost(
    active: frozenset[int], circuit_family: tuple[frozenset[int], ...]
) -> int:
    return min(
        (
            len(circuit) - 1
            for circuit in circuit_family
            if 0 in circuit and circuit - {0} <= active
        ),
        default=INFINITY,
    )


def coupled_step(
    active: frozenset[int],
    left_circuits: tuple[frozenset[int], ...],
    left_size: int,
    right_circuits: tuple[frozenset[int], ...],
    right_size: int,
    radius: int,
) -> frozenset[int]:
    left_active, right_active = split_active(active, left_size)
    additions: set[int] = set()
    for local_circuits, local_active, local_size, offset, remote_circuits, remote_active in (
        (
            left_circuits,
            left_active,
            left_size,
            -1,
            right_circuits,
            right_active,
        ),
        (
            right_circuits,
            right_active,
            right_size,
            left_size - 2,
            left_circuits,
            left_active,
        ),
    ):
        remote_message = interface_cost(remote_active, remote_circuits)
        for target in frozenset(range(1, local_size)) - local_active:
            if internal_cost(target, local_active, local_circuits) <= radius:
                additions.add(target + offset)
                continue
            if (
                assisted_cost(target, local_active, local_circuits) + remote_message
                <= radius
            ):
                additions.add(target + offset)
    return active | additions


def local_to_global(element: int, side: int, left_size: int) -> int:
    if side == 0:
        return element - 1
    return left_size - 1 + element - 1


def readiness(
    elements: frozenset[int],
    side: int,
    left_size: int,
    arrival: dict[int, int],
) -> int:
    values = [
        arrival.get(local_to_global(element, side, left_size), INFINITY)
        for element in elements
    ]
    return max(values, default=0)


def compressed_arrival_rhs(
    target: int,
    side: int,
    left_circuits: tuple[frozenset[int], ...],
    left_size: int,
    right_circuits: tuple[frozenset[int], ...],
    radius: int,
    arrival: dict[int, int],
) -> int:
    local_circuits, remote_circuits = (
        (left_circuits, right_circuits)
        if side == 0
        else (right_circuits, left_circuits)
    )
    internal = min(
        (
            readiness(circuit - {target}, side, left_size, arrival)
            for circuit in local_circuits
            if 0 not in circuit
            and target in circuit
            and len(circuit) - 1 <= radius
        ),
        default=INFINITY,
    )

    assisted_by_budget: dict[int, int] = {}
    for circuit in local_circuits:
        if 0 not in circuit or target not in circuit:
            continue
        budget = len(circuit) - 2
        value = readiness(circuit - {0, target}, side, left_size, arrival)
        assisted_by_budget[budget] = min(
            assisted_by_budget.get(budget, INFINITY), value
        )

    remote_side = 1 - side
    interface_by_budget: dict[int, int] = {}
    for circuit in remote_circuits:
        if 0 not in circuit:
            continue
        budget = len(circuit) - 1
        value = readiness(circuit - {0}, remote_side, left_size, arrival)
        interface_by_budget[budget] = min(
            interface_by_budget.get(budget, INFINITY), value
        )

    cross = min(
        (
            max(local_time, remote_time)
            for local_budget, local_time in assisted_by_budget.items()
            for remote_budget, remote_time in interface_by_budget.items()
            if local_budget + remote_budget <= radius
        ),
        default=INFINITY,
    )
    best = min(internal, cross)
    return INFINITY if best == INFINITY else best + 1


def component_catalog() -> tuple[tuple[tuple[int, ...], tuple[frozenset[int], ...]], ...]:
    result = []
    for other_count in (2, 3):
        for rest in itertools.combinations(range(2, 8), other_count):
            columns = (1,) + rest
            circuit_family = circuits(columns)
            if any(0 in circuit for circuit in circuit_family):
                result.append((columns, circuit_family))
    return tuple(result)


def internal_circuits(
    left_circuits: tuple[frozenset[int], ...],
    left_size: int,
    right_circuits: tuple[frozenset[int], ...],
) -> frozenset[frozenset[int]]:
    result = {
        frozenset(element - 1 for element in circuit)
        for circuit in left_circuits
        if 0 not in circuit
    }
    result.update(
        frozenset(left_size - 1 + element - 1 for element in circuit)
        for circuit in right_circuits
        if 0 not in circuit
    )
    return frozenset(result)


def check_catalog() -> dict[str, object]:
    catalog = component_catalog()
    pair_count = 0
    seed_radius_states = 0
    arrival_equations = 0
    cross_additions = {radius: 0 for radius in RADII}

    for left_columns, left_circuits in catalog:
        for right_columns, right_circuits in catalog:
            represented_columns = glue_binary_representations(left_columns, right_columns)
            direct_circuits = circuits(represented_columns)
            composed_circuits = two_sum_circuits(
                left_circuits, len(left_columns), right_circuits
            )
            assert set(direct_circuits) == set(composed_circuits)
            internal = internal_circuits(
                left_circuits, len(left_columns), right_circuits
            )
            ground = tuple(range(len(represented_columns)))
            for seed in subsets(ground):
                for radius in RADII:
                    direct_step = parallel_step(seed, direct_circuits, radius)
                    predicted_step = coupled_step(
                        seed,
                        left_circuits,
                        len(left_columns),
                        right_circuits,
                        len(right_columns),
                        radius,
                    )
                    assert direct_step == predicted_step

                    internal_step = parallel_step(seed, tuple(internal), radius)
                    cross_additions[radius] += len(predicted_step - internal_step)

                    direct_layers, arrival = rounds(seed, direct_circuits, radius)
                    coupled = seed
                    while True:
                        enlarged = coupled_step(
                            coupled,
                            left_circuits,
                            len(left_columns),
                            right_circuits,
                            len(right_columns),
                            radius,
                        )
                        if enlarged == coupled:
                            break
                        coupled = enlarged
                    assert coupled == direct_layers[-1]

                    for global_target in ground:
                        if global_target in seed:
                            assert arrival[global_target] == 0
                            continue
                        if global_target < len(left_columns) - 1:
                            side = 0
                            local_target = global_target + 1
                        else:
                            side = 1
                            local_target = global_target - (len(left_columns) - 1) + 1
                        rhs = compressed_arrival_rhs(
                            local_target,
                            side,
                            left_circuits,
                            len(left_columns),
                            right_circuits,
                            radius,
                            arrival,
                        )
                        assert arrival.get(global_target, INFINITY) == rhs
                        arrival_equations += 1
                    seed_radius_states += 1
            pair_count += 1

    return {
        "component_representations": len(catalog),
        "represented_2_sum_pairs": pair_count,
        "seed_radius_states": seed_radius_states,
        "arrival_equations": arrival_equations,
        "one_step_cross_additions": {
            str(radius): count for radius, count in cross_additions.items()
        },
    }


def check_three_round_relay() -> dict[str, object]:
    names = ("p", "a", "b", "c", "d")
    columns = (1, 2, 3, 4, 6)
    component_circuits = circuits(columns)
    represented_columns = glue_binary_representations(columns, columns)
    direct_circuits = circuits(represented_columns)
    left_names = names[1:]
    right_names = ("u", "v", "w", "z")
    global_names = left_names + right_names
    seed_names = ("b", "c", "d", "v", "w")
    seed = frozenset(global_names.index(name) for name in seed_names)
    layers, arrival = rounds(seed, direct_circuits, radius=3)
    additions = [
        [global_names[index] for index in sorted(layers[k] - layers[k - 1])]
        for k in range(1, len(layers))
    ]
    assert additions == [["a"], ["u"], ["z"]]

    coupled = seed
    coupled_additions = []
    while True:
        enlarged = coupled_step(
            coupled,
            component_circuits,
            len(columns),
            component_circuits,
            len(columns),
            radius=3,
        )
        if enlarged == coupled:
            break
        coupled_additions.append(
            [global_names[index] for index in sorted(enlarged - coupled)]
        )
        coupled = enlarged
    assert coupled_additions == additions
    assert coupled == frozenset(range(len(global_names)))

    return {
        "field": "GF(2)",
        "radius": 3,
        "component_columns": dict(zip(names, columns)),
        "left_names": list(left_names),
        "right_names": list(right_names),
        "seed": list(seed_names),
        "parallel_addition_layers": additions,
        "arrival_times": {
            global_names[index]: time for index, time in sorted(arrival.items())
        },
        "cross_interface_round": 2,
        "terminal_closure": list(global_names),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output", type=Path, default=Path(__file__).with_suffix(".json")
    )
    args = parser.parse_args()

    certificate = {
        "task": "C231",
        "radii": list(RADII),
        "theorems_checked": {
            "standard_2_sum_circuit_composition": True,
            "scalar_budget_message_parallel_step": True,
            "coupled_terminal_closure": True,
            "budgeted_min_max_arrival_convolution": True,
        },
        "exhaustive_scout": check_catalog(),
        "strict_three_round_interface_relay": check_three_round_relay(),
        "literature_cache": {
            "arXiv:1610.09767": "6aacd2b590e73c571961d6dd921fae9ad7c2378088cabae1171bbd50668b5a50",
            "arXiv:2301.06642": "a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5",
        },
    }
    args.output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
