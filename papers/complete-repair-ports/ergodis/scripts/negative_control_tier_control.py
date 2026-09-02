#!/usr/bin/env python3
"""Incumbent control for the C1038 negative-control benchmark tier.

Reads one instance, emitted verbatim by
``examples/negative_control_tier.rs emit <row>``, from a file or from standard
input, solves it exactly with CP-SAT from OR-Tools, and prints one canonical
JSON record on standard output.

The control solves exactly the instance the ergodis side solves: both sides read
the same emitted bytes, so the comparison is not mediated by two independent
generators.

usage: negative_control_tier_control.py <instance.json> [--workers N]
"""

from __future__ import annotations

import argparse
import json
import resource
import sys
import time

from ortools.sat.python import cp_model


def solve_subset_sum(instance: dict, workers: int) -> tuple[int, str]:
    """Exact feasibility: does some subset of the weights sum to the target?"""
    weights = instance["weights"]
    target = instance["target"]
    model = cp_model.CpModel()
    take = [model.NewBoolVar(f"x{index}") for index in range(len(weights))]
    model.Add(sum(weight * variable for weight, variable in zip(weights, take)) == target)
    solver = cp_model.CpSolver()
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 0
    status = solver.Solve(model)
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        return 1, "feasible"
    if status == cp_model.INFEASIBLE:
        return 0, "infeasible"
    return -1, solver.StatusName(status)


def solve_scheduler(instance: dict, workers: int) -> tuple[int, str]:
    """Exact maximum number of demands served within every resource capacity."""
    capacities = instance["capacities"]
    families = instance["families"]
    model = cp_model.CpModel()
    chosen = []
    for demand, options in enumerate(families):
        row = [model.NewBoolVar(f"x{demand}_{index}") for index in range(len(options))]
        model.AddAtMostOne(row)
        chosen.append(row)
    for resource_index, capacity in enumerate(capacities):
        model.Add(
            sum(
                options[index][resource_index] * chosen[demand][index]
                for demand, options in enumerate(families)
                for index in range(len(options))
            )
            <= capacity
        )
    model.Maximize(sum(variable for row in chosen for variable in row))
    solver = cp_model.CpSolver()
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 0
    status = solver.Solve(model)
    if status == cp_model.OPTIMAL:
        return int(round(solver.ObjectiveValue())), "optimal"
    if status == cp_model.FEASIBLE:
        return int(round(solver.ObjectiveValue())), "feasible-not-proved"
    return -1, solver.StatusName(status)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("instance")
    parser.add_argument("--workers", type=int, default=1)
    arguments = parser.parse_args()

    if arguments.instance == "-":
        instance = json.load(sys.stdin)
    else:
        with open(arguments.instance, "r", encoding="utf-8") as handle:
            instance = json.load(handle)

    started = time.perf_counter_ns()
    if instance["kind"] == "subset_sum":
        answer, detail = solve_subset_sum(instance, arguments.workers)
    elif instance["kind"] == "scheduler":
        answer, detail = solve_scheduler(instance, arguments.workers)
    else:
        raise SystemExit(f"unknown instance kind: {instance['kind']}")
    elapsed_ns = time.perf_counter_ns() - started

    record = {
        "row": instance["row"],
        "side": "control",
        "control": "cp-sat",
        "status": "ok" if answer >= 0 else "unresolved",
        "detail": detail,
        "repetitions": 1,
        "elapsed_ns": str(elapsed_ns),
        "answer": answer,
        "work": 0,
        "representation": 0,
        # CP-SAT returns an assignment but no independently checkable proof of
        # optimality or of infeasibility; nothing is emitted to replay.
        "certificate_bytes": 0,
        "replay_ns": "0",
        "peak_rss_kib": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
    }
    print(json.dumps(record, sort_keys=True, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
