#!/usr/bin/env python3
"""Deterministic Python baselines for the Rust kernel benchmarks."""

from __future__ import annotations

import json
import resource
import sys
from pathlib import Path
from time import perf_counter_ns

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT.parent))

from recovery_algorithms.incidence import (  # noqa: E402
    OrbitOption,
    ternary_orbit_syndrome_search,
)
from recovery_algorithms.storage import maximum_weighted_parallel_repairs  # noqa: E402


class Generator:
    def __init__(self, state: int):
        self.state = state

    def next_u32(self) -> int:
        self.state = (self.state * 6_364_136_223_846_793_005 + 1) & ((1 << 64) - 1)
        return self.state >> 32


def transfer_tower_spec(variant: str):
    fields = variant.split(":")
    if (
        len(fields) != 4
        or fields[0] != "transfer-tower"
        or fields[1] not in ("cpsat", "cpsat-direct")
    ):
        return None
    return fields[1], int(fields[2]), int(fields[3])


def jin_fu_spec(variant: str):
    fields = variant.split(":")
    if (
        len(fields) != 2
        or fields[0] != "jin-fu"
        or fields[1]
        not in (
            "cpsat",
            "cpsat-direct",
        )
    ):
        return None
    return fields[1]


def jin_fu_hamming_spec(variant: str):
    fields = variant.split(":")
    if (
        len(fields) != 3
        or fields[0] != "jin-fu-hamming"
        or fields[1] not in ("cpsat", "cpsat-direct")
    ):
        return None
    return fields[1], int(fields[2])


def application_spec(variant: str):
    fields = variant.split(":")
    if len(fields) < 4 or fields[0] != "application" or fields[2] != "cpsat":
        return None
    return fields[1], tuple(int(field) for field in fields[3:])


def orbit_grid_spec(variant: str):
    fields = variant.split(":")
    if len(fields) != 6 or fields[:2] != ["orbit-grid", "cpsat"]:
        return None
    return tuple(int(field) for field in fields[2:])


def orbit_grid_problem(spec: tuple[int, int, int, int]):
    family_count, option_count, width, seed = spec
    generator = Generator(seed)
    families = tuple(
        tuple(
            tuple(generator.next_u32() % 3 for _ in range(width))
            for _ in range(option_count)
        )
        for _ in range(family_count)
    )
    target = tuple(generator.next_u32() % 3 for _ in range(width))
    return families, target


def gf4_target_tables():
    columns = (1, 2, 1, 2)
    ordinary = {}
    for packed in range(1 << 8):
        coefficients = tuple((packed >> bit) & 1 for bit in range(8))
        label = tuple(
            columns[0] * coefficients[demand]
            ^ columns[1] * coefficients[2 + demand]
            ^ columns[2] * coefficients[4 + demand]
            ^ columns[3] * coefficients[6 + demand]
            for demand in range(2)
        )
        cost = sum(
            coefficients[2 * row] != 0 or coefficients[2 * row + 1] != 0
            for row in range(4)
        )
        ordinary[label] = min(cost, ordinary.get(label, cost))
    target = {}
    for packed in range(1 << 4):
        coefficients = (1, 0, 0, 1) + tuple((packed >> bit) & 1 for bit in range(4))
        label = tuple(
            columns[0] * coefficients[demand]
            ^ columns[1] * coefficients[2 + demand]
            ^ columns[2] * coefficients[4 + demand]
            ^ columns[3] * coefficients[6 + demand]
            for demand in range(2)
        )
        cost = sum(
            coefficients[2 * row] != 0 or coefficients[2 * row + 1] != 0
            for row in range(2, 4)
        )
        target[label] = min(cost, target.get(label, cost))
    return ordinary, target


def gf4_mul(left: int, right: int) -> int:
    left_constant, left_alpha = left & 1, left >> 1
    right_constant, right_alpha = right & 1, right >> 1
    alpha_product = left_alpha & right_alpha
    constant = (left_constant & right_constant) ^ alpha_product
    alpha = (
        (left_constant & right_alpha) ^ (left_alpha & right_constant) ^ alpha_product
    )
    return constant | (alpha << 1)


def jin_fu_outer_dual_basis():
    polynomial = (1, 0, 3, 1, 1, 2, 0, 1)
    rows = [[0] * 43 for _ in range(36)]
    for shift, row in enumerate(rows):
        row[shift : shift + len(polynomial)] = polynomial
    pivots = []
    pivot_row = 0
    for column in range(43):
        found = next((row for row in range(pivot_row, 36) if rows[row][column]), None)
        if found is None:
            continue
        rows[pivot_row], rows[found] = rows[found], rows[pivot_row]
        inverse = gf4_mul(rows[pivot_row][column], rows[pivot_row][column])
        rows[pivot_row] = [gf4_mul(inverse, entry) for entry in rows[pivot_row]]
        normalized = rows[pivot_row]
        for row_index, row in enumerate(rows):
            if row_index == pivot_row or not row[column]:
                continue
            factor = row[column]
            rows[row_index] = [
                entry ^ gf4_mul(factor, pivot) for entry, pivot in zip(row, normalized)
            ]
        pivots.append(column)
        pivot_row += 1
    assert len(pivots) == 36
    basis = []
    for free in (column for column in range(43) if column not in pivots):
        vector = [0] * 43
        vector[free] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = rows[row][free]
        basis.append(vector)
    return basis


def gf4_hamming_dual_basis(dimension: int):
    assert 2 <= dimension <= 15
    rows = [[] for _ in range(dimension)]
    for pivot in range(dimension):
        for suffix in range(4 ** (dimension - pivot - 1)):
            digits = suffix
            for row in range(dimension):
                if row < pivot:
                    entry = 0
                elif row == pivot:
                    entry = 1
                else:
                    entry = digits & 3
                    digits >>= 2
                rows[row].append(entry)
    assert len(rows[0]) == (4**dimension - 1) // 3
    return rows


def gf4_product_bits(element: int, scalar_bits):
    constant, alpha = scalar_bits
    if element == 0:
        return ((), ())
    if element == 1:
        return ((constant,), (alpha,))
    if element == 2:
        return ((alpha,), (constant, alpha))
    assert element == 3
    return ((constant, alpha), (constant,))


def scheduler_problem(
    small: bool = False,
    spec: tuple[int, int, int, int, int] | None = None,
):
    if spec is None:
        resource_count, capacity, demand_count = (4, 2, 80) if small else (6, 3, 11)
        option_count = 4
        seed = 0xA17E_5EED
    else:
        resource_count, capacity, demand_count, option_count, seed = spec
    capacities = {resource: capacity for resource in range(resource_count)}
    generator = Generator(seed)
    families = []
    for _ in range(demand_count):
        family = []
        for _ in range(option_count):
            first = generator.next_u32() % resource_count
            second = generator.next_u32() % resource_count
            if second == first:
                second = (second + 1) % resource_count
            family.append({first: 1, second: 1})
        families.append(tuple(family))
    return tuple(families), capacities


def scheduler_grid_spec(variant: str):
    fields = variant.split(":")
    if len(fields) != 7 or fields[0] != "scheduler-grid":
        return None
    backend = fields[1]
    return backend, tuple(int(field) for field in fields[2:])


def heterogeneous_scheduler_problem(spec: tuple[int, int, int]):
    resource_count, capacity, demand_count = spec
    capacities = {resource: capacity for resource in range(resource_count)}
    families = []
    for demand in range(demand_count):
        family = []
        for resource_index in range(resource_count):
            family.append(
                {resource_index: 1 + int((demand + resource_index) % 3 == 0)}
            )
        families.append(tuple(family))
    return tuple(families), capacities


def heterogeneous_scheduler_grid_spec(variant: str):
    fields = variant.split(":")
    if len(fields) != 5 or fields[0] != "scheduler-heterogeneous-grid":
        return None
    return fields[1], tuple(int(field) for field in fields[2:])


def graded_scheduler_problem(spec: tuple[int, int, int, int, int]):
    resource_count, capacity, demand_count, option_count, seed = spec
    capacities = {resource: capacity for resource in range(resource_count)}
    even = tuple(range(0, resource_count, 2))
    odd = tuple(range(1, resource_count, 2))
    generator = Generator(seed)
    families = []
    for _ in range(demand_count):
        family = []
        for option in range(option_count):
            loads = {}
            if option % 4 == 0:
                loads[even[generator.next_u32() % len(even)]] = 4
            elif option % 4 == 1:
                loads[odd[generator.next_u32() % len(odd)]] = 2
            elif option % 4 == 2:
                first = generator.next_u32() % len(even)
                second = generator.next_u32() % len(even)
                if second == first:
                    second = (second + 1) % len(even)
                loads[even[first]] = 2
                loads[even[second]] = 2
            else:
                loads[even[generator.next_u32() % len(even)]] = 2
                loads[odd[generator.next_u32() % len(odd)]] = 1
            family.append(loads)
        families.append(tuple(family))
    return tuple(families), capacities


def graded_scheduler_grid_spec(variant: str):
    fields = variant.split(":")
    if len(fields) != 7 or fields[0] != "scheduler-graded-grid":
        return None
    return fields[1], tuple(int(field) for field in fields[2:])


def canonicalize_weighted_families(families, capacities):
    """Apply the same feasibility, duplicate, and dominance reductions as Rust."""

    resources = tuple(capacities)
    canonical_families = []
    for family in families:
        vectors = sorted(
            {
                tuple(option.get(resource, 0) for resource in resources)
                for option in family
                if all(
                    option.get(resource, 0) <= capacities[resource]
                    for resource in resources
                )
            }
        )
        minimal = [
            vector
            for index, vector in enumerate(vectors)
            if not any(
                index != other_index
                and all(left <= right for left, right in zip(other, vector))
                for other_index, other in enumerate(vectors)
            )
        ]
        canonical_families.append(
            tuple(
                {resource: load for resource, load in zip(resources, vector) if load}
                for vector in minimal
            )
        )
    return tuple(canonical_families)


def orbit_problem():
    width = 12
    generator = Generator(0xA17E_0B17)
    families = tuple(
        tuple(
            OrbitOption(
                family * 3 + option,
                tuple(generator.next_u32() % 3 for _ in range(width)),
            )
            for option in range(3)
        )
        for family in range(10)
    )
    target = tuple(generator.next_u32() % 3 for _ in range(width))
    return families, target


def main() -> None:
    variant, repetitions_text = sys.argv[1:]
    repetitions = int(repetitions_text)
    grid = scheduler_grid_spec(variant)
    graded_grid = graded_scheduler_grid_spec(variant)
    heterogeneous_grid = heterogeneous_scheduler_grid_spec(variant)
    transfer_tower = transfer_tower_spec(variant)
    jin_fu = jin_fu_spec(variant)
    jin_fu_hamming = jin_fu_hamming_spec(variant)
    application_case = application_spec(variant)
    orbit_grid = orbit_grid_spec(variant)
    cp_model = None
    if (
        transfer_tower is not None
        or jin_fu is not None
        or jin_fu_hamming is not None
        or application_case is not None
        or orbit_grid is not None
        or variant in ("scheduler-cpsat", "scheduler-cpsat-small")
        or (grid is not None and grid[0] == "cpsat")
        or (graded_grid is not None and graded_grid[0].startswith("cpsat"))
        or (
            heterogeneous_grid is not None and heterogeneous_grid[0].startswith("cpsat")
        )
    ):
        from ortools.sat.python import cp_model as loaded_cp_model

        cp_model = loaded_cp_model
    work = peak_states = checksum = 0
    started = perf_counter_ns()
    if application_case is not None:
        assert cp_model is not None
        application, parameters = application_case
        model = cp_model.CpModel()
        expected_checksum = 0
        if application == "azure":
            demands, capacity = parameters
            choices = [
                [model.new_bool_var(f"x_{demand}_{option}") for option in range(4)]
                for demand in range(demands)
            ]
            for family in choices:
                model.add_exactly_one(family)
            loads = []
            for demand in range(demands):
                target = demand % 12
                local_index = target % 6
                options = []
                local = [0] * 9
                for domain in range(6):
                    if domain != local_index:
                        local[domain] = 1
                local[6] = 1
                options.append(local)
                global_zero = [0] * 9
                for data in range(12):
                    if data != target:
                        global_zero[data % 6] += 1
                global_zero[7] = 1
                options.append(global_zero)
                global_one = global_zero.copy()
                global_one[7] = 0
                global_one[8] = 1
                options.append(global_one)
                options.append([0] * 9)
                loads.append(options)
            for resource_index in range(9):
                model.add(
                    sum(
                        loads[demand][option][resource_index] * choices[demand][option]
                        for demand in range(demands)
                        for option in range(4)
                    )
                    <= capacity
                )
            model.maximize(
                sum(
                    choices[demand][option]
                    for demand in range(demands)
                    for option in range(3)
                )
            )
            expected_checksum = demands
        elif application == "azure-counted":
            demands, capacity = parameters
            multiplicities = [
                demands // 6 + int(kind < demands % 6) for kind in range(6)
            ]
            counts = [
                [
                    model.new_int_var(0, multiplicities[kind], f"x_{kind}_{mode}")
                    for mode in range(3)
                ]
                for kind in range(6)
            ]
            for kind in range(6):
                model.add(sum(counts[kind]) <= multiplicities[kind])
            local = sum(counts[kind][0] for kind in range(6))
            global_zero = sum(counts[kind][1] for kind in range(6))
            global_one = sum(counts[kind][2] for kind in range(6))
            global_total = global_zero + global_one
            for domain in range(6):
                served_type = sum(counts[domain])
                model.add(local + 2 * global_total - served_type <= capacity)
            model.add(local <= capacity)
            model.add(global_zero <= capacity)
            model.add(global_one <= capacity)
            model.maximize(local + global_total)
            expected_checksum = demands
        elif application == "rdag":
            width, layers = parameters
            task_count = width * layers
            horizon = task_count
            starts = [model.new_int_var(0, horizon - 1, f"s_{task}") for task in range(task_count)]
            placed = [
                [model.new_bool_var(f"x_{task}_{slot}") for slot in range(horizon)]
                for task in range(task_count)
            ]
            for task in range(task_count):
                model.add_exactly_one(placed[task])
                model.add(starts[task] == sum(slot * placed[task][slot] for slot in range(horizon)))
                layer = task // width
                if layer:
                    for predecessor in range((layer - 1) * width, layer * width):
                        model.add(starts[task] >= starts[predecessor] + 1)
            for resource_index in range(width):
                for slot in range(horizon):
                    model.add(
                        sum(
                            placed[task][slot]
                            for task in range(task_count)
                            if (task % width + task // width) % width == resource_index
                        )
                        <= 1
                    )
            makespan = model.new_int_var(1, horizon, "makespan")
            model.add_max_equality(makespan, [start + 1 for start in starts])
            model.minimize(makespan)
            expected_checksum = layers
        elif application == "qc":
            lift, size = parameters
            variables = [model.new_bool_var(f"x_{variable}") for variable in range(2 * lift)]
            model.add(sum(variables) == size)
            model.add_bool_or([variables[0], variables[lift]])
            for check_group, shifts in enumerate(((0, 0), (0, 1))):
                for position in range(lift):
                    active = [
                        variables[group * lift + (position - shifts[group]) % lift]
                        for group in range(2)
                    ]
                    half = model.new_int_var(0, 1, f"h_{check_group}_{position}")
                    model.add(sum(active) == 2 * half)
            expected_checksum = 0
        elif application == "vector":
            nodes, subpacketization = parameters
            ambient = 8
            selected = [model.new_bool_var(f"n_{node}") for node in range(nodes)]
            for demand in range(ambient):
                coefficients = [
                    model.new_bool_var(f"a_{demand}_{coordinate}")
                    for coordinate in range(nodes * subpacketization)
                ]
                for node in range(nodes):
                    for symbol in range(subpacketization):
                        model.add(coefficients[node * subpacketization + symbol] <= selected[node])
                for row in range(ambient):
                    active = [
                        coefficients[node * subpacketization + symbol]
                        for node in range(nodes)
                        for symbol in range(subpacketization)
                        if 2 * (node & 3) + (symbol & 1) == row
                    ]
                    half = model.new_int_var(0, len(active) // 2 + 1, f"h_{demand}_{row}")
                    model.add(sum(active) == int(row == demand) + 2 * half)
            model.minimize(sum(selected))
            expected_checksum = 4
        elif application in ("gpu", "gpu-compiled"):
            shards, data_shards, failures = parameters
            survivors = range(failures, shards)
            choices = [
                {
                    shard: model.new_bool_var(f"x_{failure}_{shard}")
                    for shard in survivors
                }
                for failure in range(failures)
            ]
            for family in choices:
                model.add(sum(family.values()) == data_shards)
            for shard in survivors:
                model.add(sum(family[shard] for family in choices) <= failures)
            same_rack = [shard for shard in survivors if shard < 8]
            cross_rack = [shard for shard in survivors if shard >= 8]
            model.add(
                sum(family[shard] for family in choices for shard in same_rack)
                <= data_shards * failures
            )
            model.add(
                sum(family[shard] for family in choices for shard in cross_rack)
                <= data_shards * failures
            )
            expected_checksum = failures
        else:
            raise RuntimeError(f"unknown application CP-SAT benchmark: {application}")
        solver = cp_model.CpSolver()
        solver.parameters.num_workers = 1
        solver.parameters.random_seed = 0
        for _ in range(repetitions):
            status = solver.solve(model)
            if application == "qc":
                if status != cp_model.INFEASIBLE:
                    raise RuntimeError(f"expected infeasibility: {solver.status_name(status)}")
            elif status != cp_model.OPTIMAL:
                raise RuntimeError(f"CP-SAT did not prove optimality: {solver.status_name(status)}")
            objective = (
                expected_checksum
                if application in ("gpu", "gpu-compiled", "qc")
                else round(solver.objective_value)
            )
            assert objective == expected_checksum
            work += solver.num_branches
            peak_states = max(peak_states, solver.num_conflicts)
            checksum += expected_checksum
    elif orbit_grid is not None:
        assert cp_model is not None
        families, target = orbit_grid_problem(orbit_grid)
        model = cp_model.CpModel()
        choices = [
            [
                model.new_bool_var(f"x_{family}_{option}")
                for option in range(len(options))
            ]
            for family, options in enumerate(families)
        ]
        for family in choices:
            model.add_exactly_one(family)
        for coordinate, target_value in enumerate(target):
            total = sum(
                residue[coordinate] * choices[family][option]
                for family, options in enumerate(families)
                for option, residue in enumerate(options)
            )
            carry = model.new_int_var(0, len(families), f"carry_{coordinate}")
            model.add(total == target_value + 3 * carry)
        solver = cp_model.CpSolver()
        solver.parameters.num_workers = 1
        solver.parameters.random_seed = 0
        for _ in range(repetitions):
            status = solver.solve(model)
            if status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
                raise RuntimeError(
                    f"CP-SAT did not find a solution: {solver.status_name(status)}"
                )
            work += solver.num_branches
            peak_states = max(peak_states, solver.num_conflicts)
            checksum += 1
    elif jin_fu is not None or jin_fu_hamming is not None:
        assert cp_model is not None
        if jin_fu_hamming is None:
            backend = jin_fu
            basis = jin_fu_outer_dual_basis()
        else:
            backend, dimension = jin_fu_hamming
            basis = gf4_hamming_dual_basis(dimension)
        block_count = len(basis[0])
        model = cp_model.CpModel()
        functional = [
            [model.new_bool_var(f"u_{row}_{bit}") for bit in range(2)]
            for row in range(len(basis))
        ]
        model.add_bool_or(variable for row in functional for variable in row)
        objective = []
        for block in range(block_count):
            outer_terms = [[], []]
            for row, basis_row in enumerate(basis):
                product = gf4_product_bits(basis_row[block], functional[row])
                outer_terms[0].extend(product[0])
                outer_terms[1].extend(product[1])
            if backend == "cpsat":
                costs = (2, 0, 1, 1) if block == 0 else (0, 1, 1, 1)
                choices = [
                    model.new_bool_var(f"x_{block}_{label}") for label in range(4)
                ]
                model.add_exactly_one(choices)
                objective.extend(
                    cost * choices[label] for label, cost in enumerate(costs)
                )
                for bit in range(2):
                    active = outer_terms[bit] + [
                        choices[label] for label in range(4) if (label >> bit) & 1
                    ]
                    half = model.new_int_var(
                        0, len(active) // 2 + 1, f"h_{block}_{bit}"
                    )
                    model.add(sum(active) == 2 * half)
            else:
                coefficients = []
                for coordinate in range(3):
                    if block == 0 and coordinate == 0:
                        coefficient = model.new_constant(1)
                    else:
                        coefficient = model.new_bool_var(f"a_{block}_{coordinate}")
                        objective.append(coefficient)
                    coefficients.append(coefficient)
                for bit in range(2):
                    active = outer_terms[bit] + [
                        coefficients[coordinate]
                        for coordinate, column in enumerate((1, 2, 3))
                        if (column >> bit) & 1
                    ]
                    half = model.new_int_var(
                        0, len(active) // 2 + 1, f"h_{block}_{bit}"
                    )
                    model.add(sum(active) == 2 * half)
        model.minimize(sum(objective))
        solver = cp_model.CpSolver()
        solver.parameters.num_workers = 1
        solver.parameters.random_seed = 0
        for _ in range(repetitions):
            status = solver.solve(model)
            if status != cp_model.OPTIMAL:
                raise RuntimeError(
                    f"CP-SAT did not prove optimality: {solver.status_name(status)}"
                )
            nonzero_cost = round(solver.objective_value)
            expected_nonzero = (
                26 if jin_fu_hamming is None else 4 ** (dimension - 1) - 1
            )
            assert nonzero_cost == expected_nonzero
            work += solver.num_branches
            peak_states = max(peak_states, solver.num_conflicts)
            checksum += min(5, nonzero_cost)
    elif transfer_tower is not None:
        assert cp_model is not None
        backend, depth, fanout = transfer_tower
        leaves = fanout**depth
        model = cp_model.CpModel()
        if backend == "cpsat":
            ordinary, target = gf4_target_tables()
            choices = []
            for leaf in range(leaves):
                table = target if leaf == 0 else ordinary
                choices.append(
                    [
                        (label, cost, model.new_bool_var(f"x_{leaf}_{option}"))
                        for option, (label, cost) in enumerate(sorted(table.items()))
                    ]
                )
                model.add_exactly_one(variable for _, _, variable in choices[-1])
            for demand in range(2):
                for bit in range(2):
                    active = [
                        variable
                        for leaf in choices
                        for label, _, variable in leaf
                        if (label[demand] >> bit) & 1
                    ]
                    half = model.new_int_var(0, leaves // 2, f"half_{demand}_{bit}")
                    model.add(sum(active) == 2 * half)
            model.minimize(
                sum(cost * variable for leaf in choices for _, cost, variable in leaf)
            )
        else:
            columns = (1, 2, 1, 2)
            coefficients = []
            supports = []
            for leaf in range(leaves):
                leaf_coefficients = []
                for row in range(4):
                    row_coefficients = []
                    for demand in range(2):
                        fixed = leaf == 0 and row < 2
                        value = int(fixed and row == demand)
                        row_coefficients.append(
                            model.new_constant(value)
                            if fixed
                            else model.new_bool_var(f"a_{leaf}_{row}_{demand}")
                        )
                    leaf_coefficients.append(row_coefficients)
                    if not (leaf == 0 and row < 2):
                        support = model.new_bool_var(f"s_{leaf}_{row}")
                        model.add_max_equality(support, row_coefficients)
                        supports.append(support)
                coefficients.append(leaf_coefficients)
            for demand in range(2):
                for bit in range(2):
                    active = [
                        coefficients[leaf][row][demand]
                        for leaf in range(leaves)
                        for row, column in enumerate(columns)
                        if (column >> bit) & 1
                    ]
                    half = model.new_int_var(
                        0, len(active) // 2 + 1, f"half_{demand}_{bit}"
                    )
                    model.add(sum(active) == 2 * half)
            model.minimize(sum(supports))
        solver = cp_model.CpSolver()
        solver.parameters.num_workers = 1
        solver.parameters.random_seed = 0
        for _ in range(repetitions):
            status = solver.solve(model)
            if status != cp_model.OPTIMAL:
                raise RuntimeError(
                    f"CP-SAT did not prove optimality: {solver.status_name(status)}"
                )
            work += solver.num_branches
            peak_states = max(peak_states, solver.num_conflicts)
            checksum += round(solver.objective_value)
    elif variant in ("scheduler-python", "scheduler-python-small"):
        families, capacities = scheduler_problem(variant.endswith("-small"))
        for _ in range(repetitions):
            answer = maximum_weighted_parallel_repairs(families, capacities)
            work += answer.transitions_examined
            peak_states = max(peak_states, answer.peak_pareto_states)
            checksum += answer.repaired_count
    elif (
        variant in ("scheduler-cpsat", "scheduler-cpsat-small")
        or (grid is not None and grid[0] == "cpsat")
        or (graded_grid is not None and graded_grid[0].startswith("cpsat"))
        or (
            heterogeneous_grid is not None and heterogeneous_grid[0].startswith("cpsat")
        )
    ):
        assert cp_model is not None
        if heterogeneous_grid is not None:
            families, capacities = heterogeneous_scheduler_problem(
                heterogeneous_grid[1]
            )
            if heterogeneous_grid[0].startswith("cpsat-structured-"):
                families = canonicalize_weighted_families(families, capacities)
        elif graded_grid is not None:
            families, capacities = graded_scheduler_problem(graded_grid[1])
            if graded_grid[0].startswith("cpsat-structured"):
                families = canonicalize_weighted_families(families, capacities)
        else:
            families, capacities = scheduler_problem(
                variant.endswith("-small"), None if grid is None else grid[1]
            )
        model = cp_model.CpModel()
        choices = [
            [
                model.new_bool_var(f"x_{demand}_{option}")
                for option in range(len(family))
            ]
            for demand, family in enumerate(families)
        ]
        for family in choices:
            model.add_at_most_one(family)
        for resource_index, capacity in capacities.items():
            model.add(
                sum(
                    raw_option.get(resource_index, 0) * choices[demand][option]
                    for demand, family in enumerate(families)
                    for option, raw_option in enumerate(family)
                )
                <= capacity
            )
        model.maximize(sum(variable for family in choices for variable in family))
        if graded_grid is not None and graded_grid[0].startswith("cpsat-structured"):
            resource_count, capacity, demand_count, _, _ = graded_grid[1]
            weights = tuple(
                1 if resource % 2 == 0 else 2 for resource in range(resource_count)
            )
            capacity_mass = capacity * sum(weights)
            model.add(
                sum(variable for family in choices for variable in family)
                <= min(demand_count, capacity_mass // 4)
            )
        structured = (
            graded_grid is not None and graded_grid[0].startswith("cpsat-structured")
        ) or (
            heterogeneous_grid is not None
            and heterogeneous_grid[0].startswith("cpsat-structured")
        )
        reusable_solver = cp_model.CpSolver() if structured else None
        backend = (
            heterogeneous_grid[0]
            if heterogeneous_grid is not None
            else graded_grid[0]
            if graded_grid is not None
            else grid[0]
            if grid is not None
            else ""
        )
        worker_suffix = backend.rsplit("-", 1)[-1]
        workers = int(worker_suffix) if structured and worker_suffix.isdigit() else 1
        for _ in range(repetitions):
            solver = reusable_solver or cp_model.CpSolver()
            solver.parameters.num_workers = workers
            solver.parameters.random_seed = 0
            status = solver.solve(model)
            if status != cp_model.OPTIMAL:
                raise RuntimeError(
                    f"CP-SAT did not prove optimality: {solver.status_name(status)}"
                )
            selected = sum(
                solver.value(variable) for family in choices for variable in family
            )
            work += solver.num_branches
            peak_states = max(peak_states, solver.num_conflicts)
            checksum += selected
    elif variant == "orbit-python":
        families, target = orbit_problem()
        for _ in range(repetitions):
            answer = ternary_orbit_syndrome_search(families, target)
            work += answer.states_examined
            checksum += answer.feasible
    else:
        raise SystemExit("unknown benchmark variant")
    elapsed = perf_counter_ns() - started
    print(
        json.dumps(
            {
                "variant": variant,
                "repetitions": repetitions,
                "elapsed_ns": elapsed,
                "work": work,
                "peak_states": peak_states,
                "peak_rss_kib": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                "checksum": checksum,
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
