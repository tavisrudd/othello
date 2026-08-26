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
        for resource in range(resource_count):
            family.append({resource: 1 + int((demand + resource) % 3 == 0)})
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
                if all(option.get(resource, 0) <= capacities[resource] for resource in resources)
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
                {
                    resource: load
                    for resource, load in zip(resources, vector)
                    if load
                }
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
    cp_model = None
    if variant in ("scheduler-cpsat", "scheduler-cpsat-small") or (
        grid is not None and grid[0] == "cpsat"
    ) or (
        graded_grid is not None and graded_grid[0].startswith("cpsat")
    ) or (
        heterogeneous_grid is not None and heterogeneous_grid[0].startswith("cpsat")
    ):
        from ortools.sat.python import cp_model as loaded_cp_model

        cp_model = loaded_cp_model
    work = peak_states = checksum = 0
    started = perf_counter_ns()
    if variant in ("scheduler-python", "scheduler-python-small"):
        families, capacities = scheduler_problem(variant.endswith("-small"))
        for _ in range(repetitions):
            answer = maximum_weighted_parallel_repairs(families, capacities)
            work += answer.transitions_examined
            peak_states = max(peak_states, answer.peak_pareto_states)
            checksum += answer.repaired_count
    elif variant in ("scheduler-cpsat", "scheduler-cpsat-small") or (
        grid is not None and grid[0] == "cpsat"
    ) or (
        graded_grid is not None and graded_grid[0].startswith("cpsat")
    ) or (
        heterogeneous_grid is not None and heterogeneous_grid[0].startswith("cpsat")
    ):
        assert cp_model is not None
        if heterogeneous_grid is not None:
            families, capacities = heterogeneous_scheduler_problem(heterogeneous_grid[1])
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
            [model.new_bool_var(f"x_{demand}_{option}") for option in range(len(family))]
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
            weights = tuple(1 if resource % 2 == 0 else 2 for resource in range(resource_count))
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
            else graded_grid[0] if graded_grid is not None else grid[0] if grid is not None else ""
        )
        worker_suffix = backend.rsplit("-", 1)[-1]
        workers = int(worker_suffix) if structured and worker_suffix.isdigit() else 1
        for _ in range(repetitions):
            solver = reusable_solver or cp_model.CpSolver()
            solver.parameters.num_workers = workers
            solver.parameters.random_seed = 0
            status = solver.solve(model)
            if status != cp_model.OPTIMAL:
                raise RuntimeError(f"CP-SAT did not prove optimality: {solver.status_name(status)}")
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
