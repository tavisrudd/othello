#!/usr/bin/env python3
"""Exact CP-SAT oracle for the GF(27), T=54 defect branch."""

from __future__ import annotations

import argparse
import json
from collections import Counter

from ortools.sat.python import cp_model

from recovery_algorithms.defect import (
    gf27_q27_t54_centered_spectra,
    gf27_q27_t54_histogram_pairs,
)
from recovery_algorithms.geometry import ternary_projective_plane


def verify_solution(plane, arc_lines: list[int], maximal_points: list[int]) -> dict[str, object]:
    arc_set = set(arc_lines)
    maximal_set = set(maximal_points)
    if len(arc_set) != 279 or len(maximal_set) != 54:
        raise ValueError("solution cardinality mismatch")
    secant_degrees = [
        sum(line in arc_set for line in incident_lines)
        for incident_lines in plane.through_point
    ]
    if max(secant_degrees) != 19:
        raise ValueError("arc cap or maximal-secant count mismatch")
    if {point for point, degree in enumerate(secant_degrees) if degree == 19} != maximal_set:
        raise ValueError("maximal-point witness mismatch")
    line_degrees = [
        sum(point in maximal_set for point in incident_points)
        for incident_points in plane.on_line
    ]
    if any(line_degrees[line] == 0 for line in range(len(line_degrees)) if line not in arc_set):
        raise ValueError("external point is not covered by a maximal secant")
    defect = 0
    spectrum = Counter()
    for line, degree in enumerate(line_degrees):
        selected = line in arc_set
        delta = degree - (3 if selected else 1)
        defect += delta * (delta - 1) // 2
        spectrum[(int(selected), degree)] += 1
    if defect != 19:
        raise ValueError("defect identity mismatch")
    return {
        "defect": defect,
        "line_type_spectrum": {
            f"{selected}:{degree}": count
            for (selected, degree), count in sorted(spectrum.items())
        },
        "selected_incidence_sum": sum(
            line_degrees[line] for line in range(len(line_degrees)) if line in arc_set
        ),
        "pair_sum": sum(degree * (degree - 1) // 2 for degree in line_degrees),
    }


def seeded_maximal_prefix(plane, depth: int) -> list[int]:
    """Match the Rust prefix probe's deterministic cap-feasible point order."""

    degrees = [0] * len(plane.points)
    selected = set()
    result = []
    candidate = 0
    while len(result) != depth:
        if candidate not in selected and all(
            degrees[line] < 9 for line in plane.through_point[candidate]
        ):
            selected.add(candidate)
            result.append(candidate)
            for line in plane.through_point[candidate]:
                degrees[line] += 1
            candidate = (candidate + 37) % len(plane.points)
        else:
            candidate = (candidate + 1) % len(plane.points)
    return result


def build_model(
    *,
    normalize: bool = True,
    histogram: bool = True,
    maximal_first: bool = False,
    forced_maximal_prefix_depth: int = 0,
    frame_normalize: bool = False,
):
    plane = ternary_projective_plane(27)
    model = cp_model.CpModel()
    point_count = len(plane.points)
    arc = [model.new_bool_var(f"a_{line}") for line in range(point_count)]
    maximal = [model.new_bool_var(f"m_{point}") for point in range(point_count)]
    model.add(sum(arc) == 279)
    model.add(sum(maximal) == 54)
    for point in seeded_maximal_prefix(plane, forced_maximal_prefix_depth):
        model.add(maximal[point] == 1)

    for point, incident_lines in enumerate(plane.through_point):
        degree = sum(arc[line] for line in incident_lines)
        model.add(degree <= 18 + maximal[point])
        model.add(degree >= 19 * maximal[point])

    allowed = []
    for selected in (1, 0):
        for degree in range(29):
            if not selected and degree == 0:
                continue
            delta = degree - (3 if selected else 1)
            defect = delta * (delta - 1) // 2
            if defect <= 19:
                allowed.append(
                    (
                        selected,
                        degree,
                        defect,
                        selected * degree,
                        degree * (degree - 1) // 2,
                    )
                )
    type_columns = [[] for _ in allowed]
    line_degrees = []
    line_centered = []
    defect_variables = []
    internal_degrees = []
    pair_counts = []
    for line, incident_points in enumerate(plane.on_line):
        degree = model.new_int_var(0, 28, f"d_{line}")
        model.add(degree == sum(maximal[point] for point in incident_points))
        line_degrees.append(degree)
        if histogram:
            line_types = [
                model.new_bool_var(f"t_{line}_{kind}") for kind in range(len(allowed))
            ]
            model.add_exactly_one(line_types)
            model.add(arc[line] == sum(line_types[:10]))
            model.add(
                degree
                == sum(row[1] * variable for row, variable in zip(allowed, line_types))
            )
            centered = model.new_int_var(-6, 4, f"u_{line}")
            model.add(
                centered
                == sum(
                    (1 + 3 * row[0] - row[1]) * variable
                    for row, variable in zip(allowed, line_types)
                )
            )
            line_centered.append(centered)
            for column, variable in zip(type_columns, line_types):
                column.append(variable)
        else:
            defect = model.new_int_var(0, 19, f"e_{line}")
            internal_degree = model.new_int_var(0, 9, f"i_{line}")
            pair_count = model.new_int_var(0, 36, f"p_{line}")
            model.add_allowed_assignments(
                (arc[line], degree, defect, internal_degree, pair_count), allowed
            )
            defect_variables.append(defect)
            internal_degrees.append(internal_degree)
            pair_counts.append(pair_count)
    if histogram:
        type_counts = [
            model.new_int_var(0, point_count, f"n_{kind}") for kind in range(len(allowed))
        ]
        for count, column in zip(type_counts, type_columns):
            model.add(count == sum(column))
        histogram_rows = []
        for internal, external in gf27_q27_t54_histogram_pairs():
            histogram_rows.append(tuple(internal[:10]) + tuple(external[:7]))
        model.add_allowed_assignments(type_counts, histogram_rows)
        centered_counts = [
            model.new_int_var(0, point_count, f"u_{value}") for value in range(-6, 5)
        ]
        for value, count in zip(range(-6, 5), centered_counts):
            model.add(
                count
                == sum(
                    type_counts[kind]
                    for kind, row in enumerate(allowed)
                    if 1 + 3 * row[0] - row[1] == value
                )
            )
        model.add_allowed_assignments(centered_counts, gf27_q27_t54_centered_spectra())
    else:
        model.add(sum(defect_variables) == 19)
        model.add(sum(internal_degrees) == 1_026)
        model.add(sum(pair_counts) == 1_431)

    for point, incident_lines in enumerate(plane.through_point):
        model.add(
            sum(line_degrees[line] for line in incident_lines)
            == 54 + 27 * maximal[point]
        )
        if histogram:
            model.add(
                sum(line_centered[line] for line in incident_lines)
                == 3 * sum(arc[line] for line in incident_lines)
                - 27 * maximal[point]
                - 26
            )

    if normalize:
        anchor = plane.points.index((0, 0, 1))
        first_line, second_line = plane.through_point[anchor][:2]
        second_maximal = next(
            point for point in plane.on_line[first_line] if point != anchor
        )
        model.add(maximal[anchor] == 1)
        model.add(arc[first_line] == 1)
        model.add(maximal[second_maximal] == 1)
        model.add(arc[second_line] == 0)
        if frame_normalize:
            third_maximal = plane.points.index((1, 0, 0))
            model.add(maximal[third_maximal] == 1)
    if maximal_first:
        model.add_decision_strategy(
            maximal,
            cp_model.CHOOSE_FIRST,
            cp_model.SELECT_MAX_VALUE,
        )
    return plane, model, arc, maximal


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--time-limit", type=float, default=60.0)
    parser.add_argument("--workers", type=int, default=1)
    parser.add_argument("--no-normalize", action="store_true")
    parser.add_argument("--no-histogram", action="store_true")
    parser.add_argument("--maximal-first", action="store_true")
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--forced-maximal-prefix-depth", type=int, default=0)
    parser.add_argument("--frame-normalize", action="store_true")
    args = parser.parse_args()
    if not 0 <= args.forced_maximal_prefix_depth <= 54:
        parser.error("--forced-maximal-prefix-depth must be between 0 and 54")
    plane, model, arc, maximal = build_model(
        normalize=not args.no_normalize,
        histogram=not args.no_histogram,
        maximal_first=args.maximal_first,
        forced_maximal_prefix_depth=args.forced_maximal_prefix_depth,
        frame_normalize=args.frame_normalize,
    )
    validation_error = model.validate()
    if validation_error:
        raise RuntimeError(validation_error)
    if args.check_only:
        print(
            json.dumps(
                {
                    "schema": "gf27-q27-t54-defect-cpsat-v9",
                    "status": "MODEL_VALID",
                    "point_count": len(plane.points),
                    "variables": len(model.proto.variables),
                    "constraints": len(model.proto.constraints),
                    "histogram_pairs": 3_435,
                    "forced_maximal_prefix_depth": args.forced_maximal_prefix_depth,
                    "frame_normalized": not args.no_normalize and args.frame_normalize,
                },
                indent=2,
                sort_keys=True,
            )
        )
        return
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = args.time_limit
    solver.parameters.num_workers = args.workers
    solver.parameters.random_seed = 0
    if args.maximal_first:
        solver.parameters.search_branching = cp_model.FIXED_SEARCH
    status = solver.solve(model)
    result = {
        "schema": "gf27-q27-t54-defect-cpsat-v9",
        "histogram_compiled": not args.no_histogram,
        "status": solver.status_name(status),
        "normalized": not args.no_normalize,
        "workers": args.workers,
        "wall_time_seconds": solver.wall_time,
        "branches": solver.num_branches,
        "conflicts": solver.num_conflicts,
        "deterministic_time": solver.response_proto.deterministic_time,
        "maximal_first": args.maximal_first,
        "point_count": len(plane.points),
        "forced_maximal_prefix_depth": args.forced_maximal_prefix_depth,
        "frame_normalized": not args.no_normalize and args.frame_normalize,
    }
    if status in (cp_model.FEASIBLE, cp_model.OPTIMAL):
        arc_lines = [index for index, variable in enumerate(arc) if solver.value(variable)]
        maximal_points = [
            index for index, variable in enumerate(maximal) if solver.value(variable)
        ]
        result["arc_lines"] = arc_lines
        result["maximal_points"] = maximal_points
        result["verification"] = verify_solution(plane, arc_lines, maximal_points)
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
