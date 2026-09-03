#!/usr/bin/env python3
"""Exact CP-SAT interval control for the contended repair-DAG diagnostic row.

Mirrors the published `application:rdag:interval-cpsat` control — unit-duration
intervals, layer-to-layer precedence, minimized makespan — and replaces its
`add_no_overlap` per resource with `add_cumulative`, because the contended
fixture gives each of two shared dimensions a capacity above one. The model is
written independently of the Rust kernel: it constrains starts, precedence and
per-dimension capacity, and never mentions batches, ready sets or the subset
descent.

Usage: c1050_repair_dag_contended_control.py <width> <layers> <capacity> [reps]
Emits one JSON object on stdout in the shape the Rust example uses, so the two
sides can be compared cell for cell.
"""

from __future__ import annotations

import json
import sys
import time

from ortools.sat.python import cp_model


def solve(width: int, layers: int, capacity: int) -> int:
    task_count = width * layers
    horizon = task_count
    model = cp_model.CpModel()
    starts = [model.new_int_var(0, horizon - 1, f"s_{task}") for task in range(task_count)]
    ends = [model.new_int_var(1, horizon, f"e_{task}") for task in range(task_count)]
    intervals = [
        model.new_interval_var(starts[task], 1, ends[task], f"i_{task}")
        for task in range(task_count)
    ]
    for task in range(task_count):
        layer = task // width
        if layer:
            for predecessor in range((layer - 1) * width, layer * width):
                model.add(starts[task] >= ends[predecessor])
    for dimension in range(2):
        on_dimension = [
            intervals[task] for task in range(task_count) if task % width % 2 == dimension
        ]
        model.add_cumulative(on_dimension, [1] * len(on_dimension), capacity)
    makespan = model.new_int_var(1, horizon, "makespan")
    model.add_max_equality(makespan, ends)
    model.minimize(makespan)

    solver = cp_model.CpSolver()
    solver.parameters.num_workers = 1
    solver.parameters.random_seed = 0
    status = solver.solve(model)
    if status != cp_model.OPTIMAL:
        raise SystemExit(f"control did not prove optimality: {solver.status_name(status)}")
    return int(solver.value(makespan))


def main() -> None:
    width, layers, capacity = (int(value) for value in sys.argv[1:4])
    repetitions = int(sys.argv[4]) if len(sys.argv) > 4 else 1

    checksum = 0
    start = time.perf_counter_ns()
    for _ in range(repetitions):
        checksum += solve(width, layers, capacity)
    elapsed_ns = time.perf_counter_ns() - start

    print(
        json.dumps(
            {
                "variant": (
                    f"application:rdag-contended:interval-cpsat:{width}:{layers}:{capacity}"
                ),
                "repetitions": repetitions,
                "elapsed_ns": elapsed_ns,
                "work": 0,
                "peak_states": 0,
                "peak_rss_kib": 0,
                "checksum": checksum,
            }
        )
    )


if __name__ == "__main__":
    main()
