#!/usr/bin/env python3
"""Generate/check exact Python oracle fixtures for the Rust span engine."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

PYTHON_ROOT = Path(__file__).resolve().parent
ROOT = PYTHON_ROOT.parent
sys.path.insert(0, str(PYTHON_ROOT))

from recovery_algorithms.costs import (  # noqa: E402
    INF,
    compose_cost_table_with_witnesses,
    exact_confinement_cost,
    exact_confinement_cost_syndrome_dp,
    prescribed_coset_costs,
    translated_cost_table,
)
from recovery_algorithms.finite import (  # noqa: E402
    LinearMap,
    all_matrices,
    column_block,
    flatten,
    nullspace_basis,
)
from recovery_algorithms.incidence import (  # noqa: E402
    OrbitOption,
    ternary_orbit_syndrome_search,
)
from recovery_algorithms.balanced import (  # noqa: E402
    q27_balanced_terminal_rejection,
)
from recovery_algorithms.geometry import TernaryExtensionField  # noqa: E402
from recovery_algorithms.storage import (  # noqa: E402
    maximum_parallel_repairs,
    maximum_weighted_parallel_repairs,
)

FIXTURE = ROOT / "tests" / "fixtures" / "python_span_cases.json"


def balanced_terminal_cases() -> list[dict[str, object]]:
    field = TernaryExtensionField(27)

    def power(value: int, exponent: int) -> int:
        result = 1
        while exponent:
            if exponent & 1:
                result = field.multiply(result, value)
            value = field.multiply(value, value)
            exponent >>= 1
        return result

    ratios = tuple(
        value
        for value in range(27)
        if field.multiply(value, field.multiply(field.add(value, 1), field.add(value, 1)))
        == 2
    )
    mapping = None
    for first in range(1, 27):
        for second in range(1, 27):
            if first == second:
                continue
            third = power(field.multiply(first, second), 25)
            rows = (first, second, third)
            columns = tuple(
                field.multiply(ratio, row) for ratio, row in zip(ratios, rows)
            )
            if len(set(rows)) == 3 and len(set(columns)) == 3:
                mapping = (rows, columns)
                break
        if mapping is not None:
            break
    assert mapping is not None
    rows, columns = mapping
    high_value_list = list(columns)
    for value in range(1, 27):
        if value not in columns:
            high_value_list.append(value)
            if len(high_value_list) == 9:
                break
    high_values = tuple(sorted(high_value_list))
    cubic_values = tuple(sorted(columns))
    carriers = (
        ((0, 1, 1, 0, 0, 0, 0, 0, 0), (0, 0, 0, 1, 0, 0, 0, 0, 0)),
        ((1, 2, 0, 0, 0, 0, 0, 0, 0), (0, 1, 1, 0, 0, 0, 0, 0, 0)),
    )
    cases = []
    for trace, product in carriers:
        cases.append(
            {
                "trace": trace,
                "product": product,
                "rows": rows,
                "columns": columns,
                "ratios": ratios,
                "kappa": 2,
                "high_values": high_values,
                "cubic_values": cubic_values,
                "expected_rejection": q27_balanced_terminal_rejection(
                    trace,
                    product,
                    rows,
                    columns,
                    ratios,
                    2,
                    high_values,
                    cubic_values,
                ),
            }
        )
    return cases


def family(p: int, rows: int, columns: int, demand: int) -> list[dict[str, object]]:
    cases = []
    for generator in all_matrices(rows, columns, p):
        phi = LinearMap(p, generator)
        table = prescribed_coset_costs(phi, demand)
        targets = []
        for target in all_matrices(rows, demand, p):
            cost = table.get(target)
            witness = table.witness_for(target) if cost < INF else None
            targets.append(
                {
                    "data": flatten(target),
                    "cost": None if cost == INF else cost,
                    "support": None if witness is None else witness.support,
                }
            )
        cases.append(
            {
                "p": p,
                "rows": rows,
                "columns": columns,
                "demand": demand,
                "generator": flatten(generator),
                "targets": targets,
            }
        )
    return cases


def composition_case(
    p: int,
    generator: tuple[tuple[int, ...], ...],
    demand: int,
    blocks: tuple[tuple[tuple[int, ...], ...], ...],
) -> dict[str, object]:
    inner = prescribed_coset_costs(LinearMap(p, generator), demand)
    composed = compose_cost_table_with_witnesses(blocks, inner)
    outputs = []
    for key, cost in sorted(composed.costs.items()):
        label = composed.matrix_for(key)
        witness = composed.witness_for(label)
        if witness is None:
            raise AssertionError("composed fixture entry has no witness")
        outputs.append(
            {
                "data": key,
                "cost": cost,
                "local_labels": [flatten(value) for value in witness.local_labels],
            }
        )
    return {
        "p": p,
        "inner_rows": inner.output_dim,
        "demand": demand,
        "inner": [
            {"data": key, "cost": cost}
            for key, cost in sorted(inner.costs.items())
        ],
        "block_rows": len(blocks[0]),
        "blocks": [flatten(block) for block in blocks],
        "outputs": outputs,
    }


def confinement_case(demand: int) -> dict[str, object]:
    p = 2
    full_phi = LinearMap(p, ((1, 1, 0), (0, 0, 1)))
    helper_phi = LinearMap(p, ((1, 0), (0, 1)))
    inner = prescribed_coset_costs(full_phi, demand)
    target_value = ((1,) * demand, (0,) * demand)
    target = translated_cost_table(
        prescribed_coset_costs(helper_phi, demand), target_value
    )
    functional_basis = ((1, 0, 0, 1), (0, 1, 1, 1))
    constraints = nullspace_basis(functional_basis, p)
    blocks = tuple(column_block(constraints, 2 * block, 2) for block in range(2))
    generated = exact_confinement_cost(functional_basis, 2, inner, target, 0, 2)
    syndrome = exact_confinement_cost_syndrome_dp(blocks, inner, target, 0, 2)
    if (generated.cost, generated.sector) != (syndrome.cost, syndrome.sector):
        raise AssertionError("Python confinement engines disagree")
    return {
        "p": p,
        "label_rows": 2,
        "demand": demand,
        "block_count": 2,
        "target_block": 0,
        "inner_dual_distance": 2,
        "inner": [
            {"data": key, "cost": cost}
            for key, cost in sorted(inner.costs.items())
        ],
        "target": [
            {"data": key, "cost": cost}
            for key, cost in sorted(target.costs.items())
        ],
        "functional_rows": len(functional_basis),
        "functional_basis": flatten(functional_basis),
        "syndrome_rows": len(constraints),
        "constraint_blocks": [flatten(block) for block in blocks],
        "expected": {
            "cost": generated.cost,
            "sector": generated.sector,
            "functional_coefficients": generated.functional_coefficients,
            "generator_labels": [flatten(label) for label in generated.block_labels],
            "syndrome_labels": [flatten(label) for label in syndrome.block_labels],
        },
    }


def orbit_case(
    families: tuple[tuple[OrbitOption, ...], ...],
    target_residue: tuple[int, ...],
    target_totals: tuple[int, ...],
) -> dict[str, object]:
    result = ternary_orbit_syndrome_search(families, target_residue, target_totals)
    return {
        "families": [
            [
                {
                    "label": option.label,
                    "residue": option.residue,
                    "totals": option.totals,
                }
                for option in family
            ]
            for family in families
        ],
        "target_residue": target_residue,
        "target_totals": target_totals,
        "expected": {
            "choices": result.choices,
            "states_examined": result.states_examined,
            "bound_prunes": result.bound_prunes,
            "residue_prunes": result.residue_prunes,
            "memo_prunes": result.memo_prunes,
        },
    }


def weighted_scheduler_case() -> dict[str, object]:
    capacities = {resource: capacity for resource, capacity in enumerate((2, 2, 1))}
    raw_loads = (
        ((2, 0, 0), (1, 1, 0), (2, 1, 0)),
        ((1, 0, 1), (0, 2, 0)),
        ((1, 1, 0), (0, 0, 1)),
        ((0, 1, 1), (3, 0, 0)),
    )
    families = tuple(
        tuple(
            {resource: amount for resource, amount in enumerate(load) if amount}
            for load in family
        )
        for family in raw_loads
    )
    result = maximum_weighted_parallel_repairs(families, capacities)

    def dense(option: tuple[tuple[int, int], ...]) -> tuple[int, ...]:
        values = dict(option)
        return tuple(values.get(resource, 0) for resource in capacities)

    assignment = tuple((demand, dense(option)) for demand, option in result.assignment)
    total_loads = tuple(
        sum(load[resource] for _, load in assignment) for resource in capacities
    )
    return {
        "capacities": tuple(capacities.values()),
        "families": raw_loads,
        "expected": {
            "assignment": assignment,
            "unmatched_demands": result.unmatched_demands,
            "total_loads": total_loads,
            "transitions_examined": result.transitions_examined,
            "peak_pareto_states": result.peak_pareto_states,
        },
    }


def unit_scheduler_case() -> dict[str, object]:
    capacities = {resource: 1 for resource in range(3)}
    families = (
        ((0,), (0, 1)),
        ((0,), (1,)),
        ((1, 2),),
        ((2,),),
    )
    result = maximum_parallel_repairs(families, capacities)
    return {
        "capacities": tuple(capacities.values()),
        "families": families,
        "expected": {
            "assignment": result.assignment,
            "unmatched_demands": result.unmatched_demands,
            "states_examined": result.states_examined,
            "capacity_cut": {
                "resources": result.capacity_cut.resources,
                "forced_demands": result.capacity_cut.forced_demands,
                "capacity": result.capacity_cut.capacity,
                "repair_upper_bound": result.capacity_cut.repair_upper_bound,
            },
        },
    }


def gf4_mul(left: int, right: int) -> int:
    """Independent polynomial reduction modulo a^2+a+1."""
    product = 0
    for left_degree in range(2):
        for right_degree in range(2):
            if ((left >> left_degree) & 1) and ((right >> right_degree) & 1):
                product ^= 1 << (left_degree + right_degree)
    if product & 4:
        product ^= 0b111
    return product


def binary_row_basis(rows: list[tuple[int, ...]], width: int) -> dict[str, object]:
    data = [list(row) for row in rows]
    pivot = 0
    for column in range(width):
        found = next((row for row in range(pivot, len(data)) if data[row][column]), None)
        if found is None:
            continue
        data[pivot], data[found] = data[found], data[pivot]
        for row in range(len(data)):
            if row != pivot and data[row][column]:
                data[row] = [
                    left ^ right
                    for left, right in zip(data[row], data[pivot], strict=True)
                ]
        pivot += 1
    data = data[:pivot]
    return {
        "rows": pivot,
        "cols": width,
        "data": [entry for row in data for entry in row],
    }


def gf4_rank_one_profile(columns: tuple[int, ...], target: int) -> dict[str, object]:
    ordinary: list[tuple[int, tuple[int, ...]] | None] = [None] * 4
    normalized: list[tuple[int, tuple[int, ...]] | None] = [None] * 4
    dual: tuple[int, tuple[int, ...]] | None = None
    dual_rows: list[tuple[int, ...]] = []
    shortened_rows: list[tuple[int, ...]] = []
    for mask in range(1 << len(columns)):
        coefficients = tuple((mask >> coordinate) & 1 for coordinate in range(len(columns)))
        label = 0
        for coefficient, column in zip(coefficients, columns, strict=True):
            if coefficient:
                label ^= column
        support = sum(coefficients)
        candidate = (support, coefficients)
        if ordinary[label] is None or candidate < ordinary[label]:
            ordinary[label] = candidate
        if mask and label == 0 and (dual is None or candidate < dual):
            dual = candidate
        if mask and label == 0:
            helper_row = tuple(
                coefficient
                for coordinate, coefficient in enumerate(coefficients)
                if coordinate != target
            )
            dual_rows.append(helper_row)
            if not coefficients[target]:
                shortened_rows.append(helper_row)
        if coefficients[target]:
            candidate = (support - 1, coefficients)
            if normalized[label] is None or candidate < normalized[label]:
                normalized[label] = candidate
    if normalized[0] is None or dual is None:
        raise AssertionError("paper separation profile must be recoverable with nontrivial dual")
    zero_cost = normalized[0][0] + dual[0]
    nonzero = min(
        (
            normalized[coefficient][0]
            + ordinary[gf4_mul(2, coefficient)][0],
            coefficient,
            (coefficient, gf4_mul(2, coefficient)),
        )
        for coefficient in range(1, 4)
    )
    return {
        "columns": columns,
        "ordinary": ordinary,
        "target_normalized": normalized,
        "inner_dual": dual,
        "k_p": binary_row_basis(shortened_rows, len(columns) - 1),
        "d_p": binary_row_basis(dual_rows, len(columns) - 1),
        "zero_cost": zero_cost,
        "nonzero_cost": nonzero[0],
        "gamma": min(zero_cost, nonzero[0]),
        "outer_coefficient": nonzero[1],
        "block_labels": nonzero[2],
    }


def gf4_transfer_case() -> dict[str, object]:
    return {
        "target_coordinate": 0,
        "functional_basis": (1, 2),
        "profiles": [
            gf4_rank_one_profile((1, 1, 2), 0),
            gf4_rank_one_profile((1, 1, 3), 0),
        ],
    }


def gf4_target_subspace_case() -> dict[str, object]:
    columns = (1, 2, 1, 2)
    targets = (0, 1)
    normalization = ((1, 0), (0, 1))
    demand = 2

    def canonical_label(coefficients: tuple[int, ...]) -> tuple[int, ...]:
        label = [0] * demand
        for coordinate, column in enumerate(columns):
            for index in range(demand):
                if coefficients[coordinate * demand + index]:
                    label[index] ^= column
        return tuple(label)

    def union_cost(coefficients: tuple[int, ...], coordinates: tuple[int, ...]) -> int:
        return sum(
            any(coefficients[coordinate * demand + index] for index in range(demand))
            for coordinate in coordinates
        )

    ordinary: dict[tuple[int, ...], tuple[int, tuple[int, ...]]] = {}
    for packed in range(1 << (len(columns) * demand)):
        coefficients = tuple(
            (packed >> index) & 1 for index in range(len(columns) * demand)
        )
        label = canonical_label(coefficients)
        candidate = (union_cost(coefficients, tuple(range(len(columns)))), coefficients)
        if label not in ordinary or candidate < ordinary[label]:
            ordinary[label] = candidate

    helpers = tuple(coordinate for coordinate in range(len(columns)) if coordinate not in targets)
    target_costs: dict[tuple[int, ...], tuple[int, tuple[int, ...]]] = {}
    for packed in range(1 << (len(helpers) * demand)):
        coefficients = [0] * (len(columns) * demand)
        for target_row, coordinate in enumerate(targets):
            coefficients[coordinate * demand : (coordinate + 1) * demand] = normalization[
                target_row
            ]
        for helper_row, coordinate in enumerate(helpers):
            for index in range(demand):
                coefficients[coordinate * demand + index] = (
                    packed >> (helper_row * demand + index)
                ) & 1
        coefficient_tuple = tuple(coefficients)
        label = canonical_label(coefficient_tuple)
        candidate = (union_cost(coefficient_tuple, helpers), coefficient_tuple)
        if label not in target_costs or candidate < target_costs[label]:
            target_costs[label] = candidate

    zero_cost = target_costs[(0, 0)][0] + 2
    nonzero = min(
        (target_costs[label][0] + ordinary[label][0], label)
        for label in ordinary
        if label != (0, 0)
    )
    return {
        "columns": columns,
        "targets": targets,
        "normalization": {"rows": 2, "cols": 2, "data": (1, 0, 0, 1)},
        "functional_basis": (1, 1),
        "ordinary": [
            {"label": label, "cost": value[0], "coefficients": value[1]}
            for label, value in sorted(ordinary.items())
        ],
        "target_normalized": [
            {"label": label, "cost": value[0], "coefficients": value[1]}
            for label, value in sorted(target_costs.items())
        ],
        "target_union_cost": target_costs[(0, 0)][0],
        "inner_dual_distance": 2,
        "zero_cost": zero_cost,
        "nonzero_cost": nonzero[0],
        "gamma": min(zero_cost, nonzero[0]),
        "winning_labels": (nonzero[1], nonzero[1]),
    }


def target_tower_case() -> dict[str, object]:
    ordinary = {0: (0, ()), 1: (1, ())}
    target = {0: (2, ()), 1: (0, ())}

    def compose(
        ordinary_table: dict[int, tuple[int, tuple[int, ...]]],
        target_table: dict[int, tuple[int, tuple[int, ...]]],
        target_block: int | None,
    ) -> dict[int, tuple[int, tuple[int, ...]]]:
        result: dict[int, tuple[int, tuple[int, ...]]] = {}
        for output in range(2):
            candidates = []
            for left in range(2):
                right = output ^ left
                left_table = target_table if target_block == 0 else ordinary_table
                right_table = target_table if target_block == 1 else ordinary_table
                candidates.append(
                    (
                        left_table[left][0] + right_table[right][0],
                        (left, right),
                    )
                )
            result[output] = min(candidates)
        return result

    ordinary_one = compose(ordinary, ordinary, None)
    target_one = compose(ordinary, target, 0)
    ordinary_two = compose(ordinary_one, ordinary_one, None)
    target_two = compose(ordinary_one, target_one, 0)
    return {
        "ordinary": (0, 1),
        "target": (2, 0),
        "ordinary_level_one": [ordinary_one[label] for label in range(2)],
        "target_level_one": [target_one[label] for label in range(2)],
        "ordinary_level_two": [ordinary_two[label] for label in range(2)],
        "target_level_two": [target_two[label] for label in range(2)],
    }


def payload() -> bytes:
    value = {
        "schema": "ergodis-rust-v6",
        "balanced_terminal_cases": balanced_terminal_cases(),
        "cases": family(2, 2, 3, 2) + family(3, 1, 3, 2),
        "compositions": [
            composition_case(
                2,
                ((1, 0, 1), (0, 1, 1)),
                2,
                (((1, 0), (0, 1)), ((0, 1), (1, 1))),
            ),
            composition_case(
                3,
                ((1, 1),),
                1,
                (((1,),), ((2,),), ((1,),)),
            ),
        ],
        "confinements": [confinement_case(1), confinement_case(2)],
        "gf4_transfers": [gf4_transfer_case()],
        "gf4_target_subspaces": [gf4_target_subspace_case()],
        "target_towers": [target_tower_case()],
        "orbits": [
            orbit_case(
                (
                    (
                        OrbitOption(10, (0, 0, 0), (0,)),
                        OrbitOption(11, (0, 0, 0), (0,)),
                        OrbitOption(12, (1, 2, 0), (1,)),
                    ),
                    (
                        OrbitOption(20, (2, 1, 0), (1,)),
                        OrbitOption(21, (0, 0, 1), (2,)),
                    ),
                    (
                        OrbitOption(30, (1, 0, 2), (0,)),
                        OrbitOption(31, (0, 2, 2), (1,)),
                    ),
                ),
                target,
                (total,),
            )
            for target in ((0, 0, 0), (1, 1, 0), (2, 0, 2), (0, 2, 1))
            for total in range(4)
        ]
        + [
            orbit_case(
                (
                    (OrbitOption(40, (1,) * 25, (2,)),),
                    (OrbitOption(41, (2,) * 25, (3,)),),
                ),
                (0,) * 25,
                (5,),
            )
        ],
        "weighted_schedulers": [weighted_scheduler_case()],
        "unit_schedulers": [unit_scheduler_case()],
    }
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = payload()
    if args.write:
        FIXTURE.parent.mkdir(parents=True, exist_ok=True)
        FIXTURE.write_bytes(expected)
    elif not FIXTURE.exists() or FIXTURE.read_bytes() != expected:
        raise SystemExit(
            "Rust differential fixture is stale; run python/generate_fixtures.py --write"
        )


if __name__ == "__main__":
    main()
