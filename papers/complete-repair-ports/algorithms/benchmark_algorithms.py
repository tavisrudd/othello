#!/usr/bin/env python3
"""Local microbenchmark harness; timings are diagnostic, never canonical evidence."""

from __future__ import annotations

import argparse
import gc
import json
import statistics
import time
import tracemalloc
from collections.abc import Callable

from recovery_algorithms.costs import (
    compose_cost_table,
    prescribed_coset_costs,
    prescribed_coset_costs_direct,
    prescribed_coset_costs_row_dp,
    simplify_dominated_blocks,
)
from recovery_algorithms.finite import LinearMap
from recovery_algorithms.service import build_service_lp, zero_extend_service_lp


def cyclic_map(length: int) -> LinearMap:
    columns = ((1, 0), (0, 1), (1, 1))
    return LinearMap(
        2,
        tuple(
            tuple(columns[column % len(columns)][row] for column in range(length))
            for row in range(2)
        ),
    )


def measure(function: Callable[[], object], repeats: int) -> dict[str, int]:
    function()
    timings = []
    was_enabled = gc.isenabled()
    gc.disable()
    try:
        for _ in range(repeats):
            start = time.perf_counter_ns()
            function()
            timings.append(time.perf_counter_ns() - start)
    finally:
        if was_enabled:
            gc.enable()
    tracemalloc.start()
    function()
    _, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    return {
        "minimum_ns": min(timings),
        "median_ns": int(statistics.median(timings)),
        "peak_traced_bytes": peak,
        "repeats": repeats,
    }


def prescribed_benchmarks(repeats: int) -> list[dict[str, object]]:
    rows = []
    for length in (4, 6, 8):
        phi = cyclic_map(length)
        methods = {
            "generated_spans": lambda: prescribed_coset_costs(phi, 2),
            "row_state_dp": lambda: prescribed_coset_costs_row_dp(phi, 2),
            "direct_lifts": lambda: prescribed_coset_costs_direct(phi, 2),
        }
        results = {name: measure(function, repeats) for name, function in methods.items()}
        checksums = {
            name: sum(function().costs.values()) for name, function in methods.items()
        }
        if len(set(checksums.values())) != 1:
            raise AssertionError("prescribed-cost benchmark methods disagree")
        rows.append({"length": length, "checksum": next(iter(checksums.values())), **results})
    return rows


def composition_benchmark(repeats: int) -> dict[str, object]:
    inner = prescribed_coset_costs(LinearMap(2, ((1, 0), (0, 1))), 1)
    blocks = (
        ((1, 0), (0, 1)),
        ((0, 1), (1, 0)),
        ((1, 0), (0, 0)),
    )
    retained = simplify_dominated_blocks(blocks, inner)
    return {
        "input_blocks": len(blocks),
        "retained_blocks": len(retained),
        "dominance_planning": measure(
            lambda: simplify_dominated_blocks(blocks, inner), repeats
        ),
        "unsimplified_execution": measure(
            lambda: compose_cost_table(blocks, inner, simplify_blocks=False), repeats
        ),
        "planned_execution": measure(
            lambda: compose_cost_table(retained, inner, simplify_blocks=False), repeats
        ),
    }


def service_benchmark(repeats: int) -> dict[str, object]:
    inner = build_service_lp((((0, 2), (1, 2)), ((1,),)), 4)
    extended = zero_extend_service_lp(inner, 10_000, 4_880)
    return {
        "global_helpers": extended.helper_count,
        "stored_active_rows": len(extended.active_helper_incidence),
        "sparse_access": measure(lambda: extended.active_helper_incidence, repeats),
        "dense_debug_materialization": measure(lambda: extended.helper_incidence, repeats),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repeats", type=int, default=3)
    args = parser.parse_args()
    if args.repeats < 1:
        parser.error("--repeats must be positive")
    print(
        json.dumps(
            {
                "warning": "local diagnostic timings; not canonical evidence",
                "prescribed_costs": prescribed_benchmarks(args.repeats),
                "composition": composition_benchmark(args.repeats),
                "service_lp": service_benchmark(args.repeats),
            },
            indent=2,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
