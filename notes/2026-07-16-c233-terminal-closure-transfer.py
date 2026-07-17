#!/usr/bin/env python3
"""Finite checks for C233's terminal-closure transfer algebra.

The verifier has three independent parts:

* enumerate a bounded catalog of binary two-interface components and compute
  their complete terminal boundary operators and integer count weights;
* compare weighted least-fixed-point composition against direct represented
  2-sums for every seed in a bounded one-interface catalog; and
* replay C232's triangle relays after erasing time, checking that all F_n for
  n >= 2 have one structural control while their active/core weights grow.
"""

from __future__ import annotations

import argparse
import itertools
import json
from collections.abc import Iterable
from pathlib import Path


RADII = (1, 2, 3)


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


def terminal_closure(
    boundary_width: int,
    private: frozenset[int],
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    incoming: tuple[int, ...],
    radius: int,
) -> frozenset[int]:
    active = seed
    while True:
        additions = set()
        for target in private - active:
            for circuit in circuit_family:
                if target not in circuit:
                    continue
                private_helpers = (circuit & private) - {target}
                if not private_helpers <= active:
                    continue
                cost = len(private_helpers) + sum(
                    incoming[p] for p in circuit if p < boundary_width
                )
                if cost <= radius:
                    additions.add(target)
                    break
        if not additions:
            return active
        active |= additions


def outgoing_response(
    port: int,
    boundary_width: int,
    private: frozenset[int],
    active: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    incoming: tuple[int, ...],
    radius: int,
) -> int:
    infinity = radius + 1
    best = infinity
    for circuit in circuit_family:
        if port not in circuit:
            continue
        private_helpers = circuit & private
        if not private_helpers <= active:
            continue
        cost = len(private_helpers) + sum(
            incoming[p]
            for p in circuit
            if p < boundary_width and p != port
        )
        best = min(best, cost)
    return min(best, infinity)


def terminal_tables(
    columns: tuple[int, ...],
    boundary_width: int,
    seed: frozenset[int],
    radius: int,
    circuit_family: tuple[frozenset[int], ...] | None = None,
) -> tuple[
    tuple[tuple[tuple[int, ...], tuple[int, ...]], ...],
    tuple[tuple[tuple[int, ...], int, int], ...],
]:
    if circuit_family is None:
        circuit_family = circuits(columns)
    private = frozenset(range(boundary_width, len(columns)))
    infinity = radius + 1
    controls = []
    weights = []
    closures: dict[tuple[int, ...], frozenset[int]] = {}
    for incoming in itertools.product(range(infinity + 1), repeat=boundary_width):
        active = terminal_closure(
            boundary_width,
            private,
            seed,
            circuit_family,
            incoming,
            radius,
        )
        response = tuple(
            outgoing_response(
                port,
                boundary_width,
                private,
                active,
                circuit_family,
                incoming,
                radius,
            )
            for port in range(boundary_width)
        )
        controls.append((incoming, response))
        weights.append((incoming, len(active), len(private - active)))
        closures[incoming] = active

        # Terminal private elements are exactly outside the feasible Horn heads.
        for target in private - active:
            assert not any(
                target in circuit
                and ((circuit & private) - {target}) <= active
                and len((circuit & private) - {target})
                + sum(incoming[p] for p in circuit if p < boundary_width)
                <= radius
                for circuit in circuit_family
            )

    # Better boundary certificates can only enlarge closure and improve response.
    for worse, better in itertools.product(closures, repeat=2):
        if not all(better[i] <= worse[i] for i in range(boundary_width)):
            continue
        assert closures[worse] <= closures[better]
        worse_response = dict(controls)[worse]
        better_response = dict(controls)[better]
        assert all(
            better_response[i] <= worse_response[i]
            for i in range(boundary_width)
        )

    return tuple(controls), tuple(weights)


def multiport_catalog() -> dict[str, object]:
    representations = []
    for private_count in range(1, 5):
        for rest in itertools.combinations(range(3, 8), private_count):
            columns = (1, 2) + rest
            circuit_family = circuits(columns)
            if all(
                any(port in circuit for circuit in circuit_family)
                for port in (0, 1)
            ):
                representations.append((columns, circuit_family))

    states_by_radius = {radius: 0 for radius in RADII}
    controls_by_radius = {radius: set() for radius in RADII}
    weighted_by_radius = {radius: set() for radius in RADII}
    controls_with_several_weights = {radius: {} for radius in RADII}
    for columns, circuit_family in representations:
        private = tuple(range(2, len(columns)))
        for seed in subsets(private):
            for radius in RADII:
                control, weight = terminal_tables(
                    columns, 2, seed, radius, circuit_family
                )
                states_by_radius[radius] += 1
                controls_by_radius[radius].add(control)
                weighted_by_radius[radius].add((control, weight))
                controls_with_several_weights[radius].setdefault(control, set()).add(
                    weight
                )

    return {
        "field": "GF(2)",
        "ambient_rank": 3,
        "interface_width": 2,
        "component_representations": len(representations),
        "private_column_range": [1, 4],
        "component_seed_radius_states": sum(states_by_radius.values()),
        "states_by_radius": {str(k): v for k, v in states_by_radius.items()},
        "distinct_structural_controls": {
            str(k): len(v) for k, v in controls_by_radius.items()
        },
        "distinct_weighted_behaviors": {
            str(k): len(v) for k, v in weighted_by_radius.items()
        },
        "controls_with_multiple_count_weights": {
            str(radius): sum(
                len(weights) > 1
                for weights in controls_with_several_weights[radius].values()
            )
            for radius in RADII
        },
        "checks": [
            "complete terminal response table",
            "boundary monotonicity",
            "terminal stopping-core condition",
        ],
    }


def one_port_catalog() -> tuple[
    tuple[tuple[int, ...], tuple[frozenset[int], ...]], ...
]:
    result = []
    for private_count in (2, 3):
        for rest in itertools.combinations(range(2, 8), private_count):
            columns = (1,) + rest
            circuit_family = circuits(columns)
            if any(0 in circuit for circuit in circuit_family):
                result.append((columns, circuit_family))
    return tuple(result)


def glue_binary_representations(
    left: tuple[int, ...], right: tuple[int, ...]
) -> tuple[int, ...]:
    shifted_right = tuple((value & 1) | ((value >> 1) << 3) for value in right[1:])
    return left[1:] + shifted_right


def direct_terminal_closure(
    ground_size: int,
    seed: frozenset[int],
    circuit_family: tuple[frozenset[int], ...],
    radius: int,
) -> frozenset[int]:
    active = seed
    while True:
        additions = {
            target
            for target in frozenset(range(ground_size)) - active
            if any(
                target in circuit
                and len(circuit) - 1 <= radius
                and circuit - {target} <= active
                for circuit in circuit_family
            )
        }
        if not additions:
            return active
        active |= additions


def weighted_two_sum_catalog() -> dict[str, object]:
    catalog = one_port_catalog()
    component_states = []
    for columns, circuit_family in catalog:
        for seed in subsets(tuple(range(1, len(columns)))):
            component_states.append((columns, circuit_family, seed))

    checked = 0
    fixed_point_iterations = 0
    for left_columns, left_circuits, left_seed in component_states:
        for right_columns, right_circuits, right_seed in component_states:
            glued = glue_binary_representations(left_columns, right_columns)
            glued_circuits = circuits(glued)
            offset = len(left_columns) - 1
            global_seed = frozenset(element - 1 for element in left_seed) | frozenset(
                offset + element - 1 for element in right_seed
            )
            for radius in RADII:
                left_control, left_weight = terminal_tables(
                    left_columns, 1, left_seed, radius, left_circuits
                )
                right_control, right_weight = terminal_tables(
                    right_columns, 1, right_seed, radius, right_circuits
                )
                left_f = {q[0]: value[0] for q, value in left_control}
                right_f = {q[0]: value[0] for q, value in right_control}
                left_w = {q[0]: active for q, active, _core in left_weight}
                right_w = {q[0]: active for q, active, _core in right_weight}
                left_c = {q[0]: core for q, _active, core in left_weight}
                right_c = {q[0]: core for q, _active, core in right_weight}

                infinity = radius + 1
                left_in = infinity
                right_in = infinity
                iterations = 0
                while True:
                    enlarged = (right_f[right_in], left_f[left_in])
                    assert enlarged[0] <= left_in and enlarged[1] <= right_in
                    if enlarged == (left_in, right_in):
                        break
                    left_in, right_in = enlarged
                    iterations += 1
                predicted_active = left_w[left_in] + right_w[right_in]
                predicted_core = left_c[left_in] + right_c[right_in]

                direct = direct_terminal_closure(
                    len(glued), global_seed, glued_circuits, radius
                )
                assert predicted_active == len(direct)
                assert predicted_core == len(glued) - len(direct)
                fixed_point_iterations = max(fixed_point_iterations, iterations)
                checked += 1

    return {
        "field": "GF(2)",
        "one_port_component_representations": len(catalog),
        "component_seed_states": len(component_states),
        "represented_2_sum_seed_radius_states": checked,
        "maximum_boundary_fixed_point_iterations": fixed_point_iterations,
        "checks": [
            "least boundary fixed point versus direct represented 2-sum closure",
            "sum of component active/core weights versus direct terminal counts",
        ],
    }


def triangle_family(n: int) -> tuple[
    tuple[int, ...], tuple[frozenset[int], ...], frozenset[int]
]:
    # Boundary columns p,q come first; then x_1,...,x_{n-1},s_1,...,s_n.
    columns = (1, 1 << n)
    columns += tuple(1 << i for i in range(1, n))
    columns += tuple((1 << (i - 1)) ^ (1 << i) for i in range(1, n + 1))

    def endpoint(i: int) -> int:
        if i == 0:
            return 0
        if i == n:
            return 1
        return 1 + i

    first_seed = 2 + (n - 1)
    triangle_circuits = tuple(
        frozenset((endpoint(i - 1), first_seed + i - 1, endpoint(i)))
        for i in range(1, n + 1)
    )
    seed = frozenset(range(first_seed, first_seed + n))
    return columns, triangle_circuits, seed


def triangle_relay_replay(max_n: int) -> dict[str, object]:
    if max_n < 2:
        raise ValueError("max_n must be at least two")
    controls = set()
    weights = set()
    records = []
    for n in range(2, max_n + 1):
        columns, triangle_circuits, seed = triangle_family(n)
        control, weight = terminal_tables(
            columns, 2, seed, radius=2, circuit_family=triangle_circuits
        )
        controls.add(control)
        weights.add(weight)
        table = {q: (active, core) for q, active, core in weight}
        response = dict(control)
        infinity = 3
        assert all(
            response[q]
            == ((2, 2) if min(q) <= 1 else (infinity, infinity))
            for q in response
        )
        assert table[(infinity, infinity)] == (n, n - 1)
        assert table[(1, infinity)] == (2 * n - 1, 0)
        records.append(
            {
                "n": n,
                "private_columns": 2 * n - 1,
                "active_with_no_boundary_supply": n,
                "core_with_no_boundary_supply": n - 1,
                "active_with_unit_p_supply": 2 * n - 1,
            }
        )
    assert len(controls) == 1
    assert len(weights) == max_n - 1
    return {
        "field": "GF(2)",
        "radius": 2,
        "interface_width": 2,
        "verified_n": [2, max_n],
        "families_checked": len(records),
        "distinct_terminal_structural_controls": len(controls),
        "distinct_integer_weight_tables": len(weights),
        "first_record": records[0],
        "last_record": records[-1],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-n", type=int, default=32)
    parser.add_argument(
        "--output", type=Path, default=Path(__file__).with_suffix(".json")
    )
    args = parser.parse_args()

    certificate = {
        "task": "C233 terminal-closure transfer algebra",
        "theorems_checked": {
            "finite_terminal_boundary_control": True,
            "least_fixed_point_composition": True,
            "additive_active_core_weights": True,
            "triangle_delay_collapse": True,
        },
        "bounded_binary_multiport_catalog": multiport_catalog(),
        "weighted_2_sum_composition_catalog": weighted_two_sum_catalog(),
        "triangle_relay_terminal_replay": triangle_relay_replay(args.max_n),
    }
    args.output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
