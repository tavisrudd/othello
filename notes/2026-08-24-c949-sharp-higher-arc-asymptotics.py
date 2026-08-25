#!/usr/bin/env python3
"""Reproducible finite-geometry experiments for C949.

The first experiment maximizes a minimal t-fold blocking set in PG(2,q).
Its complement is a smallest complete (k,q+1-t)-arc.  The emitted LP uses
binary witness variables for essential t-secants and a projectively harmless
flag normalization.
"""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
import itertools
import json
import math
from pathlib import Path


IRREDUCIBLE = {
    9: (1, 0, 1),       # x^2 + 1 over F_3
    27: (1, 2, 0, 1),  # x^3 - x + 1 over F_3
}


class Field:
    def __init__(self, q: int) -> None:
        if q not in IRREDUCIBLE:
            raise ValueError(f"unsupported field order {q}")
        self.q = q
        self.modulus = IRREDUCIBLE[q]
        self.degree = len(self.modulus) - 1

    def coeffs(self, value: int) -> list[int]:
        out = []
        for _ in range(self.degree):
            out.append(value % 3)
            value //= 3
        return out

    def encode(self, coeffs: list[int]) -> int:
        value = 0
        place = 1
        for coeff in coeffs[: self.degree]:
            value += (coeff % 3) * place
            place *= 3
        return value

    def add(self, left: int, right: int) -> int:
        a = self.coeffs(left)
        b = self.coeffs(right)
        return self.encode([(x + y) % 3 for x, y in zip(a, b)])

    def neg(self, value: int) -> int:
        return self.encode([(-x) % 3 for x in self.coeffs(value)])

    def mul(self, left: int, right: int) -> int:
        a = self.coeffs(left)
        b = self.coeffs(right)
        product = [0] * (2 * self.degree - 1)
        for i, x in enumerate(a):
            for j, y in enumerate(b):
                product[i + j] = (product[i + j] + x * y) % 3
        for power in range(len(product) - 1, self.degree - 1, -1):
            lead = product[power] % 3
            if lead:
                shift = power - self.degree
                for i in range(self.degree):
                    product[shift + i] = (
                        product[shift + i] - lead * self.modulus[i]
                    ) % 3
        return self.encode(product)

    def pow(self, value: int, exponent: int) -> int:
        result = 1
        while exponent:
            if exponent & 1:
                result = self.mul(result, value)
            value = self.mul(value, value)
            exponent >>= 1
        return result

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return self.pow(value, self.q - 2)


def projective_points(field: Field) -> list[tuple[int, int, int]]:
    q = field.q
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


def dot(field: Field, point: tuple[int, int, int], line: tuple[int, int, int]) -> int:
    total = 0
    for x, a in zip(point, line):
        total = field.add(total, field.mul(x, a))
    return total


def incidence(q: int) -> tuple[list[tuple[int, int, int]], list[list[int]], list[list[int]]]:
    field = Field(q)
    points = projective_points(field)
    lines = projective_points(field)
    on_line = [[i for i, point in enumerate(points) if dot(field, point, line) == 0]
               for line in lines]
    through_point = [[] for _ in points]
    for line_index, members in enumerate(on_line):
        for point_index in members:
            through_point[point_index].append(line_index)
    return points, on_line, through_point


def normalize_projective(field: Field, vector: tuple[int, int, int]) -> tuple[int, int, int]:
    for coordinate in vector:
        if coordinate:
            inverse = field.inv(coordinate)
            return tuple(field.mul(inverse, value) for value in vector)  # type: ignore[return-value]
    raise ValueError("zero vector is not projective")


def matrix_vector(field: Field, matrix: list[list[int]], vector: tuple[int, int, int]) -> tuple[int, int, int]:
    return tuple(
        sum_field(field, [field.mul(matrix[row][column], vector[column]) for column in range(3)])
        for row in range(3)
    )  # type: ignore[return-value]


def sum_field(field: Field, values: list[int]) -> int:
    total = 0
    for value in values:
        total = field.add(total, value)
    return total


def matrix_multiply(field: Field, left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [[sum_field(field, [field.mul(left[i][k], right[k][j]) for k in range(3)])
             for j in range(3)] for i in range(3)]


def matrix_inverse(field: Field, matrix: list[list[int]]) -> list[list[int]] | None:
    augmented = [row[:] + [1 if i == j else 0 for j in range(3)]
                 for i, row in enumerate(matrix)]
    for column in range(3):
        pivot = next((row for row in range(column, 3) if augmented[row][column]), None)
        if pivot is None:
            return None
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        inverse = field.inv(augmented[column][column])
        augmented[column] = [field.mul(inverse, value) for value in augmented[column]]
        for row in range(3):
            if row == column or not augmented[row][column]:
                continue
            factor = augmented[row][column]
            augmented[row] = [field.add(value, field.neg(field.mul(factor, pivot_value)))
                              for value, pivot_value in zip(augmented[row], augmented[column])]
    return [row[3:] for row in augmented]


def matrix_from_columns(columns: list[tuple[int, int, int]]) -> list[list[int]]:
    return [[columns[column][row] for column in range(3)] for row in range(3)]


def field_trace(field: Field, value: int) -> int:
    total = value
    frobenius = value
    for _ in range(1, field.degree):
        frobenius = field.pow(frobenius, 3)
        total = field.add(total, frobenius)
    return total


def symmetry_orbits(q: int, symmetry: str) -> list[list[int]]:
    field = Field(q)
    points = projective_points(field)
    point_index = {point: index for index, point in enumerate(points)}

    def translation_x(amount: int):
        return lambda point: (field.add(point[0], field.mul(amount, point[2])), point[1], point[2])

    def translation_y(amount: int):
        return lambda point: (point[0], field.add(point[1], field.mul(amount, point[2])), point[2])

    if symmetry in ("trace-x", "trace-xy"):
        kernel = [value for value in range(q) if field_trace(field, value) == 0]
        first = next(value for value in kernel if value)
        first_span = {0, first, field.add(first, first)}
        second = next(value for value in kernel if value not in first_span)
        actions = [translation_x(first), translation_x(second)]
        if symmetry == "trace-xy":
            actions += [translation_y(first), translation_y(second)]
    elif symmetry == "scalar-13":
        primitive = next(value for value in range(2, q)
                         if field.pow(value, 13) != 1 and field.pow(value, 2) != 1)
        scalar = field.pow(primitive, 2)
        actions = [lambda point: (field.mul(scalar, point[0]),
                                  field.mul(scalar, point[1]), point[2])]
    elif symmetry == "frobenius":
        actions = [lambda point: tuple(field.pow(value, 3) for value in point)]
    else:
        raise ValueError(f"unsupported symmetry {symmetry}")

    permutations = []
    for action in actions:
        permutations.append([
            point_index[normalize_projective(field, action(point))]
            for point in points
        ])
    unseen = set(range(len(points)))
    orbits = []
    while unseen:
        seed = min(unseen)
        orbit = {seed}
        frontier = [seed]
        while frontier:
            current = frontier.pop()
            for permutation in permutations:
                image = permutation[current]
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        ordered = sorted(orbit)
        orbits.append(ordered)
        unseen.difference_update(orbit)
    return orbits


def linear_sum(terms: list[tuple[int, str]]) -> str:
    pieces = []
    for coefficient, variable in terms:
        sign = "+" if coefficient >= 0 else "-"
        magnitude = abs(coefficient)
        factor = "" if magnitude == 1 else f"{magnitude} "
        pieces.append(f" {sign} {factor}{variable}")
    return "".join(pieces).lstrip(" +") or "0"


def emit_blocking_lp(q: int, t: int, output: Path) -> None:
    points, on_line, through_point = incidence(q)
    if not (1 <= t <= q + 1):
        raise ValueError("t must lie between 1 and q+1")
    lines = ["Maximize", " obj: " + linear_sum([(1, f"x_{p}") for p in range(len(points))]), "Subject To"]
    for ell, members in enumerate(on_line):
        lines.append(f" block_{ell}: " + linear_sum([(1, f"x_{p}") for p in members]) + f" >= {t}")
    for ell, members in enumerate(on_line):
        terms = [(1, f"x_{r}") for r in members] + [(q + 1 - t, f"z_{ell}")]
        lines.append(f" tangent_exact_{ell}: " + linear_sum(terms) + f" <= {q + 1}")
        lines.append(f" tangent_converse_{ell}: " + linear_sum([(1, f"x_{r}") for r in members] + [(1, f"z_{ell}")]) + f" >= {t + 1}")
    for p, incident in enumerate(through_point):
        lines.append(f" essential_{p}: " + linear_sum([(-1, f"x_{p}")] + [(1, f"z_{ell}") for ell in incident]) + " >= 0")

    # Bishnoi--Mattheus--Schillewaert, Theorem 1.1.
    discriminant = 4 * t * q - (3 * t + 1) * (t - 1)
    bms_bound = math.floor(q * math.sqrt(discriminant) / 2 + (t - 1) * q / 2 + t)
    lines.append(" bms_bound: " + linear_sum([(1, f"x_{p}") for p in range(len(points))]) + f" <= {bms_bound}")

    # Every nonempty minimal blocking set has an incident (point, essential
    # t-secant) flag, and PGL(3,q) is transitive on flags.
    normalized_point = points.index((1, 0, 0))
    normalized_line = points.index((0, 1, 0))
    assert normalized_point in on_line[normalized_line]
    normalized_members = on_line[normalized_line]
    fixed_members = normalized_members[:t]
    assert normalized_point in fixed_members
    for point_index in normalized_members:
        value = 1 if point_index in fixed_members else 0
        lines.append(f" normalize_secant_point_{point_index}: x_{point_index} = {value}")
    lines.append("Binary")
    lines.extend(f" x_{p}" for p in range(len(points)))
    lines.extend(f" z_{ell}" for ell in range(len(on_line)))
    lines.append("End")
    output.write_text("\n".join(lines) + "\n")


def parse_highs_solution(path: Path) -> dict[str, float]:
    values: dict[str, float] = {}
    in_columns = False
    for raw_line in path.read_text().splitlines():
        line = raw_line.strip()
        if line.startswith("# Columns "):
            in_columns = True
            continue
        if in_columns and line.startswith("#"):
            break
        if in_columns and line:
            name, value = line.split()
            values[name] = float(value)
    if not values:
        raise ValueError(f"no HiGHS column solution found in {path}")
    return values


def make_certificate(q: int, t: int, solution: Path, output: Path) -> None:
    values = parse_highs_solution(solution)
    selected = sorted(int(name[2:]) for name, value in values.items()
                      if name.startswith("x_") and value > 0.5)
    certificate = {
        "schema": "c949-minimal-multiple-blocking-v1",
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "blocking_multiplicity": t,
        "blocking_set_point_indices": selected,
        "blocking_set_size": len(selected),
        "complement_arc_size": q * q + q + 1 - len(selected),
        "complement_arc_max_line_intersection": q + 1 - t,
    }
    output.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")


def solve_cpsat(q: int, t: int, output: Path, seconds: float, workers: int,
                required_size: int | None, required_tangents: int | None,
                repeated_degree: int | None) -> None:
    from ortools.sat.python import cp_model

    points, on_line, through_point = incidence(q)
    model = cp_model.CpModel()
    chosen = [model.new_bool_var(f"x_{p}") for p in range(len(points))]
    line_sums = []
    for ell, members in enumerate(on_line):
        line_sum = model.new_int_var(t, q + 1, f"line_sum_{ell}")
        model.add(line_sum == sum(chosen[p] for p in members))
        line_sums.append(line_sum)
    tangents = [model.new_bool_var(f"z_{ell}") for ell in range(len(on_line))]
    for ell, tangent in enumerate(tangents):
        model.add(line_sums[ell] == t).only_enforce_if(tangent)
        model.add(line_sums[ell] >= t + 1).only_enforce_if(tangent.Not())
    for p, incident in enumerate(through_point):
        model.add(chosen[p] <= sum(tangents[ell] for ell in incident))
    discriminant = 4 * t * q - (3 * t + 1) * (t - 1)
    bms_bound = math.floor(q * math.sqrt(discriminant) / 2 + (t - 1) * q / 2 + t)
    blocking_size = model.new_int_var(t, bms_bound, "blocking_size")
    tangent_count = model.new_int_var(1, len(on_line), "tangent_count")
    model.add(blocking_size == sum(chosen))
    model.add(tangent_count == sum(tangents))

    def minimum_pair_sum(items: int, degree_sum: int, minimum_degree: int) -> int:
        if degree_sum < items * minimum_degree:
            return 10**9
        quotient, remainder = divmod(degree_sum, items)
        return ((items - remainder) * quotient * (quotient - 1) // 2
                + remainder * quotient * (quotient + 1) // 2)

    total_points = q * q + q + 1
    arc_intersection = q + 1 - t
    allowed_size_tangents = []
    for size in range(t, bms_bound + 1):
        arc_size = total_points - size
        for tangent_total in range(1, total_points + 1):
            if t * tangent_total < size:
                continue
            if tangent_total * t * (t - 1) > size * (size - 1):
                continue
            if tangent_total * arc_intersection * (arc_intersection - 1) > arc_size * (arc_size - 1):
                continue
            internal_pairs = minimum_pair_sum(arc_size, arc_intersection * tangent_total, 0)
            external_pairs = minimum_pair_sum(size, t * tangent_total, 1)
            if internal_pairs + external_pairs <= tangent_total * (tangent_total - 1) // 2:
                allowed_size_tangents.append((size, tangent_total))
    model.add_allowed_assignments([blocking_size, tangent_count], allowed_size_tangents)

    degree_pair_rows = [(degree, degree * (degree - 1) // 2)
                        for degree in range(q + 2)]
    degree_pair_terms = []
    external_degree_terms = []
    external_pair_terms = []
    degrees = []
    for p, incident in enumerate(through_point):
        degree = model.new_int_var(0, q + 1, f"tangent_degree_{p}")
        pair_term = model.new_int_var(0, q * (q + 1) // 2, f"tangent_pairs_{p}")
        external_degree = model.new_int_var(0, q + 1, f"external_tangent_degree_{p}")
        external_pair = model.new_int_var(0, q * (q + 1) // 2, f"external_tangent_pairs_{p}")
        model.add(degree == sum(tangents[ell] for ell in incident))
        model.add_allowed_assignments([degree, pair_term], degree_pair_rows)
        model.add_allowed_assignments(
            [chosen[p], degree, external_degree, external_pair],
            [(is_chosen, degree_value, degree_value if is_chosen else 0,
              pair_value if is_chosen else 0)
             for is_chosen in (0, 1)
             for degree_value, pair_value in degree_pair_rows],
        )
        degrees.append(degree)
        degree_pair_terms.append(pair_term)
        external_degree_terms.append(external_degree)
        external_pair_terms.append(external_pair)
    tangent_pair_total = model.new_int_var(0, total_points * (total_points - 1) // 2,
                                           "tangent_pair_total")
    model.add_allowed_assignments(
        [tangent_count, tangent_pair_total],
        [(count, count * (count - 1) // 2) for count in range(1, total_points + 1)],
    )
    model.add(sum(degree_pair_terms) == tangent_pair_total)
    model.add(sum(external_degree_terms) == t * tangent_count)

    normalized_line = points.index((0, 1, 0))
    normalized_members = on_line[normalized_line]
    fixed_members = set(normalized_members[:t])
    for point_index in normalized_members:
        model.add(chosen[point_index] == (1 if point_index in fixed_members else 0))
    if required_size == 53:
        allowed_tangents = [count for size, count in allowed_size_tangents if size == 53]
        if allowed_tangents != [18]:
            raise AssertionError(f"unexpected q=9,size=53 tangent counts: {allowed_tangents}")
        repeated_point = normalized_members[0]
        second_tangent = points.index((0, 0, 1))
        assert repeated_point in on_line[second_tangent]
        model.add(degrees[repeated_point] == 2)
        model.add(tangents[second_tangent] == 1)
    elif required_size in (50, 52):
        repeated_point = normalized_members[0]
        second_tangent = points.index((0, 0, 1))
        assert repeated_point in on_line[second_tangent]
        if repeated_degree is None:
            model.add(degrees[repeated_point] >= 2)
        else:
            model.add(degrees[repeated_point] == repeated_degree)
        model.add(tangents[second_tangent] == 1)
        for point_index in range(len(points)):
            model.add(degrees[point_index] <= degrees[repeated_point]
                      + (q + 1) * (1 - chosen[point_index]))
    if required_size is None:
        model.maximize(blocking_size)
    else:
        model.add(blocking_size == required_size)
    if required_tangents is not None:
        model.add(tangent_count == required_tangents)

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    status_name = solver.status_name(status)
    if status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        output.write_text(json.dumps({
            "schema": "c949-minimal-multiple-blocking-decision-v1",
            "solver": "OR-Tools CP-SAT",
            "solver_version": __import__("ortools").__version__,
            "solver_status": status_name,
            "field_order": q,
            "blocking_multiplicity": t,
            "required_blocking_set_size": required_size,
            "required_tangent_count": required_tangents,
            "normalized_maximum_external_degree": repeated_degree,
            "search": {
                "random_seed": 949,
                "workers": workers,
                "time_limit_seconds": seconds,
            },
        }, indent=2, sort_keys=True) + "\n")
        return
    selected = [p for p in range(len(points)) if solver.value(chosen[p])]
    certificate = {
        "schema": "c949-minimal-multiple-blocking-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": status_name,
        "solver_objective_bound": int(round(solver.best_objective_bound)),
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "blocking_multiplicity": t,
        "blocking_set_point_indices": selected,
        "blocking_set_size": len(selected),
        "essential_secant_count": solver.value(tangent_count),
        "complement_arc_size": q * q + q + 1 - len(selected),
        "complement_arc_max_line_intersection": q + 1 - t,
        "normalization": {
            "essential_line_index": normalized_line,
            "points_on_essential_line": normalized_members,
            "selected_points_on_essential_line": sorted(fixed_members),
        },
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
            "required_blocking_set_size": required_size,
            "required_tangent_count": required_tangents,
            "normalized_maximum_external_degree": repeated_degree,
        },
    }
    output.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")


def check_certificate(path: Path) -> None:
    certificate = json.loads(path.read_text())
    q = certificate["field_order"]
    t = certificate["blocking_multiplicity"]
    points, on_line, through_point = incidence(q)
    selected = set(certificate["blocking_set_point_indices"])
    if len(selected) != certificate["blocking_set_size"]:
        raise ValueError("blocking-set size mismatch")
    intersections = [len(selected.intersection(members)) for members in on_line]
    if min(intersections) < t:
        raise ValueError("not a t-fold blocking set")
    for p in selected:
        if not any(intersections[ell] == t for ell in through_point[p]):
            raise ValueError(f"point {p} has no essential t-secant")
    expected_total = q * q + q + 1
    if certificate["complement_arc_size"] != expected_total - len(selected):
        raise ValueError("complement size mismatch")
    if certificate["complement_arc_max_line_intersection"] != q + 1 - t:
        raise ValueError("complement line-intersection mismatch")
    print(json.dumps({
        "checked": True,
        "points": len(points),
        "blocking_set_size": len(selected),
        "minimum_line_intersection": min(intersections),
        "maximum_line_intersection": max(intersections),
        "essential_secants": sum(value == t for value in intersections),
        "line_intersection_spectrum": dict(sorted(Counter(intersections).items())),
    }, sort_keys=True))


def audit_two_character(q: int, size_min: int, size_max: int, output: Path) -> None:
    total_points = q * q + q + 1
    candidates = []
    characteristic_powers = {1}
    power = 3
    while power <= q:
        characteristic_powers.add(power)
        power *= 3
    for size in range(size_min, size_max + 1):
        for low in range(q + 1):
            for high in range(low + 1, q + 2):
                numerator = size * (q + 1) - low * total_points
                if numerator % (high - low):
                    continue
                high_lines = numerator // (high - low)
                low_lines = total_points - high_lines
                if low_lines < 0 or high_lines < 0:
                    continue
                line_pairs = (low_lines * low * (low - 1)
                              + high_lines * high * (high - 1))
                if line_pairs != size * (size - 1):
                    continue
                candidates.append({
                    "point_set_size": size,
                    "line_intersections": [low, high],
                    "line_counts": [low_lines, high_lines],
                    "intersection_gap_is_power_of_3": high - low in characteristic_powers,
                    "is_blocking": low >= 1,
                })
    output.write_text(json.dumps({
        "schema": "c949-two-character-parameter-audit-v1",
        "field_order": q,
        "point_set_size_range": [size_min, size_max],
        "candidate_count": len(candidates),
        "candidates": candidates,
    }, indent=2, sort_keys=True) + "\n")


def solve_symmetry_cpsat(q: int, t: int, symmetry: str, output: Path,
                         seconds: float, workers: int) -> None:
    from ortools.sat.python import cp_model

    points, on_line, through_point = incidence(q)
    orbits = symmetry_orbits(q, symmetry)
    orbit_of = [0] * len(points)
    for orbit_index, orbit in enumerate(orbits):
        for point in orbit:
            orbit_of[point] = orbit_index
    model = cp_model.CpModel()
    chosen_orbit = [model.new_bool_var(f"orbit_{index}") for index in range(len(orbits))]
    chosen = [chosen_orbit[orbit_of[point]] for point in range(len(points))]
    line_sums = []
    tangents = []
    for ell, members in enumerate(on_line):
        line_sum = model.new_int_var(t, q + 1, f"line_sum_{ell}")
        model.add(line_sum == sum(chosen[p] for p in members))
        tangent = model.new_bool_var(f"tangent_{ell}")
        model.add(line_sum == t).only_enforce_if(tangent)
        model.add(line_sum >= t + 1).only_enforce_if(tangent.Not())
        line_sums.append(line_sum)
        tangents.append(tangent)
    for p, incident in enumerate(through_point):
        model.add(chosen[p] <= sum(tangents[ell] for ell in incident))
    discriminant = 4 * t * q - (3 * t + 1) * (t - 1)
    bms_bound = math.floor(q * math.sqrt(discriminant) / 2 + (t - 1) * q / 2 + t)
    blocking_size = sum(len(orbit) * chosen_orbit[index]
                        for index, orbit in enumerate(orbits))
    model.add(blocking_size <= bms_bound)
    model.maximize(blocking_size)

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    status_name = solver.status_name(status)
    base = {
        "schema": "c949-symmetry-constrained-blocking-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": status_name,
        "solver_objective_bound": int(round(solver.best_objective_bound)),
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "blocking_multiplicity": t,
        "symmetry": symmetry,
        "orbit_sizes": [len(orbit) for orbit in orbits],
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
        },
    }
    if status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        output.write_text(json.dumps(base, indent=2, sort_keys=True) + "\n")
        return
    selected = [p for p in range(len(points)) if solver.value(chosen[p])]
    base.update({
        "blocking_set_point_indices": selected,
        "blocking_set_size": len(selected),
        "complement_arc_size": q * q + q + 1 - len(selected),
        "complement_arc_max_line_intersection": q + 1 - t,
        "essential_secant_count": sum(solver.value(tangent) for tangent in tangents),
    })
    output.write_text(json.dumps(base, indent=2, sort_keys=True) + "\n")


def solve_five_character_core(q: int, symmetry: str, output: Path,
                              seconds: float, workers: int) -> None:
    """Search the q=3^h five-character dual-core template and its primal lift."""
    from ortools.sat.python import cp_model

    if q not in (9, 27):
        raise ValueError("the current exact field implementation supports q=9 and q=27")
    points, on_line, through_point = incidence(q)
    if symmetry == "none":
        orbits = [[point] for point in range(len(points))]
    else:
        orbits = symmetry_orbits(q, symmetry)
    orbit_of = [0] * len(points)
    for orbit_index, orbit in enumerate(orbits):
        for point in orbit:
            orbit_of[point] = orbit_index

    core_size = 2 * q + 1
    arc_intersection = 2 * q // 3 + 1
    arc_size = q * q // 3 + 4 * q // 3
    line_type_counts = {
        1: (2 * q * q - 3 * q + 6) // 3,
        2: 2 * q // 3 - 1,
        3: 3 * q - 3,
        4: (q * q - 6 * q + 15) // 3,
        5: q // 3 - 2,
    }
    selected_type_counts = {
        1: 0,
        2: 0,
        3: line_type_counts[3],
        4: line_type_counts[4],
        5: line_type_counts[5],
    }
    assert sum(line_type_counts.values()) == len(points)
    assert sum(selected_type_counts.values()) == arc_size
    assert sum(degree * count for degree, count in selected_type_counts.items()) == (
        core_size * arc_intersection
    )

    model = cp_model.CpModel()
    chosen_orbit = [model.new_bool_var(f"core_orbit_{index}")
                    for index in range(len(orbits))]
    core = [chosen_orbit[orbit_of[point]] for point in range(len(points))]
    model.add(sum(len(orbit) * chosen_orbit[index]
                  for index, orbit in enumerate(orbits)) == core_size)

    line_types = []
    selected_types = []
    selected_lines = []
    for line, members in enumerate(on_line):
        intersection = model.new_int_var(1, 5, f"core_line_sum_{line}")
        model.add(intersection == sum(core[point] for point in members))
        types = [model.new_bool_var(f"core_line_{line}_type_{degree}")
                 for degree in range(1, 6)]
        model.add_exactly_one(types)
        for degree, type_variable in enumerate(types, start=1):
            model.add(intersection == degree).only_enforce_if(type_variable)
        selected = model.new_bool_var(f"arc_point_{line}")
        selected_as_type = [model.new_bool_var(f"arc_point_{line}_type_{degree}")
                            for degree in range(1, 6)]
        model.add(sum(selected_as_type) == selected)
        for selected_type, type_variable in zip(selected_as_type, types):
            model.add(selected_type <= type_variable)
        line_types.append(types)
        selected_types.append(selected_as_type)
        selected_lines.append(selected)

    for degree in range(1, 6):
        model.add(sum(types[degree - 1] for types in line_types) == line_type_counts[degree])
        model.add(sum(types[degree - 1] for types in selected_types)
                  == selected_type_counts[degree])

    selected_degrees = []
    for point, incident in enumerate(through_point):
        degree = model.new_int_var(0, arc_intersection, f"selected_degree_{point}")
        model.add(degree == sum(selected_lines[line] for line in incident))
        model.add(degree == arc_intersection).only_enforce_if(core[point])
        selected_degrees.append(degree)

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    status_name = solver.status_name(status)
    result = {
        "schema": "c949-five-character-core-lift-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": status_name,
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "symmetry_on_dual_core": symmetry,
        "dual_core_size": core_size,
        "dual_core_line_type_counts": line_type_counts,
        "selected_line_type_counts": selected_type_counts,
        "arc_intersection": arc_intersection,
        "required_arc_size": arc_size,
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
        },
    }
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        core_points = [point for point in range(len(points)) if solver.value(core[point])]
        arc_points = [line for line in range(len(points)) if solver.value(selected_lines[line])]
        degree_spectrum = Counter(solver.value(degree) for degree in selected_degrees)
        result.update({
            "dual_core_point_indices": core_points,
            "arc_point_indices": arc_points,
            "arc_size": len(arc_points),
            "arc_line_intersection_spectrum": dict(sorted(degree_spectrum.items())),
            "complete": all(
                bool(set(core_points).intersection(on_line[line]))
                for line in set(range(len(points))) - set(arc_points)
            ),
        })
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


def search_five_character_core(q: int, symmetry: str, output: Path,
                               seconds: float, workers: int,
                               fixed_core_points: int | None = None,
                               fixed_line_type_counts: list[int] | None = None,
                               fixed_core_indices: list[int] | None = None,
                               fixed_line_degrees: list[int] | None = None,
                               require_concurrency_cap: bool = False,
                               require_exact_maximal_core: bool = False) -> None:
    """Stage 1: find only the symmetric five-character blocking core."""
    from ortools.sat.python import cp_model

    if q not in (9, 27):
        raise ValueError("the current exact field implementation supports q=9 and q=27")
    if require_exact_maximal_core and not require_concurrency_cap:
        raise ValueError("an exact maximal core requires the concurrency cap")
    points, on_line, through_point = incidence(q)
    orbits = ([[point] for point in range(len(points))] if symmetry == "none"
              else symmetry_orbits(q, symmetry))
    orbit_of = [0] * len(points)
    for orbit_index, orbit in enumerate(orbits):
        for point in orbit:
            orbit_of[point] = orbit_index
    line_type_counts = {
        1: (2 * q * q - 3 * q + 6) // 3,
        2: 2 * q // 3 - 1,
        3: 3 * q - 3,
        4: (q * q - 6 * q + 15) // 3,
        5: q // 3 - 2,
    }
    model = cp_model.CpModel()
    chosen_orbit = [model.new_bool_var(f"core_orbit_{index}")
                    for index in range(len(orbits))]
    core = [chosen_orbit[orbit_of[point]] for point in range(len(points))]
    model.add(sum(len(orbit) * chosen_orbit[index]
                  for index, orbit in enumerate(orbits)) == 2 * q + 1)
    if fixed_core_points is not None:
        model.add(sum(chosen_orbit[index] for index, orbit in enumerate(orbits)
                      if len(orbit) == 1) == fixed_core_points)
    if fixed_core_indices is not None:
        required_fixed = set(fixed_core_indices)
        singleton_points = {orbit[0] for orbit in orbits if len(orbit) == 1}
        if not required_fixed <= singleton_points:
            raise ValueError("fixed core indices must be singleton symmetry orbits")
        for orbit_index, orbit in enumerate(orbits):
            if len(orbit) == 1:
                model.add(chosen_orbit[orbit_index] == (1 if orbit[0] in required_fixed else 0))
    signature_lines: dict[tuple[int, ...], list[int]] = {}
    for line, members in enumerate(on_line):
        orbit_counts = Counter(orbit_of[point] for point in members)
        signature = tuple(orbit_counts.get(index, 0) for index in range(len(orbits)))
        signature_lines.setdefault(signature, []).append(line)
    fixed_line_degree_by_index = None
    if fixed_line_degrees is not None:
        singleton_lines = sorted(equivalent_lines[0] for equivalent_lines in
                                 signature_lines.values() if len(equivalent_lines) == 1)
        if len(fixed_line_degrees) != len(singleton_lines):
            raise ValueError("fixed line degrees must list every singleton line")
        if any(degree not in range(1, 6) for degree in fixed_line_degrees):
            raise ValueError("fixed line degrees must lie between one and five")
        fixed_line_degree_by_index = dict(zip(singleton_lines, fixed_line_degrees))
    high_secants = []
    high_secant_incidences = []
    line_intersections = []
    pair_incidences = []
    two_secants = []
    five_secants = []
    signature_multiplicities = []
    fixed_line_types = []
    signature_index_of_line = [0] * len(on_line)
    for signature_index, (signature, equivalent_lines) in enumerate(sorted(signature_lines.items())):
        for line in equivalent_lines:
            signature_index_of_line[line] = signature_index
        intersection = model.new_int_var(1, 5, f"core_line_sum_{signature_index}")
        model.add(intersection == sum(
            multiplicity * chosen_orbit[orbit_index]
            for orbit_index, multiplicity in enumerate(signature) if multiplicity
        ))
        if fixed_line_degree_by_index is not None and len(equivalent_lines) == 1:
            model.add(intersection == fixed_line_degree_by_index[equivalent_lines[0]])
        high = model.new_bool_var(f"core_line_{signature_index}_is_high")
        model.add(intersection >= 3).only_enforce_if(high)
        model.add(intersection <= 2).only_enforce_if(high.Not())
        high_incidence = model.new_int_var(0, 5, f"core_line_{signature_index}_high_incidence")
        model.add(high_incidence == intersection).only_enforce_if(high)
        model.add(high_incidence == 0).only_enforce_if(high.Not())
        pair_incidence = model.new_int_var(0, 10, f"core_line_{signature_index}_pairs")
        model.add_allowed_assignments(
            [intersection, pair_incidence],
            [(degree, degree * (degree - 1) // 2) for degree in range(1, 6)],
        )
        two = model.new_bool_var(f"core_line_{signature_index}_is_two")
        model.add(intersection == 2).only_enforce_if(two)
        model.add(intersection != 2).only_enforce_if(two.Not())
        five = model.new_bool_var(f"core_line_{signature_index}_is_five")
        model.add(intersection == 5).only_enforce_if(five)
        model.add(intersection <= 4).only_enforce_if(five.Not())
        high_secants.append(high)
        high_secant_incidences.append(high_incidence)
        line_intersections.append(intersection)
        pair_incidences.append(pair_incidence)
        two_secants.append(two)
        five_secants.append(five)
        signature_multiplicities.append(len(equivalent_lines))
        if len(equivalent_lines) == 1 and fixed_line_type_counts is not None:
            types = [model.new_bool_var(f"fixed_line_{signature_index}_type_{degree}")
                     for degree in range(1, 6)]
            model.add_exactly_one(types)
            for degree, type_variable in enumerate(types, start=1):
                model.add(intersection == degree).only_enforce_if(type_variable)
            fixed_line_types.append(types)
    model.add(sum(multiplicity * high for multiplicity, high in
                  zip(signature_multiplicities, high_secants)) == q * q // 3 + 4 * q // 3)
    model.add(sum(multiplicity * incidence for multiplicity, incidence in
                  zip(signature_multiplicities, high_secant_incidences)) ==
              (2 * q + 1) * (2 * q // 3 + 1))
    model.add(sum(multiplicity * incidence for multiplicity, incidence in
                  zip(signature_multiplicities, pair_incidences)) ==
              math.comb(2 * q + 1, 2))
    model.add(sum(multiplicity * five for multiplicity, five in
                  zip(signature_multiplicities, five_secants)) == line_type_counts[5])
    model.add(sum(multiplicity * two for multiplicity, two in
                  zip(signature_multiplicities, two_secants)) == line_type_counts[2])
    for orbit in orbits:
        point = orbit[0]
        model.add(sum(line_intersections[signature_index_of_line[line]]
                      for line in through_point[point]) == 2 * q + 1 + q * core[point])
    if require_concurrency_cap:
        arc_intersection = 2 * q // 3 + 1
        for orbit in orbits:
            point = orbit[0]
            high_degree = sum(high_secants[signature_index_of_line[line]]
                              for line in through_point[point])
            model.add(high_degree <= arc_intersection)
            model.add(high_degree == arc_intersection).only_enforce_if(core[point])
            if require_exact_maximal_core:
                model.add(high_degree <= q // 2).only_enforce_if(core[point].Not())
            core_high_incidence = sum(
                high_secant_incidences[signature_index_of_line[line]]
                for line in through_point[point]
            )
            core_two_degree = sum(two_secants[signature_index_of_line[line]]
                                  for line in through_point[point])
            model.add(core_high_incidence + core_two_degree ==
                      8 * q // 3 + 1).only_enforce_if(core[point])
    if fixed_line_type_counts is not None:
        if len(fixed_line_type_counts) != 5:
            raise ValueError("fixed line type counts must have five entries")
        for degree, required in enumerate(fixed_line_type_counts, start=1):
            model.add(sum(types[degree - 1] for types in fixed_line_types) == required)
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    result = {
        "schema": "c949-five-character-core-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": solver.status_name(status),
        "solver_objective_bound": int(round(solver.best_objective_bound)),
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "symmetry_on_dual_core": symmetry,
        "dual_core_size": 2 * q + 1,
        "dual_core_line_type_counts": line_type_counts,
        "orbit_size_spectrum": dict(sorted(Counter(len(orbit) for orbit in orbits).items())),
        "line_orbit_incidence_signature_count": len(signature_lines),
        "required_fixed_core_points": fixed_core_points,
        "required_fixed_core_indices": fixed_core_indices,
        "required_fixed_line_type_counts": fixed_line_type_counts,
        "required_fixed_line_degrees": fixed_line_degrees,
        "require_concurrency_cap": require_concurrency_cap,
        "require_exact_maximal_core": require_exact_maximal_core,
        "encoded_projective_pair_moment": math.comb(2 * q + 1, 2),
        "encoded_sparse_line_type_counts": {
            "2": line_type_counts[2],
            "5": line_type_counts[5],
        },
        "encoded_point_incidence_identity": "sum_{lines through P} |D intersect line| = |D| + q 1_D(P)",
        "encoded_core_high_degree_equality": require_concurrency_cap,
        "encoded_core_local_secant_identity": require_concurrency_cap,
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
        },
    }
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        core_points = [point for point in range(len(points)) if solver.value(core[point])]
        intersections = [len(set(core_points).intersection(line)) for line in on_line]
        result.update({
            "dual_core_point_indices": core_points,
            "checked_line_type_counts": dict(sorted(Counter(intersections).items())),
        })
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


def lift_five_character_core(core_path: Path, output: Path,
                             seconds: float, workers: int) -> None:
    """Stage 2: select the primal arc lines for a fixed five-character core."""
    from ortools.sat.python import cp_model

    certificate = json.loads(core_path.read_text())
    q = certificate["field_order"]
    core_indices = certificate.get(
        "dual_core_point_indices", certificate.get("degree_seven_point_indices")
    )
    if core_indices is None:
        raise ValueError("input certificate has no dual core point list")
    core = set(core_indices)
    points, on_line, through_point = incidence(q)
    intersections = [len(core.intersection(line)) for line in on_line]
    expected_line_type_counts = {
        1: (2 * q * q - 3 * q + 6) // 3,
        2: 2 * q // 3 - 1,
        3: 3 * q - 3,
        4: (q * q - 6 * q + 15) // 3,
        5: q // 3 - 2,
    }
    if len(core) != 2 * q + 1 or Counter(intersections) != Counter(expected_line_type_counts):
        raise ValueError("input is not the required five-character blocking core")
    selected_type_counts = {
        1: 0,
        2: 0,
        3: expected_line_type_counts[3],
        4: expected_line_type_counts[4],
        5: expected_line_type_counts[5],
    }
    arc_intersection = 2 * q // 3 + 1
    model = cp_model.CpModel()
    selected = [model.new_bool_var(f"arc_point_{line}") for line in range(len(points))]
    for degree in range(1, 6):
        model.add(sum(selected[line] for line, value in enumerate(intersections) if value == degree)
                  == selected_type_counts[degree])
    selected_degrees = []
    for point, incident in enumerate(through_point):
        degree = model.new_int_var(0, arc_intersection, f"arc_line_sum_{point}")
        model.add(degree == sum(selected[line] for line in incident))
        if point in core:
            model.add(degree == arc_intersection)
        selected_degrees.append(degree)
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    result = {
        "schema": "c949-five-character-core-fixed-lift-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": solver.status_name(status),
        "solver_objective_bound": int(round(solver.best_objective_bound)),
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "source_core_certificate": core_path.name,
        "dual_core_point_indices": sorted(core),
        "dual_core_line_type_counts": expected_line_type_counts,
        "selected_line_type_counts": selected_type_counts,
        "arc_intersection": arc_intersection,
        "required_arc_size": sum(selected_type_counts.values()),
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
        },
    }
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        arc = [line for line in range(len(points)) if solver.value(selected[line])]
        degree_spectrum = Counter(solver.value(degree) for degree in selected_degrees)
        result.update({
            "arc_point_indices": arc,
            "arc_size": len(arc),
            "arc_line_intersection_spectrum": dict(sorted(degree_spectrum.items())),
            "complete": min(intersections) >= 1,
        })
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


def extract_selected_secants(certificate_path: Path, output: Path) -> None:
    certificate = json.loads(certificate_path.read_text())
    q = certificate["field_order"]
    t = certificate["blocking_multiplicity"]
    _, on_line, _ = incidence(q)
    blocking_set = set(certificate["blocking_set_point_indices"])
    selected_lines = [ell for ell, members in enumerate(on_line)
                      if len(blocking_set.intersection(members)) == t]
    output.write_text(json.dumps({
        "schema": "c949-selected-secant-family-v1",
        "field_order": q,
        "arc_intersection": q + 1 - t,
        "selected_line_indices": selected_lines,
        "selected_line_count": len(selected_lines),
        "source_blocking_certificate": certificate_path.name,
    }, indent=2, sort_keys=True) + "\n")


def solve_weak_inverse(q: int, arc_intersection: int, family_path: Path,
                       output: Path, seconds: float, workers: int) -> None:
    from ortools.sat.python import cp_model

    family = json.loads(family_path.read_text())
    selected_lines = family["selected_line_indices"]
    points, on_line, _ = incidence(q)
    covered = set().union(*(set(on_line[ell]) for ell in selected_lines))
    model = cp_model.CpModel()
    arc = [model.new_bool_var(f"arc_{p}") for p in range(len(points))]
    for ell, members in enumerate(on_line):
        intersection = sum(arc[p] for p in members)
        if ell in selected_lines:
            model.add(intersection == arc_intersection)
        else:
            model.add(intersection <= arc_intersection)
    for point in set(range(len(points))) - covered:
        model.add(arc[point] == 1)
    arc_size = sum(arc)
    model.minimize(arc_size)

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = seconds
    solver.parameters.num_search_workers = workers
    solver.parameters.random_seed = 949
    status = solver.solve(model)
    status_name = solver.status_name(status)
    result = {
        "schema": "c949-weak-inverse-realization-v1",
        "solver": "OR-Tools CP-SAT",
        "solver_version": __import__("ortools").__version__,
        "solver_status": status_name,
        "solver_objective_bound": int(round(solver.best_objective_bound)),
        "field_order": q,
        "field_modulus_low_to_high": list(IRREDUCIBLE[q]),
        "arc_intersection": arc_intersection,
        "selected_line_indices": selected_lines,
        "selected_line_count": len(selected_lines),
        "uncovered_points_forced_into_arc": sorted(set(range(len(points))) - covered),
        "search": {
            "random_seed": 949,
            "workers": workers,
            "time_limit_seconds": seconds,
        },
    }
    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        selected_points = [p for p in range(len(points)) if solver.value(arc[p])]
        result.update({
            "arc_point_indices": selected_points,
            "arc_size": len(selected_points),
        })
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


def check_weak_inverse(path: Path) -> None:
    certificate = json.loads(path.read_text())
    q = certificate["field_order"]
    arc_intersection = certificate["arc_intersection"]
    selected_lines = set(certificate["selected_line_indices"])
    arc = set(certificate["arc_point_indices"])
    points, on_line, _ = incidence(q)
    intersections = [len(arc.intersection(members)) for members in on_line]
    if max(intersections) != arc_intersection:
        raise ValueError("wrong maximum line intersection")
    if any(intersections[ell] != arc_intersection for ell in selected_lines):
        raise ValueError("a selected line is not maximal")
    covered = set().union(*(set(on_line[ell]) for ell in selected_lines))
    if set(range(len(points))) - arc - covered:
        raise ValueError("an external point is not covered by the selected family")
    print(json.dumps({
        "checked": True,
        "arc_size": len(arc),
        "selected_line_count": len(selected_lines),
        "uncovered_points_forced_into_arc": len(set(range(len(points))) - covered),
    }, sort_keys=True))


def audit_symmetry_orbits(q: int, output: Path) -> None:
    singer_order = q * q + q + 1
    singer_prime = all(singer_order % divisor for divisor in range(2, math.isqrt(singer_order) + 1))
    records = []
    for symmetry in ("trace-x", "trace-xy", "scalar-13", "frobenius"):
        orbits = symmetry_orbits(q, symmetry)
        records.append({
            "symmetry": symmetry,
            "orbit_count": len(orbits),
            "orbit_size_spectrum": dict(sorted(Counter(map(len, orbits)).items())),
        })
    output.write_text(json.dumps({
        "schema": "c949-q27-symmetry-orbits-v1",
        "field_order": q,
        "projective_point_count": q * q + q + 1,
        "singer_group_order": singer_order,
        "singer_group_order_is_prime": singer_prime,
        "symmetries": records,
    }, indent=2, sort_keys=True) + "\n")


def audit_frobenius_fixed_subplane(output: Path) -> None:
    """Reduce a Frobenius-invariant q=27 five-character core on PG(2,3)."""
    q = 27
    field = Field(q)
    points, on_line, _ = incidence(q)
    frobenius_orbits = symmetry_orbits(q, "frobenius")
    fixed_indices = sorted(orbit[0] for orbit in frobenius_orbits if len(orbit) == 1)
    nonfixed_orbits = [orbit for orbit in frobenius_orbits if len(orbit) == 3]
    nonfixed_orbit_of = {point: orbit_index for orbit_index, orbit in
                         enumerate(nonfixed_orbits) for point in orbit}
    point_index = {point: index for index, point in enumerate(points)}
    if len(fixed_indices) != 13:
        raise ValueError("the Frobenius fixed plane should have 13 points")
    fixed_position = {point: position for position, point in enumerate(fixed_indices)}
    fixed_line_masks = []
    for line in fixed_indices:
        mask = sum(1 << fixed_position[point] for point in on_line[line]
                   if point in fixed_position)
        if mask.bit_count() != 4:
            raise ValueError("a fixed subplane line should contain four fixed points")
        fixed_line_masks.append(mask)

    fixed_coords = [points[index] for index in fixed_indices]
    coord_position = {coordinate: position for position, coordinate in enumerate(fixed_coords)}

    def base_normalize(vector: tuple[int, int, int]) -> tuple[int, int, int]:
        first = next(value for value in vector if value)
        inverse = 1 if first == 1 else 2
        return tuple(inverse * value % 3 for value in vector)  # type: ignore[return-value]

    def point_permutation(matrix: tuple[tuple[int, int, int], ...]) -> tuple[int, ...]:
        images = []
        for vector in fixed_coords:
            image = tuple(sum(matrix[row][column] * vector[column]
                              for column in range(3)) % 3 for row in range(3))
            images.append(coord_position[base_normalize(image)])
        return tuple(images)

    generators = [
        ((0, 1, 0), (1, 0, 0), (0, 0, 1)),
        ((1, 0, 0), (0, 0, 1), (0, 1, 0)),
        ((1, 1, 0), (0, 1, 0), (0, 0, 1)),
    ]
    permutations = [point_permutation(matrix) for matrix in generators]
    identity = tuple(range(13))
    identity_matrix = [[1 if row == column else 0 for column in range(3)]
                       for row in range(3)]
    group_matrices = {identity: identity_matrix}
    group_frontier = [identity]
    while group_frontier:
        current = group_frontier.pop()
        current_matrix = group_matrices[current]
        for generator, generator_matrix in zip(permutations, generators):
            product = tuple(generator[current[position]] for position in range(13))
            if product not in group_matrices:
                group_matrices[product] = matrix_multiply(
                    field, [list(row) for row in generator_matrix], current_matrix
                )
                group_frontier.append(product)
    expected_pgl_order = ((3 ** 3 - 1) * (3 ** 3 - 3) * (3 ** 3 - 3 ** 2)) // 2
    if len(group_matrices) != expected_pgl_order:
        raise ValueError("fixed-subplane generators do not generate PGL(3,3)")
    generated_group = set(group_matrices)

    def permute_mask(mask: int, permutation: tuple[int, ...]) -> int:
        return sum(1 << permutation[position] for position in range(13)
                   if mask & (1 << position))

    orbit_representative: dict[int, int] = {}
    orbit_count = 0
    for seed in range(1 << 13):
        if seed in orbit_representative:
            continue
        orbit = {seed}
        frontier = [seed]
        while frontier:
            current = frontier.pop()
            for permutation in permutations:
                image = permute_mask(current, permutation)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        representative = min(orbit)
        for mask in orbit:
            orbit_representative[mask] = representative
        orbit_count += 1

    target = {
        1: (2 * q * q - 3 * q + 6) // 3,
        2: 2 * q // 3 - 1,
        3: 3 * q - 3,
        4: (q * q - 6 * q + 15) // 3,
        5: q // 3 - 2,
    }
    aggregate_patterns: set[tuple[int, tuple[int, ...]]] = set()
    patterns: dict[tuple[int, tuple[int, ...]], dict[str, object]] = {}
    candidate_subset_count = 0
    for mask in range(1 << 13):
        fixed_core_size = mask.bit_count()
        if fixed_core_size % 3 != (2 * q + 1) % 3:
            continue
        r_counts = Counter((mask & line).bit_count() for line in fixed_line_masks)
        if any(intersection > 4 for intersection in r_counts):
            raise AssertionError
        choices = []
        for type_one in range(r_counts[1] + 1):
            for type_two in range(r_counts[2] + 1):
                fixed_types = (
                    type_one,
                    type_two,
                    r_counts[0] + r_counts[3],
                    r_counts[1] - type_one + r_counts[4],
                    r_counts[2] - type_two,
                )
                if all(fixed_types[degree - 1] % 3 == target[degree] % 3
                       for degree in range(1, 6)):
                    choices.append(fixed_types)
        if not choices:
            continue
        candidate_subset_count += 1
        representative = orbit_representative[mask]
        representative_indices = [fixed_indices[position] for position in range(13)
                                  if representative & (1 << position)]
        for fixed_types in choices:
            key = (representative, fixed_types)
            aggregate_patterns.add(key)
            if mask != representative:
                continue
            type_one_lines = [line_index for line_index, line in enumerate(fixed_line_masks)
                              if (mask & line).bit_count() == 1]
            type_two_lines = [line_index for line_index, line in enumerate(fixed_line_masks)
                              if (mask & line).bit_count() == 2]
            fixed_line_assignments = []
            for low_type_one in itertools.combinations(type_one_lines, fixed_types[0]):
                for low_type_two in itertools.combinations(type_two_lines, fixed_types[1]):
                    low_lines = set(low_type_one) | set(low_type_two)
                    if all(
                        sum(1 for line_index, line in enumerate(fixed_line_masks)
                            if line & (1 << position) and line_index not in low_lines) in (1, 4)
                        for position in range(13) if mask & (1 << position)
                    ):
                        fixed_line_assignments.append(sum(1 << line for line in low_lines))
            if not fixed_line_assignments:
                continue
            line_mask_index = {line: index for index, line in enumerate(fixed_line_masks)}
            assignment_representatives = set()
            for assignment in fixed_line_assignments:
                images = []
                for permutation in generated_group:
                    if permute_mask(mask, permutation) != mask:
                        continue
                    image = 0
                    for line_index, line in enumerate(fixed_line_masks):
                        if assignment & (1 << line_index):
                            image |= 1 << line_mask_index[permute_mask(line, permutation)]
                    images.append(image)
                assignment_representatives.add(min(images))
            canonical_low_lines = min(assignment_representatives)
            structure_matrices = []
            for permutation, matrix in group_matrices.items():
                if permute_mask(mask, permutation) != mask:
                    continue
                low_image = 0
                for line_index, line in enumerate(fixed_line_masks):
                    if canonical_low_lines & (1 << line_index):
                        low_image |= 1 << line_mask_index[permute_mask(line, permutation)]
                if low_image == canonical_low_lines:
                    structure_matrices.append(matrix)

            nonfixed_line_permutations = []
            for matrix in structure_matrices:
                inverse = matrix_inverse(field, matrix)
                if inverse is None:
                    raise AssertionError
                dual_matrix = [[inverse[column][row] for column in range(3)]
                               for row in range(3)]
                nonfixed_line_permutations.append(tuple(
                    nonfixed_orbit_of[point_index[normalize_projective(
                        field, matrix_vector(field, dual_matrix, points[orbit[0]])
                    )]]
                    for orbit in nonfixed_orbits
                ))
            unseen_pairs = {(left, right) for left in range(len(nonfixed_orbits))
                            for right in range(left + 1, len(nonfixed_orbits))}
            pair_orbit_sizes = []
            while unseen_pairs:
                seed = min(unseen_pairs)
                pair_orbit = {
                    tuple(sorted((permutation[seed[0]], permutation[seed[1]])))
                    for permutation in nonfixed_line_permutations
                }
                unseen_pairs.difference_update(pair_orbit)
                pair_orbit_sizes.append(len(pair_orbit))
            fixed_line_degrees = []
            for line_index, line in enumerate(fixed_line_masks):
                intersection = (mask & line).bit_count()
                low = bool(canonical_low_lines & (1 << line_index))
                if intersection in (0, 3):
                    degree = 3
                elif intersection == 1:
                    degree = 1 if low else 4
                elif intersection == 2:
                    degree = 2 if low else 5
                else:
                    degree = 4
                fixed_line_degrees.append(degree)
            record = {
                "fixed_core_size": fixed_core_size,
                "fixed_core_point_indices": representative_indices,
                "fixed_subline_intersection_counts": {
                    str(intersection): r_counts[intersection] for intersection in range(5)
                },
                "fixed_line_type_counts": list(fixed_types),
                "fixed_line_assignment_count_after_core_congruences":
                    len(fixed_line_assignments),
                "fixed_line_assignment_orbit_count_under_core_stabilizer":
                    len(assignment_representatives),
                "fixed_structure_stabilizer_order": len(structure_matrices),
                "nonfixed_line_pair_orbit_count": len(pair_orbit_sizes),
                "nonfixed_line_pair_orbit_size_spectrum": dict(sorted(
                    Counter(pair_orbit_sizes).items()
                )),
                "fixed_line_degrees_in_fixed_index_order": fixed_line_degrees,
                "core_nonfixed_point_orbits_on_fixed_lines":
                    (sum(fixed_line_degrees) - 4 * fixed_core_size) // 3,
                "core_nonfixed_point_orbits_off_fixed_lines":
                    (2 * q + 1 - fixed_core_size) // 3
                    - (sum(fixed_line_degrees) - 4 * fixed_core_size) // 3,
                "nonfixed_line_orbit_type_counts": {
                    str(degree): (target[degree] - fixed_types[degree - 1]) // 3
                    for degree in range(1, 6)
                },
            }
            if key in patterns and patterns[key] != record:
                raise AssertionError("assignment count should be projectively invariant")
            patterns.setdefault(key, record)

    ordered_patterns = sorted(patterns.values(), key=lambda record: (
        record["fixed_core_size"],
        record["fixed_core_point_indices"],
        record["fixed_line_type_counts"],
    ))
    output.write_text(json.dumps({
        "schema": "c949-q27-frobenius-fixed-subplane-audit-v2",
        "field_order": q,
        "fixed_subplane_order": 3,
        "fixed_point_indices": fixed_indices,
        "fixed_point_count": len(fixed_indices),
        "fixed_line_count": len(fixed_line_masks),
        "generated_projective_group_order": len(generated_group),
        "fixed_subplane_projective_subset_orbit_count": orbit_count,
        "target_dual_core_size": 2 * q + 1,
        "target_line_type_counts": target,
        "candidate_fixed_point_subset_count": candidate_subset_count,
        "aggregate_normalized_pattern_count": len(aggregate_patterns),
        "normalized_pattern_count": len(ordered_patterns),
        "normalized_patterns": ordered_patterns,
    }, indent=2, sort_keys=True) + "\n")


def audit_degree_defect(q9_construction: Path, frobenius_audit: Path,
                        output: Path) -> None:
    """Audit the T=2q+1 second-moment shell and its ternary centered codeword."""
    q9 = json.loads(q9_construction.read_text())
    _, q9_on_line, q9_through_point = incidence(9)
    q9_arc = set(q9["primal_arc_point_indices"])
    q9_unital = set(q9["unital_dual_point_indices"])
    q9_core = set(q9["degree_seven_point_indices"])
    q9_degrees = [len(q9_arc.intersection(line)) for line in q9_on_line]
    q9_centered = [degree - 3 for degree in q9_degrees]
    q9_support = {point for point, value in enumerate(q9_centered) if value % 3}
    q9_centered_line_sums = [sum(q9_centered[line] for line in incident)
                             for incident in q9_through_point]
    if any(value != 9 * (1 + int(point in q9_arc))
           for point, value in enumerate(q9_centered_line_sums)):
        raise ValueError("the q=9 centered incidence identity failed")
    if q9_support != set(range(91)) - q9_unital:
        raise ValueError("the q=9 centered support is not the unital complement")
    q9_core_degrees = [len(q9_core.intersection(line)) for line in q9_on_line]
    q9_signed_secant_defect = [
        1 + 3 * int(line in q9_arc) - q9_core_degrees[line]
        for line in range(91)
    ]
    q9_core_normalized = [
        q9_centered[point] - 3 * int(point in q9_core)
        for point in range(91)
    ]
    if any(sum(q9_signed_secant_defect[line] for line in incident)
           != 3 * q9_core_normalized[point]
           for point, incident in enumerate(q9_through_point)):
        raise ValueError("the q=9 signed secant-defect transform failed")
    if any(sum(q9_core_normalized[point] for point in line)
           != 3 * (q9_signed_secant_defect[line_index] + 2)
           for line_index, line in enumerate(q9_on_line)):
        raise ValueError("the q=9 inverse signed transform failed")
    q9_signed_support = {
        point for point, value in enumerate(q9_signed_secant_defect) if value
    }
    q9_signed_support_line_spectrum = Counter(
        len(q9_signed_support.intersection(line)) for line in q9_on_line
    )
    if q9_signed_support_line_spectrum[1]:
        raise ValueError("the q=9 signed support has a tangent")
    if any(sum(q9_signed_secant_defect[point] for point in line) != 0
           for line in q9_on_line
           if len(q9_signed_support.intersection(line)) == 2):
        raise ValueError("a q=9 signed support 2-secant has equal signs")
    q9_signed_positive = {
        point for point, value in enumerate(q9_signed_secant_defect) if value == 1
    }
    q9_signed_negative = {
        point for point, value in enumerate(q9_signed_secant_defect) if value == -1
    }
    q9_negative_carriers = [
        line_index for line_index, line in enumerate(q9_on_line)
        if q9_signed_negative.issubset(line)
    ]
    if len(q9_negative_carriers) != 1:
        raise ValueError("the q=9 negative sign class has no unique carrier line")
    q9_negative_carrier = q9_negative_carriers[0]
    if q9_signed_positive.intersection(q9_on_line[q9_negative_carrier]):
        raise ValueError("the q=9 positive sign class meets the negative carrier")
    q9_signed_joint_line_spectrum = Counter(
        (len(q9_signed_positive.intersection(line)),
         len(q9_signed_negative.intersection(line)))
        for line in q9_on_line
    )
    q9_carrier_points = set(q9_on_line[q9_negative_carrier])
    q9_carrier_holes = sorted(q9_carrier_points - q9_signed_negative)
    q9_secondary_hermitian_matrix = [[2, 6, 2], [3, 0, 5], [2, 8, 1]]
    q9_field = Field(9)
    q9_secondary_hermitian_inverse = matrix_inverse(
        q9_field, q9_secondary_hermitian_matrix
    )
    if q9_secondary_hermitian_inverse is None:
        raise ValueError("the secondary q=9 Hermitian form is singular")
    if any(q9_secondary_hermitian_matrix[column][row]
           != q9_field.pow(q9_secondary_hermitian_matrix[row][column], 3)
           for row in range(3) for column in range(3)):
        raise ValueError("the secondary q=9 matrix is not Hermitian")
    q9_secondary_unital = set()
    q9_points = projective_points(q9_field)
    for point_index, point in enumerate(q9_points):
        conjugate = tuple(q9_field.pow(value, 3) for value in point)
        hermitian_value = sum_field(q9_field, [
            q9_field.mul(conjugate[row], q9_field.mul(
                q9_secondary_hermitian_matrix[row][column], point[column]
            ))
            for row in range(3) for column in range(3)
        ])
        if hermitian_value == 0:
            q9_secondary_unital.add(point_index)
    if q9_secondary_unital != q9_signed_positive.union(q9_carrier_holes):
        raise ValueError("the secondary q=9 unital does not recover the signed word")
    q9_secondary_unital_line_spectrum = Counter(
        len(q9_secondary_unital.intersection(line)) for line in q9_on_line
    )
    if q9_secondary_unital_line_spectrum != Counter({1: 28, 4: 63}):
        raise ValueError("the secondary q=9 Hermitian zero locus is not a unital")
    q9_secondary_line_quotients = [
        (len(q9_secondary_unital.intersection(line)) - 1) // 3
        for line in q9_on_line
    ]
    if (sum(q9_secondary_line_quotients) != 63
            or sum(value * value for value in q9_secondary_line_quotients) != 63):
        raise ValueError("the q=9 exact modular-multiset moments failed")
    q9_secondary_tangent_dual = {
        line_index for line_index, line in enumerate(q9_on_line)
        if len(q9_secondary_unital.intersection(line)) == 1
    }
    if q9_secondary_tangent_dual != q9_unital:
        raise ValueError("the original q=9 unital is not the secondary tangent dual")
    q9_secondary_dual_matrix = [
        [q9_field.pow(value, 3) for value in row]
        for row in q9_secondary_hermitian_inverse
    ]
    if any(q9["hermitian_matrix"][row][column]
           != q9_field.mul(2, q9_secondary_dual_matrix[row][column])
           for row in range(3) for column in range(3)):
        raise ValueError("the two q=9 Hermitian matrices are not polarity dual")
    if (not q9_core.isdisjoint(q9_secondary_tangent_dual)
            or q9_negative_carrier in q9_core):
        raise ValueError("the q=9 core is not contained in the noncarrier secant dual")
    if any(q9_signed_secant_defect[point]
           != int(point in q9_secondary_unital) - int(point in q9_carrier_points)
           for point in range(len(q9_on_line))):
        raise ValueError("the q=9 signed word is not unital minus line")
    q9_affine_parallel_classes = [
        [line for line, members in enumerate(q9_on_line)
         if hole in members and line != q9_negative_carrier]
        for hole in q9_carrier_holes
    ]
    q9_four_line_correction_weights = Counter()
    q9_four_line_minimum_symbol_spectra = set()
    q9_four_line_minimum_weight = None
    for chosen_lines in itertools.product(*q9_affine_parallel_classes):
        four_line_sum = [0] * len(q9_on_line)
        for line in chosen_lines:
            for point in q9_on_line[line]:
                if point not in q9_carrier_points:
                    four_line_sum[point] = (four_line_sum[point] + 1) % 3
        correction = [
            ((int(point in q9_signed_positive) - four_line_sum[point]) % 3
             if point not in q9_carrier_points else 0)
            for point in range(len(q9_on_line))
        ]
        if any(sum(correction[point] for point in line) % 3
               for line in q9_on_line):
            raise ValueError("the four-direction correction is not a dual word")
        weight = sum(value != 0 for value in correction)
        q9_four_line_correction_weights[weight] += 1
        if q9_four_line_minimum_weight is None or weight < q9_four_line_minimum_weight:
            q9_four_line_minimum_weight = weight
            q9_four_line_minimum_symbol_spectra.clear()
        if weight == q9_four_line_minimum_weight:
            q9_four_line_minimum_symbol_spectra.add(
                tuple(sorted(Counter(correction).items()))
            )

    q = 27
    r = q // 3
    arc_size = q * q // 3 + 4 * q // 3
    maximal_degree = 2 * q // 3 + 1
    maximal_line_count = 2 * q + 1
    external_degree_upper_bound = q // 2
    external_count = q * q - q
    external_degree_sum = arc_size * (q + 1) - maximal_line_count * maximal_degree
    external_pair_sum = (math.comb(arc_size, 2)
                         - maximal_line_count * math.comb(maximal_degree, 2))
    centered_sum = external_degree_sum - r * external_count
    defect = 2 * external_pair_sum - 2 * r * external_degree_sum + (
        r * r + r
    ) * external_count
    if centered_sum != 6 * r * r - 4 * r - 1 or defect != 2 * r * (r - 2):
        raise AssertionError("the field-uniform defect identities failed")
    external_centered_norm = defect + centered_sum
    centered_norm = maximal_line_count * (r + 1) ** 2 + external_centered_norm
    centered_total_sum = maximal_line_count * (r + 1) + centered_sum

    def defect_cost(degree: int) -> int:
        return (degree - r) * (degree - r - 1)

    exceptional_degrees = [degree for degree in range(external_degree_upper_bound + 1)
                           if degree not in (r, r + 1)]
    nonfixed_exception_histograms: dict[int, list[tuple[tuple[int, ...], int, int]]] = {
        cost: [] for cost in range(defect // 3 + 1)
    }

    def enumerate_nonfixed(index: int, remaining: int, histogram: list[int],
                           count: int, centered: int, target_cost: int) -> None:
        if index == len(exceptional_degrees):
            if remaining == 0:
                nonfixed_exception_histograms[target_cost].append(
                    (tuple(histogram), count, centered)
                )
            return
        degree = exceptional_degrees[index]
        cost = defect_cost(degree)
        for multiplicity in range(remaining // cost + 1):
            histogram[degree] = multiplicity
            enumerate_nonfixed(
                index + 1,
                remaining - multiplicity * cost,
                histogram,
                count + multiplicity,
                centered + multiplicity * (degree - r),
                target_cost,
            )
        histogram[degree] = 0

    for target_cost in nonfixed_exception_histograms:
        enumerate_nonfixed(0, target_cost, [0] * maximal_degree, 0, 0, target_cost)

    def compositions(total: int, parts: int) -> list[tuple[int, ...]]:
        if parts == 1:
            return [(total,)]
        out = []
        for first in range(total + 1):
            for tail in compositions(total - first, parts - 1):
                out.append((first,) + tail)
        return out

    def fixed_histograms(high_count_spectrum: Counter[int]) -> set[tuple[tuple[int, ...], int, int]]:
        states = {(tuple([0] * maximal_degree), 0, 0)}
        for fixed_high_degree, point_count in sorted(high_count_spectrum.items()):
            allowed = list(range(
                fixed_high_degree, external_degree_upper_bound + 1, 3
            ))
            replacements = set()
            for multiplicities in compositions(point_count, len(allowed)):
                addition = [0] * maximal_degree
                for degree, multiplicity in zip(allowed, multiplicities):
                    addition[degree] = multiplicity
                addition_sum = sum(degree * addition[degree]
                                   for degree in range(maximal_degree))
                addition_defect = sum(defect_cost(degree) * addition[degree]
                                      for degree in range(maximal_degree))
                for histogram, degree_sum, defect_sum in states:
                    replacements.add((
                        tuple(histogram[degree] + addition[degree]
                              for degree in range(maximal_degree)),
                        degree_sum + addition_sum,
                        defect_sum + addition_defect,
                    ))
            states = replacements
        return states

    certificate = json.loads(frobenius_audit.read_text())
    _, on_line, through_point = incidence(q)
    fixed_indices = certificate["fixed_point_indices"]
    frobenius_orbits = symmetry_orbits(q, "frobenius")
    orbit_of = {point: orbit_index for orbit_index, orbit in
                enumerate(frobenius_orbits) for point in orbit}
    invariant_incidence = []
    for point_orbit in frobenius_orbits:
        row = [0] * len(frobenius_orbits)
        for line in through_point[point_orbit[0]]:
            row[orbit_of[line]] += 1
        invariant_incidence.append(row)
    nonfixed_line_orbits = [orbit for orbit in frobenius_orbits if len(orbit) == 3]
    fixed_point_of_nonfixed_line_orbit = []
    for orbit in nonfixed_line_orbits:
        incident_fixed_points = [
            point for point in fixed_indices if point in on_line[orbit[0]]
        ]
        if len(incident_fixed_points) > 1:
            raise AssertionError("a nonfixed line contains two fixed points")
        if incident_fixed_points and any(
            point not in on_line[line]
            for point in incident_fixed_points for line in orbit
        ):
            raise AssertionError("a conjugate line orbit does not share its fixed point")
        fixed_point_of_nonfixed_line_orbit.append(
            incident_fixed_points[0] if incident_fixed_points else None
        )
    fixed_pencil_orbit_spectrum = Counter(fixed_point_of_nonfixed_line_orbit)
    if (fixed_pencil_orbit_spectrum[None] != 144
            or any(fixed_pencil_orbit_spectrum[point] != 8
                   for point in fixed_indices)):
        raise AssertionError("unexpected Frobenius line-orbit pencil decomposition")

    def ternary_rank(rows: list[list[int]], column_count: int) -> int:
        matrix = [row[:] for row in rows]
        rank = 0
        for column in range(column_count):
            pivot = next((index for index in range(rank, len(matrix))
                          if matrix[index][column] % 3), None)
            if pivot is None:
                continue
            matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
            if matrix[rank][column] % 3 == 2:
                matrix[rank] = [(2 * value) % 3 for value in matrix[rank]]
            for index in range(len(matrix)):
                factor = matrix[index][column] % 3
                if index != rank and factor:
                    matrix[index] = [
                        (value - factor * pivot_value) % 3
                        for value, pivot_value in zip(matrix[index], matrix[rank])
                    ]
            rank += 1
        return rank

    def padic_smith_profile(
        rows: list[list[int]], prime: int, levels: int,
        track_columns: bool = False,
    ) -> tuple[list[int], list[list[int]] | None]:
        """Return truncated p-adic Smith valuations and a right transform."""
        matrix = [row[:] for row in rows]
        row_count = len(matrix)
        column_count = len(matrix[0])
        diagonal_count = min(row_count, column_count)
        full_modulus = prime ** levels
        modulus = full_modulus
        right = (
            [[int(row == column) for column in range(column_count)]
             for row in range(column_count)]
            if track_columns else None
        )
        start = 0
        valuation = 0
        valuations = []
        while start < diagonal_count and valuation < levels:
            while True:
                pivot = next((
                    (row, column)
                    for row in range(start, row_count)
                    for column in range(start, column_count)
                    if matrix[row][column] % prime
                ), None)
                if pivot is None:
                    break
                pivot_row, pivot_column = pivot
                matrix[start], matrix[pivot_row] = matrix[pivot_row], matrix[start]
                for row in matrix:
                    row[start], row[pivot_column] = row[pivot_column], row[start]
                if right is not None:
                    for row in right:
                        row[start], row[pivot_column] = row[pivot_column], row[start]
                inverse = pow(matrix[start][start] % modulus, -1, modulus)
                matrix[start] = [value * inverse % modulus
                                 for value in matrix[start]]
                for row in range(row_count):
                    if row == start:
                        continue
                    factor = matrix[row][start] % modulus
                    if factor:
                        matrix[row] = [
                            (value - factor * pivot_value) % modulus
                            for value, pivot_value in zip(matrix[row], matrix[start])
                        ]
                for column in range(column_count):
                    if column == start:
                        continue
                    factor = matrix[start][column] % modulus
                    if factor:
                        for row in range(row_count):
                            matrix[row][column] = (
                                matrix[row][column] - factor * matrix[row][start]
                            ) % modulus
                        if right is not None:
                            for row in range(column_count):
                                right[row][column] = (
                                    right[row][column] - factor * right[row][start]
                                ) % full_modulus
                valuations.append(valuation)
                start += 1
                if start == diagonal_count:
                    break
            if start == diagonal_count:
                break
            reduced_modulus = modulus // prime
            for row in range(start, row_count):
                for column in range(start, column_count):
                    if matrix[row][column] % prime:
                        raise AssertionError("p-adic residual block is not divisible")
                    matrix[row][column] = (
                        matrix[row][column] // prime
                    ) % reduced_modulus
            valuation += 1
            modulus = reduced_modulus
        valuations.extend([valuation] * (diagonal_count - start))
        return valuations, right

    invariant_rank = ternary_rank(invariant_incidence, len(frobenius_orbits))
    padic_valuations, right_transform = padic_smith_profile(
        invariant_incidence, 3, 3, track_columns=True
    )
    if right_transform is None:
        raise AssertionError
    padic_spectrum = Counter(padic_valuations)
    liftable_columns = [index for index, valuation in enumerate(padic_valuations)
                        if valuation >= 3]
    fixed_orbit_indices = [orbit_of[point] for point in fixed_indices]
    fixed_liftable_restriction = [
        [right_transform[orbit_index][column] % 3 for column in liftable_columns]
        for orbit_index in fixed_orbit_indices
    ]
    fixed_liftable_restriction_rank = ternary_rank(
        fixed_liftable_restriction, len(liftable_columns)
    )
    kernel_generators = []
    for column, valuation in enumerate(padic_valuations):
        if valuation == 0:
            continue
        scale = 3 ** (3 - min(valuation, 3))
        generator = [scale * right_transform[row][column] % 27
                     for row in range(len(frobenius_orbits))]
        if any(sum(invariant_incidence[row][entry] * generator[entry]
                   for entry in range(len(frobenius_orbits))) % 27
               for row in range(len(frobenius_orbits))):
            raise AssertionError("bad full-modulus kernel generator")
        kernel_generators.append(generator)
    fixed_kernel_projection = [
        [generator[orbit_index] for generator in kernel_generators]
        for orbit_index in fixed_orbit_indices
    ]
    fixed_projection_valuations, _ = padic_smith_profile(
        fixed_kernel_projection, 3, 3
    )
    fixed_projection_spectrum = Counter(fixed_projection_valuations)
    branch_records = []
    for pattern in certificate["normalized_patterns"]:
        core = set(pattern["fixed_core_point_indices"])
        fixed_line_degrees = dict(zip(
            fixed_indices, pattern["fixed_line_degrees_in_fixed_index_order"]
        ))
        fixed_signed_secant_defect = [
            1 + 3 * int(fixed_line_degrees[line] >= 3)
            - fixed_line_degrees[line]
            for line in fixed_indices
        ]
        fixed_negative = {
            point for point, value in zip(fixed_indices, fixed_signed_secant_defect)
            if value == -1
        }
        fixed_negative_carriers = [
            line for line in fixed_indices if fixed_negative.issubset(on_line[line])
        ] if len(fixed_negative) <= 4 else []
        transform_compatible_negative_carriers = [
            line for line in fixed_negative_carriers if line not in core
        ]
        fixed_external_high_degrees = []
        for point in fixed_indices:
            if point in core:
                continue
            fixed_external_high_degrees.append(sum(
                1 for line in fixed_indices
                if point in on_line[line] and fixed_line_degrees[line] >= 3
            ))
        high_count_spectrum = Counter(fixed_external_high_degrees)
        fixed_centered_residues = {}
        selected_fixed_lines = {
            line for line in fixed_indices if fixed_line_degrees[line] >= 3
        }
        for point in fixed_indices:
            fixed_centered_residues[point] = sum(
                point in on_line[line] for line in selected_fixed_lines
            ) % 3
        augmented = [row + [0] for row in invariant_incidence]
        for point in fixed_indices:
            fixed_row = [0] * (len(frobenius_orbits) + 1)
            fixed_row[orbit_of[point]] = 1
            fixed_row[-1] = fixed_centered_residues[point]
            augmented.append(fixed_row)
        pinned_rank = ternary_rank(augmented, len(frobenius_orbits))
        augmented_rank = ternary_rank(augmented, len(frobenius_orbits) + 1)
        if pinned_rank != augmented_rank:
            raise ValueError("fixed centered residues are inconsistent")
        fixed_residue_vector = [fixed_centered_residues[point]
                                for point in fixed_indices]
        liftable_augmented = [
            row + [value] for row, value in
            zip(fixed_liftable_restriction, fixed_residue_vector)
        ]
        liftable_augmented_rank = ternary_rank(
            liftable_augmented, len(liftable_columns) + 1
        )
        full_modulus_residue_compatible = (
            liftable_augmented_rank == fixed_liftable_restriction_rank
        )
        if not full_modulus_residue_compatible:
            raise ValueError(
                "fixed residues do not lift through modulus 27: "
                f"restriction rank {fixed_liftable_restriction_rank}, "
                f"augmented rank {liftable_augmented_rank}"
            )
        nonfixed_positive_orbits = (
            78 - fixed_signed_secant_defect.count(1)
        ) // 3
        nonfixed_negative_orbits = (
            24 - fixed_signed_secant_defect.count(-1)
        ) // 3
        fixed_pencil_states = {(0, 0, 0, tuple())}
        for point in fixed_indices:
            fixed_signed_sum = sum(
                fixed_signed_secant_defect[fixed_indices.index(line)]
                for line in through_point[point] if line in fixed_line_degrees
            )
            if fixed_signed_sum % 3:
                raise AssertionError("fixed-pencil signed sum is not divisible by three")
            fixed_high_degree = sum(
                line in selected_fixed_lines
                for line in through_point[point] if line in fixed_line_degrees
            )
            centered_values = (
                [1] if point in core else
                [degree - r for degree in range(
                    fixed_high_degree, external_degree_upper_bound + 1, 3
                )]
            )
            local_options = set()
            for centered_value in centered_values:
                signed_difference = centered_value - fixed_signed_sum // 3
                for negative_count in range(9):
                    positive_count = negative_count + signed_difference
                    if (0 <= positive_count <= 8
                            and positive_count + negative_count <= 8):
                        local_options.add((
                            positive_count,
                            negative_count,
                            centered_value,
                            centered_value * (centered_value - 1),
                        ))
            replacements = set()
            for positive_total, negative_total, defect_total, vector in fixed_pencil_states:
                for positive_count, negative_count, centered_value, local_defect in local_options:
                    if (positive_total + positive_count > nonfixed_positive_orbits
                            or negative_total + negative_count > nonfixed_negative_orbits):
                        continue
                    replacements.add((
                        positive_total + positive_count,
                        negative_total + negative_count,
                        defect_total + local_defect,
                        vector + (centered_value,),
                    ))
            fixed_pencil_states = replacements
        fixed_pencil_vectors = {state[3] for state in fixed_pencil_states}
        fixed_pencil_histograms = {
            tuple(sorted(Counter(vector).items()))
            for vector in fixed_pencil_vectors
        }
        fixed_pencil_defects = sorted({state[2] for state in fixed_pencil_states})
        fixed_pencil_sums = [sum(vector) for vector in fixed_pencil_vectors]
        fixed_pencil_positive_counts = [state[0] for state in fixed_pencil_states]
        fixed_pencil_negative_counts = [state[1] for state in fixed_pencil_states]
        fixed_pencil_support_counts = [state[0] + state[1]
                                       for state in fixed_pencil_states]
        fixed_states = fixed_histograms(high_count_spectrum)
        global_spectra = set()
        feasible_fixed_histograms = 0
        globally_feasible_fixed_histograms = set()
        for fixed_histogram, fixed_sum, fixed_defect in fixed_states:
            if fixed_defect > defect or (defect - fixed_defect) % 3:
                continue
            orbit_defect = (defect - fixed_defect) // 3
            fixed_is_feasible = False
            for orbit_histogram, exceptional_orbits, exceptional_centered in (
                nonfixed_exception_histograms[orbit_defect]
            ):
                remaining_degree = external_degree_sum - fixed_sum
                if remaining_degree % 3:
                    continue
                degree_r_plus_one_orbits = (
                    remaining_degree // 3 - r * 231 - exceptional_centered
                )
                degree_r_orbits = 231 - exceptional_orbits - degree_r_plus_one_orbits
                if degree_r_orbits < 0 or degree_r_plus_one_orbits < 0:
                    continue
                spectrum = [fixed_histogram[degree] + 3 * orbit_histogram[degree]
                            for degree in range(maximal_degree)]
                spectrum[r] += 3 * degree_r_orbits
                spectrum[r + 1] += 3 * degree_r_plus_one_orbits
                if (sum(spectrum) != external_count
                        or sum(degree * spectrum[degree]
                               for degree in range(maximal_degree)) != external_degree_sum
                        or sum(defect_cost(degree) * spectrum[degree]
                               for degree in range(maximal_degree)) != defect):
                    raise AssertionError("bad external degree spectrum")
                global_spectra.add(tuple(spectrum))
                fixed_is_feasible = True
            feasible_fixed_histograms += int(fixed_is_feasible)
            if fixed_is_feasible:
                globally_feasible_fixed_histograms.add(fixed_histogram)
        globally_feasible_fixed_pencil_vectors = 0
        for vector in fixed_pencil_vectors:
            histogram = [0] * maximal_degree
            for point, centered_value in zip(fixed_indices, vector):
                if point not in core:
                    histogram[r + centered_value] += 1
            globally_feasible_fixed_pencil_vectors += int(
                tuple(histogram) in globally_feasible_fixed_histograms
            )
        if globally_feasible_fixed_pencil_vectors != len(fixed_pencil_vectors):
            raise AssertionError(
                "the global scalar shell unexpectedly removes a fixed-pencil vector"
            )
        ranges = {
            str(degree): {
                "minimum": min(spectrum[degree] for spectrum in global_spectra),
                "maximum": max(spectrum[degree] for spectrum in global_spectra),
            }
            for degree in range(maximal_degree)
            if max(spectrum[degree] for spectrum in global_spectra)
        }
        centered_mod_3_weights = [
            maximal_line_count + sum(
                spectrum[degree] for degree in range(maximal_degree)
                if (degree - r) % 3
            )
            for spectrum in global_spectra
        ]
        branch_records.append({
            "fixed_core_point_indices": sorted(core),
            "fixed_signed_secant_defect_spectrum": dict(sorted(
                Counter(fixed_signed_secant_defect).items()
            )),
            "fixed_negative_collinear_carrier_indices": fixed_negative_carriers,
            "collinear_negative_candidate_hole_orbit_case_count": sum(
                math.comb(8, len(fixed_negative) // 3)
                for _ in fixed_negative_carriers
                if len(fixed_negative) in (0, 3)
            ),
            "collinear_negative_carriers_in_fixed_core": sorted(
                set(fixed_negative_carriers).intersection(core)
            ),
            "collinear_negative_signed_transform_compatible": bool(
                transform_compatible_negative_carriers
            ),
            "collinear_negative_surviving_hole_orbit_case_count": sum(
                math.comb(8, len(fixed_negative) // 3)
                for _ in transform_compatible_negative_carriers
                if len(fixed_negative) in (0, 3)
            ),
            "nonfixed_signed_secant_defect_orbit_spectrum": {
                "-1": nonfixed_negative_orbits,
                "0": (655 - fixed_signed_secant_defect.count(0)) // 3,
                "1": nonfixed_positive_orbits,
            },
            "fixed_pencil_signed_allocation_state_count": len(fixed_pencil_states),
            "fixed_pencil_centered_vector_count": len(fixed_pencil_vectors),
            "fixed_pencil_centered_vectors_compatible_with_global_degree_shell":
                globally_feasible_fixed_pencil_vectors,
            "all_fixed_pencil_centered_vectors_survive_global_degree_shell": True,
            "fixed_pencil_centered_histogram_count": len(fixed_pencil_histograms),
            "fixed_pencil_defect_spectrum": fixed_pencil_defects,
            "fixed_pencil_centered_sum_range": {
                "minimum": min(fixed_pencil_sums),
                "maximum": max(fixed_pencil_sums),
            },
            "fixed_pencil_positive_orbit_count_range": {
                "minimum": min(fixed_pencil_positive_counts),
                "maximum": max(fixed_pencil_positive_counts),
            },
            "fixed_pencil_negative_orbit_count_range": {
                "minimum": min(fixed_pencil_negative_counts),
                "maximum": max(fixed_pencil_negative_counts),
            },
            "fixed_pencil_supported_orbit_count_range": {
                "minimum": min(fixed_pencil_support_counts),
                "maximum": max(fixed_pencil_support_counts),
            },
            "fixed_pencil_minimum_positive_plus_twice_negative_orbits": min(
                state[0] + 2 * state[1] for state in fixed_pencil_states
            ),
            "off_fixed_subplane_positive_orbit_count_range": {
                "minimum": nonfixed_positive_orbits - max(fixed_pencil_positive_counts),
                "maximum": nonfixed_positive_orbits - min(fixed_pencil_positive_counts),
            },
            "off_fixed_subplane_negative_orbit_count_range": {
                "minimum": nonfixed_negative_orbits - max(fixed_pencil_negative_counts),
                "maximum": nonfixed_negative_orbits - min(fixed_pencil_negative_counts),
            },
            "fixed_external_high_degree_spectrum": dict(sorted(high_count_spectrum.items())),
            "fixed_external_residue_spectrum_mod_3": dict(sorted(
                Counter(degree % 3 for degree in fixed_external_high_degrees).items()
            )),
            "minimum_fixed_exception_count": sum(
                count for residue, count in
                Counter(degree % 3 for degree in fixed_external_high_degrees).items()
                if residue == 2
            ),
            "minimum_fixed_defect": sum(
                min(defect_cost(degree)
                    for degree in range(fixed_high_degree, maximal_degree, 3))
                for fixed_high_degree in fixed_external_high_degrees
            ),
            "fixed_degree_histogram_count": len(fixed_states),
            "feasible_fixed_degree_histogram_count": feasible_fixed_histograms,
            "compatible_external_degree_spectrum_count": len(global_spectra),
            "centered_mod_3_codeword_weight_range": {
                "minimum": min(centered_mod_3_weights),
                "maximum": max(centered_mod_3_weights),
            },
            "external_degree_count_ranges": ranges,
            "fixed_centered_residues_mod_3": {
                str(point): fixed_centered_residues[point] for point in fixed_indices
            },
            "pinned_ternary_incidence_rank": pinned_rank,
            "pinned_ternary_affine_dimension": len(frobenius_orbits) - pinned_rank,
            "full_modulus_residue_compatible": full_modulus_residue_compatible,
            "pinned_full_modulus_liftable_ternary_affine_dimension":
                len(liftable_columns) - fixed_liftable_restriction_rank,
        })

    if any(branch["collinear_negative_signed_transform_compatible"]
           for branch in branch_records):
        raise ValueError("a Frobenius collinear-negative branch unexpectedly survives")

    def q27_collinear_spectra(carrier_degree: int) -> list[tuple[int, ...]]:
        carrier_x = carrier_degree - r
        remaining_sum = centered_sum - carrier_x
        remaining_defect = defect - carrier_x * (carrier_x - 1)
        spectra = []
        for count_x4 in range(remaining_defect // 12 + 1):
            for count_x3 in range(remaining_defect // 6 + 1):
                leftover = remaining_defect - 12 * count_x4 - 6 * count_x3
                if leftover < 0 or leftover % 2:
                    continue
                count_x2 = leftover // 2
                count_x1 = (remaining_sum - 4 * count_x4 - 3 * count_x3
                            - 2 * count_x2)
                count_x0 = (external_count - 1 - count_x1 - count_x2
                            - count_x3 - count_x4)
                spectrum = (count_x0, count_x1, count_x2, count_x3, count_x4)
                if min(spectrum) >= 0:
                    spectra.append(spectrum)
        return spectra

    q27_collinear_cases = {}
    for positive_carrier_count, carrier_degree in ((0, 1), (3, 2)):
        spectra = q27_collinear_spectra(carrier_degree)
        q27_collinear_cases[str(positive_carrier_count)] = {
            "carrier_selected_degree": carrier_degree,
            "external_degree_spectrum_count": len(spectra),
            "noncarrier_degree_count_ranges": {
                str(r + offset): {
                    "minimum": min(spectrum[offset] for spectrum in spectra),
                    "maximum": max(spectrum[offset] for spectrum in spectra),
                }
                for offset in range(5)
            },
        }

    output.write_text(json.dumps({
        "schema": "c949-degree-defect-audit-v8",
        "field_uniform_identities": {
            "q": "3r",
            "external_point_count": "q^2-q",
            "centered_external_degree_sum": "6r^2-4r-1",
            "external_defect_sum": "sum (e-r)(e-r-1) = 2r(r-2)",
            "centered_incidence_equation": "M^T(e-r*1)=q*(1+1_A)",
            "core_normalized_vector": "x=e-r*(1+1_D)",
            "signed_secant_defect": "z=1+3*1_A-M*1_D",
            "signed_transform_equations": "M*z=3*x and M*x=r*(z+2*1)",
            "signed_secant_defect_spectrum":
                "(-1)^(q-3) 0^(q^2-3q+7) 1^(3q-3)",
            "signed_support_size": "4q-6",
            "collinear_negative_conditional": {
                "positive_count_on_carrier": "0 or 3",
                "positive_count_zero_case": {
                    "carrier_core_normalized_value": "-(r-1)",
                    "carrier_selected_degree": 1,
                    "carrier_defect": "r(r-1)",
                    "remaining_noncarrier_defect": "r(r-3)",
                    "remaining_exception_count_upper_bound": "r(r-3)/2",
                    "q27_remaining_exception_count_range": "5..27",
                },
                "positive_count_three_case": {
                    "carrier_core_normalized_value": "-(r-2)",
                    "carrier_selected_degree": 2,
                    "carrier_defect": "(r-2)(r-1)",
                    "remaining_noncarrier_defect": "(r-2)(r+1)",
                    "remaining_exception_count_upper_bound": "(r-2)(r+1)/2",
                    "q27_remaining_exception_count_range": "6..35",
                },
            },
            "collinear_negative_affine_radon_reduction":
                "1_P is a four-affine-line sum plus a projective dual word mod 3",
            "collinear_negative_exact_modular_multiset": {
                "definition": "u=z+1_L",
                "total_multiplicity": "3q+1",
                "line_intersections_mod_3": 1,
                "carrier_multiplicity": "4 or 7",
                "coordinate_multiplicities": "0,1,2",
                "line_quotient_sum": "2q^2/3+q",
                "line_quotient_squared_sum": "7q^2/9+2qR/9",
                "line_quotient_defect": "q(q-9+2R)/9",
                "repeated_point_pair_count_R": "0 or 3",
            },
            "core_normalized_sum": "2r(3r+1)",
            "core_normalized_squared_norm": "2r(4r-1)",
            "signed_support_has_no_tangents": True,
        },
        "q9": {
            "arc_size": len(q9_arc),
            "line_degree_spectrum": dict(sorted(Counter(q9_degrees).items())),
            "external_defect": sum((degree - 3) * (degree - 4)
                                   for point, degree in enumerate(q9_degrees)
                                   if point not in q9_core),
            "centered_mod_3_support_size": len(q9_support),
            "unital_complement_size": 91 - len(q9_unital),
            "centered_mod_3_support_equals_unital_complement": True,
            "centered_incidence_equation_checked": True,
            "core_normalized_spectrum": dict(sorted(Counter(q9_core_normalized).items())),
            "core_normalized_sum": sum(q9_core_normalized),
            "core_normalized_squared_norm": sum(
                value * value for value in q9_core_normalized
            ),
            "core_normalized_defect": sum(
                value * (value - 1) for value in q9_core_normalized
            ),
            "signed_secant_defect_spectrum": dict(sorted(
                Counter(q9_signed_secant_defect).items()
            )),
            "signed_secant_defect_transform_checked": True,
            "signed_support_line_intersection_spectrum": dict(sorted(
                q9_signed_support_line_spectrum.items()
            )),
            "signed_support_has_no_tangents": True,
            "signed_support_two_secants_have_opposite_signs": True,
            "signed_negative_points_are_collinear": True,
            "signed_negative_carrier_line_index": q9_negative_carrier,
            "signed_negative_carrier_hole_count":
                len(q9_on_line[q9_negative_carrier]) - len(q9_signed_negative),
            "signed_positive_points_avoid_negative_carrier": True,
            "signed_word_equals_secondary_unital_minus_carrier_line": True,
            "secondary_hermitian_matrix": q9_secondary_hermitian_matrix,
            "secondary_unital_size": len(q9_secondary_unital),
            "secondary_unital_carrier_intersection_size":
                len(q9_secondary_unital.intersection(q9_carrier_points)),
            "secondary_unital_line_intersection_spectrum": dict(sorted(
                q9_secondary_unital_line_spectrum.items()
            )),
            "secondary_unital_line_quotient_sum":
                sum(q9_secondary_line_quotients),
            "secondary_unital_line_quotient_squared_sum":
                sum(value * value for value in q9_secondary_line_quotients),
            "original_unital_equals_secondary_tangent_dual": True,
            "original_secondary_hermitian_matrix_relation":
                "H_original=2*(H_secondary^-1)^(3)",
            "core_is_subset_of_secondary_noncarrier_secant_dual": True,
            "original_secondary_unital_intersection_size":
                len(q9_unital.intersection(q9_secondary_unital)),
            "signed_positive_negative_line_intersection_spectrum": {
                f"{positive},{negative}": count
                for (positive, negative), count in sorted(
                    q9_signed_joint_line_spectrum.items()
                )
            },
            "four_direction_line_sum_choice_count":
                math.prod(len(lines) for lines in q9_affine_parallel_classes),
            "four_direction_dual_correction_weight_spectrum": dict(sorted(
                q9_four_line_correction_weights.items()
            )),
            "four_direction_dual_correction_minimum_weight":
                q9_four_line_minimum_weight,
            "four_direction_dual_correction_minimum_symbol_spectra": [
                dict(spectrum) for spectrum in sorted(
                    q9_four_line_minimum_symbol_spectra
                )
            ],
        },
        "q27_T55": {
            "arc_size": arc_size,
            "maximal_degree": maximal_degree,
            "maximal_line_count": maximal_line_count,
            "external_point_count": external_count,
            "external_degree_sum": external_degree_sum,
            "external_pair_sum": external_pair_sum,
            "centered_external_degree_sum": centered_sum,
            "external_defect": defect,
            "external_exception_count_upper_bound": defect // 2,
            "external_degree_upper_bound_from_blocking_core":
                external_degree_upper_bound,
            "external_centered_squared_norm": external_centered_norm,
            "centered_total_sum": centered_total_sum,
            "centered_squared_norm": centered_norm,
            "core_normalized_sum": centered_total_sum - r * maximal_line_count,
            "core_normalized_squared_norm":
                maximal_line_count + external_centered_norm,
            "core_normalized_defect": defect,
            "signed_secant_defect_spectrum": {
                "-1": 24,
                "0": 655,
                "1": 78,
            },
            "signed_secant_defect_sum": 54,
            "signed_secant_defect_squared_norm": 102,
            "signed_secant_defect_ternary_dual_weight": 102,
            "signed_support_has_no_tangents": True,
            "signed_support_two_secants_have_opposite_signs": True,
            "frobenius_collinear_negative_excluded": not any(
                branch["collinear_negative_signed_transform_compatible"]
                for branch in branch_records
            ),
            "frobenius_collinear_negative_candidate_case_count": sum(
                branch["collinear_negative_candidate_hole_orbit_case_count"]
                for branch in branch_records
            ),
            "frobenius_collinear_negative_surviving_case_count": sum(
                branch["collinear_negative_surviving_hole_orbit_case_count"]
                for branch in branch_records
            ),
            "asymmetric_collinear_negative_degree_spectra": q27_collinear_cases,
            "core_normalized_line_sum_spectrum": {
                "9": 24,
                "18": 655,
                "27": 78,
            },
            "frobenius_invariant_coordinate_count": len(frobenius_orbits),
            "nonfixed_line_orbits_through_fixed_points": 104,
            "nonfixed_line_orbits_avoiding_fixed_points": 144,
            "nonfixed_line_orbits_per_fixed_point_pencil": 8,
            "frobenius_invariant_ternary_incidence_rank": invariant_rank,
            "frobenius_invariant_ternary_kernel_dimension":
                len(frobenius_orbits) - invariant_rank,
            "frobenius_invariant_incidence_3adic_valuation_spectrum": {
                str(valuation): padic_spectrum[valuation]
                for valuation in range(4)
            },
            "full_modulus_kernel_log_3_size": sum(
                min(valuation, 3) for valuation in padic_valuations
            ),
            "full_modulus_liftable_ternary_dimension": len(liftable_columns),
            "fixed_liftable_residue_restriction_rank":
                fixed_liftable_restriction_rank,
            "fixed_full_modulus_kernel_projection_3adic_valuation_spectrum": {
                str(valuation): fixed_projection_spectrum[valuation]
                for valuation in range(3)
            },
            "fixed_full_modulus_kernel_projection_log_3_size": sum(
                3 - valuation for valuation in fixed_projection_valuations
            ),
            "fixed_full_modulus_kernel_projection_index_log_3":
                3 * len(fixed_indices) - sum(
                    3 - valuation for valuation in fixed_projection_valuations
                ),
            "branches": branch_records,
        },
    }, indent=2, sort_keys=True) + "\n")


def analyze_blocking_certificate(path: Path, output: Path) -> None:
    certificate = json.loads(path.read_text())
    q = certificate["field_order"]
    points, on_line, _ = incidence(q)
    blocking = set(certificate["blocking_set_point_indices"])
    blocking_intersections = [len(blocking.intersection(line)) for line in on_line]
    arc_intersections = [q + 1 - value for value in blocking_intersections]
    dual_type_sets = []
    for intersection in sorted(set(arc_intersections)):
        dual_points = {ell for ell, value in enumerate(arc_intersections)
                       if value == intersection}
        dual_spectrum = Counter(len(dual_points.intersection(line)) for line in on_line)
        dual_type_sets.append({
            "arc_line_intersection": intersection,
            "dual_point_set_size": len(dual_points),
            "dual_line_intersection_spectrum": dict(sorted(dual_spectrum.items())),
            "dual_point_indices": sorted(dual_points),
        })
    unital_cross_classification = None
    unital_candidates = [entry for entry in dual_type_sets
                          if entry["dual_point_set_size"] == 28
                          and entry["dual_line_intersection_spectrum"] == {1: 28, 4: 63}]
    if len(unital_candidates) == 1:
        unital = set(unital_candidates[0]["dual_point_indices"])
        cross = Counter()
        for point_index, dual_line in enumerate(on_line):
            unital_degree = len(unital.intersection(dual_line))
            cross[("blocking" if point_index in blocking else "arc", unital_degree)] += 1
        unital_cross_classification = {
            f"{membership}:degree-{degree}": count
            for (membership, degree), count in sorted(cross.items())
        }
    output.write_text(json.dumps({
        "schema": "c949-blocking-structure-analysis-v1",
        "field_order": q,
        "blocking_set_size": len(blocking),
        "blocking_line_intersection_spectrum": dict(sorted(Counter(blocking_intersections).items())),
        "arc_size": len(points) - len(blocking),
        "arc_line_intersection_spectrum": dict(sorted(Counter(arc_intersections).items())),
        "dual_type_sets": dual_type_sets,
        "unital_cross_classification": unital_cross_classification,
    }, indent=2, sort_keys=True) + "\n")


def analyze_unital_mechanism(path: Path, output: Path) -> None:
    certificate = json.loads(path.read_text())
    q = certificate["field_order"]
    if q != 9:
        raise ValueError("the bounded unital mechanism audit is for q=9")
    field = Field(q)
    points, on_line, _ = incidence(q)
    point_index = {point: index for index, point in enumerate(points)}
    blocking = set(certificate["blocking_set_point_indices"])
    arc = set(range(len(points))) - blocking
    arc_intersections = [len(arc.intersection(line)) for line in on_line]
    unital = {ell for ell, value in enumerate(arc_intersections) if value == 3}
    singleton = [ell for ell, value in enumerate(arc_intersections) if value == 1]
    if len(unital) != 28 or len(singleton) != 1:
        raise ValueError("certificate lacks the expected 28+1 dual fingerprint")
    unital_spectrum = Counter(len(unital.intersection(line)) for line in on_line)
    if unital_spectrum != Counter({4: 63, 1: 28}):
        raise ValueError("the 28-set is not a unital")
    distinguished = singleton[0]

    hermitian_forms = []
    for diagonal in itertools.product(range(3), repeat=3):
        for off_diagonal in itertools.product(range(q), repeat=3):
            d01, d02, d12 = off_diagonal
            hermitian = [
                [diagonal[0], d01, d02],
                [field.pow(d01, 3), diagonal[1], d12],
                [field.pow(d02, 3), field.pow(d12, 3), diagonal[2]],
            ]
            if matrix_inverse(field, hermitian) is None:
                continue
            zero_locus = set()
            for index, point in enumerate(points):
                conjugate = tuple(field.pow(value, 3) for value in point)
                value = sum_field(field, [
                    field.mul(conjugate[i], field.mul(hermitian[i][j], point[j]))
                    for i in range(3) for j in range(3)
                ])
                if value == 0:
                    zero_locus.add(index)
            if zero_locus == unital:
                hermitian_forms.append(hermitian)

    source_frame = None
    for u1, u2, u3 in itertools.permutations(sorted(unital), 3):
        source_columns = [points[distinguished], points[u1], points[u2]]
        source_matrix = matrix_from_columns(source_columns)
        source_inverse = matrix_inverse(field, source_matrix)
        if source_inverse is None:
            continue
        coordinates = matrix_vector(field, source_inverse, points[u3])
        if all(coordinates):
            source_frame = (source_inverse, coordinates)
            break
    if source_frame is None:
        raise RuntimeError("no projective frame found")
    source_inverse, source_coordinates = source_frame

    projectivities = {}
    unital_vectors = [points[index] for index in sorted(unital)]
    for v1, v2, v3 in itertools.permutations(unital_vectors, 3):
        target_matrix = matrix_from_columns([points[distinguished], v1, v2])
        target_inverse = matrix_inverse(field, target_matrix)
        if target_inverse is None:
            continue
        target_coordinates = matrix_vector(field, target_inverse, v3)
        if not all(target_coordinates):
            continue
        scales = [field.mul(target_coordinates[i], field.inv(source_coordinates[i]))
                  for i in range(3)]
        diagonal = [[scales[i] if i == j else 0 for j in range(3)] for i in range(3)]
        transformation = matrix_multiply(
            field, matrix_multiply(field, target_matrix, diagonal), source_inverse
        )
        image_unital = {
            point_index[normalize_projective(field, matrix_vector(field, transformation, point))]
            for point in unital_vectors
        }
        if image_unital != unital:
            continue
        permutation = tuple(
            point_index[normalize_projective(field, matrix_vector(field, transformation, point))]
            for point in points
        )
        flat = [value for row in transformation for value in row]
        leading = next(value for value in flat if value)
        leading_inverse = field.inv(leading)
        normalized_transformation = [
            [field.mul(leading_inverse, value) for value in row] for row in transformation
        ]
        projectivities[permutation] = normalized_transformation
    permutations = sorted(projectivities)
    line_by_point_set = {frozenset(line): index for index, line in enumerate(on_line)}
    dual_line_permutations = [tuple(
        line_by_point_set[frozenset(permutation[point] for point in on_line[line])]
        for line in range(len(points))
    ) for permutation in permutations]
    unseen = set(range(len(points)))
    orbit_records = []
    point_orbits = []
    arc_is_orbit_union = True
    while unseen:
        seed = min(unseen)
        orbit = sorted({permutation[seed] for permutation in dual_line_permutations})
        unseen.difference_update(orbit)
        point_orbits.append(orbit)
        arc_count = len(arc.intersection(orbit))
        if arc_count not in (0, len(orbit)):
            arc_is_orbit_union = False
        orbit_records.append({
            "size": len(orbit),
            "arc_points": arc_count,
            "blocking_points": len(orbit) - arc_count,
            "representative": orbit[0],
        })
    invariant_candidates = []
    for mask in range(1 << len(point_orbits)):
        candidate = set().union(*(set(point_orbits[index])
                                  for index in range(len(point_orbits)) if mask & (1 << index)))
        if len(candidate) != len(arc):
            continue
        intersections = [len(candidate.intersection(line)) for line in on_line]
        maximum = max(intersections)
        maximal_lines = [ell for ell, value in enumerate(intersections) if value == maximum]
        covered = set().union(*(set(on_line[ell]) for ell in maximal_lines))
        complete = not (set(range(len(points))) - candidate - covered)
        invariant_candidates.append({
            "orbit_indices": [index for index in range(len(point_orbits)) if mask & (1 << index)],
            "point_indices": sorted(candidate),
            "line_intersection_spectrum": dict(sorted(Counter(intersections).items())),
            "maximum_line_intersection": maximum,
            "complete": complete,
        })
    arc_stabilizer_indices = [index for index, permutation in enumerate(dual_line_permutations)
                              if {permutation[point] for point in arc} == arc]
    arc_stabilizer = [dual_line_permutations[index] for index in arc_stabilizer_indices]
    arc_stabilizer_orbits = []
    unseen_lines = set(range(len(points)))
    while unseen_lines:
        seed = min(unseen_lines)
        orbit = sorted({permutation[seed] for permutation in arc_stabilizer})
        unseen_lines.difference_update(orbit)
        arc_stabilizer_orbits.append({
            "size": len(orbit),
            "arc_dual_lines": len(arc.intersection(orbit)),
            "unital_intersection": len(unital.intersection(on_line[seed])),
            "dual_line_indices": orbit,
        })
    unital_degrees = [len(unital.intersection(dual_line)) for dual_line in on_line]
    tangent_contacts = []
    for dual_line_index, dual_line in enumerate(on_line):
        contact = unital.intersection(dual_line)
        if distinguished in dual_line and len(contact) == 1:
            tangent_contacts.extend(contact)
    polar_block = set(tangent_contacts)
    arc_tangent_lines = {point for point in arc if unital_degrees[point] == 1}
    arc_secant_lines = {point for point in arc if unital_degrees[point] == 4}
    polar_secants = [point for point in arc_secant_lines
                     if unital.intersection(on_line[point]) == polar_block]
    secant_point_degrees = Counter(
        point for block in arc_secant_lines for point in unital.intersection(on_line[block])
    )
    contained_spreads = []
    for candidate in itertools.combinations(sorted(arc_secant_lines), 7):
        cover = Counter(point for block in candidate for point in unital.intersection(on_line[block]))
        if cover == Counter({point: 1 for point in unital}):
            contained_spreads.append(list(candidate))
    spread_decomposition = None
    if len(polar_block) == 4 and len(polar_secants) == 1:
        residual_blocks = sorted(arc_secant_lines - {polar_secants[0]})
        adjacency = {block: set() for block in residual_blocks}
        for left, right in itertools.combinations(residual_blocks, 2):
            if unital.intersection(on_line[left]).intersection(on_line[right]):
                adjacency[left].add(right)
                adjacency[right].add(left)
        colors: dict[int, int] = {}
        bipartite = True
        for seed in residual_blocks:
            if seed in colors:
                continue
            colors[seed] = 0
            frontier = [seed]
            while frontier:
                current = frontier.pop()
                for neighbor in adjacency[current]:
                    expected = 1 - colors[current]
                    if neighbor in colors and colors[neighbor] != expected:
                        bipartite = False
                    elif neighbor not in colors:
                        colors[neighbor] = expected
                        frontier.append(neighbor)
        color_classes = [[block for block in residual_blocks if colors.get(block) == color]
                         for color in (0, 1)]
        covers = [Counter(point for block in spread for point in unital.intersection(on_line[block]))
                  for spread in color_classes]
        spreads = bipartite and all(len(spread) == 7 for spread in color_classes) and all(
            cover == Counter({point: 1 for point in unital}) for cover in covers
        )
        spread_decomposition = {
            "polar_block_unital_points": sorted(polar_block),
            "polar_secant_dual_line": polar_secants[0],
            "spread_dual_lines": [sorted(spread) for spread in color_classes],
            "is_two_spreads": spreads,
            "arc_tangents_not_through_distinguished_point": sorted(arc_tangent_lines),
        }
    spread_diagnostics = {
        "tangent_contacts_through_distinguished_point": sorted(tangent_contacts),
        "distinct_tangent_contacts_through_distinguished_point": sorted(polar_block),
        "arc_tangent_dual_line_count": len(arc_tangent_lines),
        "arc_secant_dual_line_count": len(arc_secant_lines),
        "matching_polar_secants_in_arc": polar_secants,
        "selected_secant_unital_degree_spectrum": dict(sorted(Counter(secant_point_degrees.values()).items())),
        "selected_secants_through_distinguished_point": sorted(
            point for point in arc_secant_lines if distinguished in on_line[point]
        ),
        "selected_secant_polar_contact_counts": dict(sorted(Counter(
            len(polar_block.intersection(on_line[point])) for point in arc_secant_lines
        ).items())),
        "contained_spreads": contained_spreads,
        "dual_line_intersection_spectrum_through_distinguished_point": dict(sorted(Counter(
            unital_degrees[point] for point in on_line[distinguished]
        ).items())),
    }
    output.write_text(json.dumps({
        "schema": "c949-q9-unital-mechanism-v1",
        "field_order": q,
        "unital_dual_point_indices": sorted(unital),
        "unital_dual_point_coordinates": [points[index] for index in sorted(unital)],
        "defining_hermitian_forms": hermitian_forms,
        "distinguished_external_dual_point": distinguished,
        "distinguished_external_dual_point_coordinates": points[distinguished],
        "selected_dual_line_indices": sorted(arc),
        "selected_dual_line_coordinates": [points[index] for index in sorted(arc)],
        "selected_tangent_dual_line_indices": sorted(arc_tangent_lines),
        "selected_tangent_dual_line_coordinates": [points[index] for index in sorted(arc_tangent_lines)],
        "selected_secant_dual_line_indices": sorted(arc_secant_lines),
        "selected_secant_dual_line_coordinates": [points[index] for index in sorted(arc_secant_lines)],
        "projective_stabilizer_order": len(permutations),
        "arc_stabilizer_order_within_pair_stabilizer": len(arc_stabilizer),
        "arc_stabilizer_projective_matrices_on_dual_points": [
            projectivities[permutations[index]] for index in arc_stabilizer_indices
        ],
        "arc_stabilizer_dual_line_orbits": arc_stabilizer_orbits,
        "stabilizer_orbits": orbit_records,
        "arc_is_stabilizer_orbit_union": arc_is_orbit_union,
        "invariant_candidates_of_same_size": invariant_candidates,
        "unital_spread_diagnostics": spread_diagnostics,
        "unital_spread_mechanism": spread_decomposition,
    }, indent=2, sort_keys=True) + "\n")


def construct_q9_unital_arc(output: Path) -> None:
    """Construct the 39-point arc from a Hermitian unital and a C4 line class."""
    field = Field(9)
    points, on_line, _ = incidence(9)
    point_index = {point: index for index, point in enumerate(points)}
    hermitian = [
        [1, 4, 7],
        [7, 1, 2],
        [4, 2, 2],
    ]

    def hermitian_value(point: tuple[int, int, int]) -> int:
        conjugate = tuple(field.pow(value, 3) for value in point)
        return sum_field(field, [
            field.mul(conjugate[i], field.mul(hermitian[i][j], point[j]))
            for i in range(3) for j in range(3)
        ])

    unital = {index for index, point in enumerate(points) if hermitian_value(point) == 0}
    distinguished_coordinates = (0, 1, 5)
    distinguished = point_index[distinguished_coordinates]
    generator = [
        [1, 6, 5],
        [2, 6, 6],
        [4, 7, 2],
    ]
    point_permutation = tuple(
        point_index[normalize_projective(field, matrix_vector(field, generator, point))]
        for point in points
    )
    line_by_point_set = {frozenset(line): index for index, line in enumerate(on_line)}
    line_permutation = tuple(
        line_by_point_set[frozenset(point_permutation[point] for point in on_line[line])]
        for line in range(len(points))
    )

    def orbit(permutation: tuple[int, ...], seed: int) -> list[int]:
        result = []
        current = seed
        while current not in result:
            result.append(current)
            current = permutation[current]
        return sorted(result)

    seed_coordinates = [
        (1, 0, 4),
        (1, 0, 7),
        (1, 1, 3),
        (1, 2, 8),
        (1, 4, 3),
    ]
    seed_indices = [point_index[seed] for seed in seed_coordinates]
    secant_orbits = [orbit(line_permutation, seed) for seed in seed_indices]
    selected_secants = set().union(*(set(item) for item in secant_orbits))
    selected_tangents = {
        line for line in range(len(points))
        if len(unital.intersection(on_line[line])) == 1
        and distinguished not in on_line[line]
    }
    selected_lines = selected_tangents | selected_secants
    point_degrees = [sum(point in on_line[line] for line in selected_lines)
                     for point in range(len(points))]
    high_points = {point for point, degree in enumerate(point_degrees) if degree == 7}
    tangent_lines_through_distinguished = {
        line for line in range(len(points))
        if distinguished in on_line[line] and len(unital.intersection(on_line[line])) == 1
    }
    contact_points = set().union(*(
        unital.intersection(on_line[line]) for line in tangent_lines_through_distinguished
    ))
    tangent_cone = set().union(*(
        set(on_line[line]) for line in tangent_lines_through_distinguished
    )) - unital - {distinguished}
    other_external = set(range(len(points))) - unital - tangent_cone - {distinguished}
    secant_degrees = [sum(point in on_line[line] for line in selected_secants)
                      for point in range(len(points))]
    selected_high_cover = Counter(len(high_points.intersection(on_line[line]))
                                  for line in selected_lines)
    unselected_lines = set(range(len(points))) - selected_lines
    unselected_high_cover = Counter(len(high_points.intersection(on_line[line]))
                                    for line in unselected_lines)

    assert len(unital) == 28
    assert Counter(len(unital.intersection(line)) for line in on_line) == Counter({4: 63, 1: 28})
    assert point_permutation[distinguished] == distinguished
    assert {point_permutation[point] for point in unital} == unital
    assert all(
        point_permutation[point_permutation[point_permutation[point_permutation[point]]]] == point
        for point in range(len(points))
    )
    assert any(point_permutation[point_permutation[point]] != point for point in range(len(points)))
    assert [len(item) for item in secant_orbits] == [4, 4, 2, 4, 1]
    assert len(selected_secants) == 15
    assert all(len(unital.intersection(on_line[line])) == 4 for line in selected_secants)
    assert len(selected_tangents) == 24
    assert selected_tangents.isdisjoint(selected_secants)
    assert len(contact_points) == 4
    assert Counter(secant_degrees[point] for point in contact_points) == Counter({3: 4})
    assert Counter(secant_degrees[point] for point in unital - contact_points) == Counter({2: 24})
    assert secant_degrees[distinguished] == 1
    assert Counter(secant_degrees[point] for point in tangent_cone) == Counter({1: 28, 4: 4})
    assert Counter(secant_degrees[point] for point in other_external) == Counter({0: 15, 3: 15})
    assert Counter(point_degrees) == Counter({1: 1, 3: 28, 4: 43, 7: 19})
    assert selected_high_cover == Counter({3: 24, 4: 14, 5: 1})
    assert unselected_high_cover == Counter({1: 47, 2: 5})

    output.write_text(json.dumps({
        "schema": "c949-q9-unital-c4-construction-v1",
        "field_order": 9,
        "field": {
            "description": "GF(9)=GF(3)[w]/(w^2+1)",
            "integer_encoding": "a+b*w is encoded as a+3*b",
        },
        "hermitian_matrix": hermitian,
        "unital_dual_point_indices": sorted(unital),
        "distinguished_external_dual_point": distinguished,
        "distinguished_external_dual_point_coordinates": distinguished_coordinates,
        "c4_generator_on_dual_points": generator,
        "secant_orbit_seed_coordinates": seed_coordinates,
        "secant_orbit_sizes": [len(item) for item in secant_orbits],
        "selected_secant_dual_line_indices": sorted(selected_secants),
        "selected_tangent_dual_line_indices": sorted(selected_tangents),
        "selected_dual_line_indices": sorted(selected_lines),
        "contact_unital_point_indices": sorted(contact_points),
        "mechanism_tables": {
            "selected_secant_degrees_on_contacts": dict(sorted(Counter(
                secant_degrees[point] for point in contact_points
            ).items())),
            "selected_secant_degrees_on_other_unital_points": dict(sorted(Counter(
                secant_degrees[point] for point in unital - contact_points
            ).items())),
            "selected_secant_degrees_on_tangent_cone": dict(sorted(Counter(
                secant_degrees[point] for point in tangent_cone
            ).items())),
            "selected_secant_degrees_on_other_external_points": dict(sorted(Counter(
                secant_degrees[point] for point in other_external
            ).items())),
        },
        "dual_point_degree_spectrum": dict(sorted(Counter(point_degrees).items())),
        "degree_seven_point_indices": sorted(high_points),
        "degree_seven_points_on_selected_lines": dict(sorted(selected_high_cover.items())),
        "degree_seven_points_on_unselected_lines": dict(sorted(unselected_high_cover.items())),
        "primal_arc_point_indices": sorted(selected_lines),
        "primal_blocking_set_point_indices": sorted(unselected_lines),
        "checked": True,
    }, indent=2, sort_keys=True) + "\n")


def audit_frobenius_hull_mechanism(frobenius_audit: Path, output: Path) -> None:
    """Exclude the two-orbit conjugate-line mechanism for the signed word."""
    q = 27
    point_count = q * q + q + 1
    all_coordinates = (1 << point_count) - 1
    _, on_line, _ = incidence(q)
    certificate = json.loads(frobenius_audit.read_text())
    fixed_indices = certificate["fixed_point_indices"]
    nonfixed_orbits = [
        orbit for orbit in symmetry_orbits(q, "frobenius") if len(orbit) == 3
    ]

    def masks(values: list[int]) -> tuple[int, int]:
        ones = sum(1 << index for index, value in enumerate(values) if value % 3 == 1)
        twos = sum(1 << index for index, value in enumerate(values) if value % 3 == 2)
        return ones, twos

    def add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
        left_one, left_two = left
        right_one, right_two = right
        left_zero = all_coordinates ^ (left_one | left_two)
        right_zero = all_coordinates ^ (right_one | right_two)
        return (
            ((left_zero & right_one) | (left_one & right_zero)
             | (left_two & right_two)),
            ((left_zero & right_two) | (left_two & right_zero)
             | (left_one & right_one)),
        )

    orbit_generators = []
    for orbit in nonfixed_orbits:
        values = [0] * point_count
        for line in orbit:
            for point in on_line[line]:
                values[point] = (values[point] + 1) % 3
        generator = masks(values)
        if any((generator[0] | generator[1]) & (1 << point)
               for point in fixed_indices):
            raise AssertionError("a conjugate-line orbit sum is nonzero on the fixed subplane")
        orbit_generators.extend([generator, (generator[1], generator[0])])
    pair_sums = {
        add(orbit_generators[left], orbit_generators[right])
        for left in range(len(orbit_generators))
        for right in range(left, len(orbit_generators))
    }
    if len(orbit_generators) != 496 or len(pair_sums) != 123009:
        raise AssertionError("unexpected conjugate-line orbit-sum counts")

    branch_records = []
    for pattern in certificate["normalized_patterns"]:
        fixed_line_degrees = dict(zip(
            fixed_indices, pattern["fixed_line_degrees_in_fixed_index_order"]
        ))
        target = [
            (1 + 3 * int(fixed_line_degrees[line] >= 3)
             - fixed_line_degrees[line]) % 3
            for line in fixed_indices
        ]
        fixed_lifts = []
        sparsest_fixed_lifts = []
        low_weight_fixed_lifts = []
        minimum_coefficient_weight = None
        coefficient_weight_spectrum = Counter()
        for coefficients in itertools.product(range(3), repeat=len(fixed_indices)):
            if sum(coefficients) % 3:
                continue
            if any(
                sum(coefficients[index]
                    for index, line in enumerate(fixed_indices)
                    if point in on_line[line]) % 3 != target[point_index]
                for point_index, point in enumerate(fixed_indices)
            ):
                continue
            values = [0] * point_count
            for coefficient, line in zip(coefficients, fixed_indices):
                if coefficient:
                    for point in on_line[line]:
                        values[point] = (values[point] + coefficient) % 3
            fixed_lift = masks(values)
            fixed_lifts.append(fixed_lift)
            coefficient_weight = sum(value != 0 for value in coefficients)
            coefficient_weight_spectrum[coefficient_weight] += 1
            if coefficient_weight <= 4:
                low_weight_fixed_lifts.append(fixed_lift)
            if (minimum_coefficient_weight is None
                    or coefficient_weight < minimum_coefficient_weight):
                minimum_coefficient_weight = coefficient_weight
                sparsest_fixed_lifts = [fixed_lift]
            elif coefficient_weight == minimum_coefficient_weight:
                sparsest_fixed_lifts.append(fixed_lift)
        one_orbit_target_count = 0
        two_orbit_target_count = 0
        for fixed_lift in fixed_lifts:
            for generator in orbit_generators:
                candidate = add(fixed_lift, generator)
                one_orbit_target_count += int(
                    candidate[0].bit_count() == 78
                    and candidate[1].bit_count() == 24
                )
            for pair_sum in pair_sums:
                candidate = add(fixed_lift, pair_sum)
                two_orbit_target_count += int(
                    candidate[0].bit_count() == 78
                    and candidate[1].bit_count() == 24
                )
        three_orbit_target_count_for_low_weight_lifts = 0
        for fixed_lift in low_weight_fixed_lifts:
            for pair_sum in pair_sums:
                partial = add(fixed_lift, pair_sum)
                for generator in orbit_generators:
                    candidate = add(partial, generator)
                    three_orbit_target_count_for_low_weight_lifts += int(
                        candidate[0].bit_count() == 78
                        and candidate[1].bit_count() == 24
                    )
        expected_low_weight_lift_count = (
            10 if pattern["fixed_core_point_indices"] == [0, 1, 2, 27] else 7
        )
        if (len(fixed_lifts) != 729 or one_orbit_target_count
                or two_orbit_target_count
                or len(sparsest_fixed_lifts) != 1
                or len(low_weight_fixed_lifts) != expected_low_weight_lift_count
                or three_orbit_target_count_for_low_weight_lifts):
            raise AssertionError("a bounded conjugate-line mechanism unexpectedly survives")
        branch_records.append({
            "fixed_core_point_indices": pattern["fixed_core_point_indices"],
            "fixed_line_dual_lift_count": len(fixed_lifts),
            "fixed_line_coefficient_weight_spectrum": dict(sorted(
                coefficient_weight_spectrum.items()
            )),
            "sparsest_fixed_line_coefficient_weight": minimum_coefficient_weight,
            "sparsest_fixed_line_lift_count": len(sparsest_fixed_lifts),
            "fixed_line_lift_count_of_coefficient_weight_at_most_4":
                len(low_weight_fixed_lifts),
            "one_nonfixed_orbit_sum_target_sign_count": one_orbit_target_count,
            "two_nonfixed_orbit_sum_target_sign_count": two_orbit_target_count,
            "three_nonfixed_orbit_sum_target_sign_count_for_fixed_lifts_of_"
            "coefficient_weight_at_most_4":
                three_orbit_target_count_for_low_weight_lifts,
        })

    output.write_text(json.dumps({
        "schema": "c949-q27-frobenius-hull-mechanism-audit-v1",
        "field_order": q,
        "representation": (
            "a fixed-line coefficient lift plus at most two scalar multiples "
            "of incidence sums of nonfixed Frobenius line orbits"
        ),
        "fixed_line_coefficients_sum_to_zero_mod_3": True,
        "nonfixed_line_orbit_count": len(nonfixed_orbits),
        "scaled_nonfixed_line_orbit_generator_count": len(orbit_generators),
        "distinct_unordered_two_generator_sum_count": len(pair_sums),
        "target_positive_count": 78,
        "target_negative_count": 24,
        "branches": branch_records,
        "checked": True,
    }, indent=2, sort_keys=True) + "\n")


def audit_exact_target_obstruction(output: Path) -> None:
    """Check the scalar arithmetic used by the structural C949 obstruction.

    This is deliberately not a nonexistence search.  The report's geometric
    proof uses the Szőnyi--Weiner line-code theorem; this audit only replays
    its exact moment, envelope, and finite coefficient calculations.
    """

    def minimum_pairs(count: int, degree_sum: int, lower: int) -> int:
        if degree_sum < count * lower:
            raise ValueError("degree sum is below its lower bound")
        quotient, remainder = divmod(degree_sum - count * lower, count)
        low = lower + quotient
        return ((count - remainder) * low * (low - 1) // 2
                + remainder * (low + 1) * low // 2)

    field_records = []
    for q in (81, 243, 729):
        r = q // 3
        point_count = q * q + q + 1
        target_size = 3 * r * r + 4 * r
        maximum_intersection = 2 * r + 1
        outside_count = point_count - target_size
        feasible = []
        for tangent_count in range(2 * q, 2 * q + 8):
            internal = minimum_pairs(
                target_size, maximum_intersection * tangent_count, 0
            )
            external = minimum_pairs(outside_count, r * tangent_count, 1)
            if internal + external <= tangent_count * (tangent_count - 1) // 2:
                feasible.append(tangent_count)
        if feasible != [2 * q, 2 * q + 1]:
            raise AssertionError("the exact maximal-secant envelope changed")
        branches = []
        for tangent_count in feasible:
            incidence_sum = (q + 1) * tangent_count
            incidence_square_sum = (
                incidence_sum + tangent_count * (tangent_count - 1)
            )
            arc_incidence_sum = maximum_intersection * tangent_count
            u_sum = point_count + 3 * target_size - incidence_sum
            u_norm = (
                point_count + 15 * target_size + incidence_square_sum
                - 2 * incidence_sum - 6 * arc_incidence_sum
            )
            shell_defect = (
                tangent_count * (tangent_count - 1) // 2
                - (3 * arc_incidence_sum - 6 * target_size
                   + r * tangent_count - outside_count)
            )
            expected = (
                (3 * q + 1, 5 * q + 1, 2 * r + 1)
                if tangent_count == 2 * q
                else (2 * q, 4 * q - 6, r - 2)
            )
            if (u_sum, u_norm, shell_defect) != expected:
                raise AssertionError("an integral branch moment changed")
            branches.append({
                "maximal_secant_count": tangent_count,
                "u_sum": u_sum,
                "u_norm_squared": u_norm,
                "shell_defect": shell_defect,
            })
        threshold = ((math.isqrt(q) + 1) * (q + 1 - math.isqrt(q)))
        if not 5 * q + 1 < threshold:
            raise AssertionError("small-codeword threshold does not apply")
        field_records.append({
            "field_order": q,
            "target_size": target_size,
            "maximum_intersection": maximum_intersection,
            "small_codeword_exact_representation_threshold": threshold,
            "branches": branches,
        })

    coefficient_rows = []
    survivors = []
    nonexceptional_thresholds = []
    ranges = {-1: (5, 6, 7), 0: (4, 5, 6), 1: (4, 5), 2: (3, 4)}
    for secant_offset, line_counts in ranges.items():
        target_leading_sum = 3 - secant_offset
        required_residue = (1 - secant_offset) % 3
        for line_count in line_counts:
            coefficient_sums = [
                value for value in range(-line_count, line_count + 1, 2)
                if value % 3 == required_residue
            ]
            allowance = 6 - secant_offset - line_count
            row_survivors = [
                value for value in coefficient_sums
                if abs(target_leading_sum - value) <= allowance
            ]
            survivors.extend(
                (secant_offset, line_count, value) for value in row_survivors
            )
            for value in coefficient_sums:
                if (secant_offset, line_count, value) in {
                    (-1, 5, 5), (0, 4, 4)
                }:
                    continue
                baseline_margin = (
                    abs(target_leading_sum - value) - allowance
                )
                slope = 18 if value > target_leading_sum else 12
                nonexceptional_thresholds.append(
                    Fraction(baseline_margin, slope)
                )
            coefficient_rows.append({
                "secant_offset": secant_offset,
                "covering_line_count": line_count,
                "coefficient_sums": coefficient_sums,
                "leading_discrepancy_allowance": allowance,
                "moment_survivors": row_survivors,
            })
    if survivors != [(-1, 5, 5), (0, 4, 4)]:
        raise AssertionError("the bounded-repair coefficient table changed")
    if min(nonexceptional_thresholds) != Fraction(1, 18):
        raise AssertionError("the linear-gap coefficient margin changed")

    four_line_checks = []
    for q in (27, 81, 243, 729):
        lower = 2 * q * q - 24 * q + 54
        upper = 21 * q
        if lower <= upper:
            raise AssertionError("the four-line transversal bounds do not separate")
        four_line_checks.append({"field_order": q, "lower": lower, "upper": upper})

    output.write_text(json.dumps({
        "schema": "c949-exact-target-structural-arithmetic-audit-v2",
        "scope": (
            "arithmetic replay only; the structural nonexistence proof and "
            "Szőnyi--Weiner input remain human-proof dependencies"
        ),
        "field_checks": field_records,
        "bounded_repair_coefficient_rows": coefficient_rows,
        "bounded_repair_moment_survivors": [list(row) for row in survivors],
        "linear_gap_open_endpoint": str(min(nonexceptional_thresholds)),
        "nonexceptional_coefficient_margin_for_c_below_endpoint": "1-18c",
        "all_positive_capacity_margins": ["1-5c", "2/3-5c"],
        "four_line_transversal_checks": four_line_checks,
        "checked": True,
    }, indent=2, sort_keys=True) + "\n")


def audit_sharp_linear_coefficient(output: Path) -> None:
    """Replay the exact arithmetic behind the 5/3 linear obstruction.

    This checks identities and the finite equality-case ledger.  It does not
    replace either the small-codeword theorem or the geometric arguments in
    the report.
    """

    raw_concurrent_rows = []
    raw_triangular_rows = []
    triangular_connector_degrees = {}
    for secant_offset in range(-2, 8):
        support_lower_offset = -(
            (secant_offset - 1) * (secant_offset - 4) // 2
        )
        for coefficient_sum in (-3, -1, 1, 3):
            if coefficient_sum % 3 != (1 - secant_offset) % 3:
                continue
            if 2 * secant_offset + coefficient_sum > 11:
                continue
            positive_lines = (3 + coefficient_sum) // 2

            concurrent_support_offset = (
                0 if abs(coefficient_sum) == 3 else 1
            )
            if (secant_offset >= positive_lines
                    and concurrent_support_offset >= support_lower_offset):
                raw_concurrent_rows.append((secant_offset, coefficient_sum))

            triangle_support_offset = (
                0 if abs(coefficient_sum) == 3 else -2
            )
            memberships = [1] * positive_lines + [0] * (3 - positive_lines)
            connector_numerators = [
                secant_offset + 2 + memberships[i] + memberships[j]
                - memberships[k]
                for i, j, k in ((0, 1, 2), (0, 2, 1), (1, 2, 0))
            ]
            if (triangle_support_offset >= support_lower_offset
                    and all(value > 0 and value % 2 == 0
                            for value in connector_numerators)):
                row = (secant_offset, coefficient_sum)
                raw_triangular_rows.append(row)
                triangular_connector_degrees[str(row)] = [
                    value // 2 for value in connector_numerators
                ]

    expected_raw_concurrent = [
        (1, -3), (2, -1), (3, 1), (4, -3),
        (4, 3), (5, -1), (7, -3),
    ]
    expected_raw_triangular = [(0, 1), (1, 3), (4, -3), (5, -1)]
    if raw_concurrent_rows != expected_raw_concurrent:
        raise AssertionError("the raw concurrent core ledger changed")
    if raw_triangular_rows != expected_raw_triangular:
        raise AssertionError("the raw triangular core ledger changed")

    endpoint_candidates = []
    for secant_offset in range(-2, 8):
        for coefficient_sum in (-3, -1, 1, 3):
            if coefficient_sum % 3 != (1 - secant_offset) % 3:
                continue
            positive_lines = (3 + coefficient_sum) // 2
            defect = 7 - secant_offset
            norm_surplus = 7 - secant_offset
            sum_correction = 4 - secant_offset - coefficient_sum
            coverage_ok = secant_offset >= -1
            support_capacity_ok = secant_offset >= 1
            correction_ok = abs(sum_correction) <= norm_surplus
            signed_capacity_ok = (
                norm_surplus - sum_correction >= 2 * positive_lines
            )
            if (coverage_ok and support_capacity_ok and correction_ok
                    and signed_capacity_ok):
                endpoint_candidates.append((secant_offset, coefficient_sum))

    expected_pre_exact = [
        (1, -3), (1, 3), (2, -1), (3, 1),
        (4, -3), (4, 3), (5, -1), (7, -3),
    ]
    if endpoint_candidates != expected_pre_exact:
        raise AssertionError("the endpoint coefficient ledger changed")

    field_checks = []
    for q in (81, 243, 729):
        r = q // 3
        delta = r
        candidate_data = []
        for secant_offset, coefficient_sum in endpoint_candidates:
            u_sum = ((9 - 3 * secant_offset) * r + 3 * delta
                     - secant_offset + 1)
            u_norm = ((15 - 3 * secant_offset) * r + 15 * delta
                      + secant_offset**2 - 8 * secant_offset + 1)
            arc_u_sum = ((10 - 2 * secant_offset) * r + 4 * delta
                         - secant_offset)
            defect = ((2 - secant_offset) * r + 1 + 5 * delta
                      + secant_offset * (secant_offset - 7) // 2)
            invariant_left = 2 * arc_u_sum - defect - u_sum
            invariant_expected = (
                3 * q - (secant_offset - 1) * (secant_offset - 4) // 2
            )
            if invariant_left != invariant_expected:
                raise AssertionError("the three-line invariant changed")
            candidate_data.append({
                "secant_offset": secant_offset,
                "coefficient_sum": coefficient_sum,
                "u_sum": u_sum,
                "u_norm_squared": u_norm,
                "arc_u_sum": arc_u_sum,
                "shell_defect": defect,
                "three_line_invariant_left": invariant_left,
            })

        # The two final triangular cores have exact spectra forced by equality
        # in the pointwise support inequality.
        j4_arc_u_sum = 2 * q - 4
        j4_defect = q - 5
        if not j4_arc_u_sum > 2 * j4_defect + 3:
            raise AssertionError("the all-negative endpoint contradiction changed")

        s = 2 * r + 1
        j5_tangent_count = 2 * q + 5
        j5_degree_four = q * (q + 2) // 3 + 2
        incidence_excess = s * j5_tangent_count - (
            q * q // 3 + 5 * q // 3
        )
        # If a1 is the number of selected 1-secants and h4 the number of
        # unselected 4-secants, the two degree equations give
        # A3 = s + a1 + 2 h4.  Since only one 3-secant is off the positive
        # generator line, its cap gives a1+2h4<=1; hence h4=0, and both
        # 4-secant connector vertices are selected, exceeding that cap.
        if incidence_excess != q * q + 11 * q // 3 + 5:
            raise AssertionError("the mixed endpoint incidence total changed")
        if j5_degree_four != q * (q + 2) // 3 + 2:
            raise AssertionError("the mixed endpoint spectrum changed")

        bruen_fisher_spectrum = {
            1: 2 * (q * q - q + 3) // 3,
            2: q,
            3: 2 * q - 2,
            4: (q - 1) * (q - 3) // 3,
        }
        point_count = q * q + q + 1
        if sum(bruen_fisher_spectrum.values()) != point_count:
            raise AssertionError("the Bruen--Fisher line count changed")
        if sum(degree * count for degree, count
               in bruen_fisher_spectrum.items()) != 2 * q * (q + 1):
            raise AssertionError("the Bruen--Fisher incidence sum changed")
        if sum(degree * (degree - 1) // 2 * count
               for degree, count in bruen_fisher_spectrum.items()
               ) != q * (2 * q - 1):
            raise AssertionError("the Bruen--Fisher pair sum changed")
        if (bruen_fisher_spectrum[2] + bruen_fisher_spectrum[3]
                != 3 * q - 2):
            raise AssertionError("the Bruen--Fisher residue support changed")

        # The origin and the vertical point at infinity each lie on one
        # tangent, one bisecant, and q-1 trisecants.  Every other core point
        # lies on q/3 tangents, one bisecant, two trisecants, and 2q/3-2
        # four-secants.  The latter profile follows either from the cubic
        # construction or by subtracting the two exceptional profiles from
        # the global spectrum and using the known vertical/radial/horizontal
        # lines through a generic point.
        bf_special_profile = {1: 1, 2: 1, 3: q - 1, 4: 0}
        bf_generic_profile = {
            1: q // 3,
            2: 1,
            3: 2,
            4: 2 * q // 3 - 2,
        }
        for degree in range(1, 5):
            reconstructed = (
                2 * bf_special_profile[degree]
                + 2 * (q - 1) * bf_generic_profile[degree]
            )
            if reconstructed != degree * bruen_fisher_spectrum[degree]:
                raise AssertionError("the Bruen--Fisher point profile changed")

        # If this exact 2q-point set were the saturated maximal-secant core
        # of an arc with repair eta, write h,H for omitted 3- and 4-secants.
        # The two selected-line equations force
        # A_2=q/3+1-eta+2h+3H <= q.  The two exceptional points force
        # h>=2(q-1-s)=2q/3-4.  Therefore eta>=2q/3-7.
        bf_minimum_omitted_trisecants = 2 * q // 3 - 4
        bf_minimum_repair = 2 * q // 3 - 7
        if (2 * bf_minimum_omitted_trisecants
                > 2 * q // 3 - 1 + bf_minimum_repair):
            raise AssertionError("the Bruen--Fisher repair threshold changed")
        if (2 * bf_minimum_omitted_trisecants
                != 2 * q // 3 - 1 + bf_minimum_repair):
            raise AssertionError("the Bruen--Fisher threshold is not sharp in the ledger")

        bf_plus_spectrum = {
            1: bruen_fisher_spectrum[1] - 2,
            2: 3,
            3: 3 * q - 3,
            4: bruen_fisher_spectrum[4],
        }
        if sum(bf_plus_spectrum.values()) != point_count:
            raise AssertionError("the augmented Bruen--Fisher line count changed")
        if sum(degree * count for degree, count
               in bf_plus_spectrum.items()) != (2 * q + 1) * (q + 1):
            raise AssertionError("the augmented Bruen--Fisher incidence sum changed")
        if sum(degree * (degree - 1) // 2 * count
               for degree, count in bf_plus_spectrum.items()
               ) != (2 * q + 1) * q:
            raise AssertionError("the augmented Bruen--Fisher pair sum changed")
        bf_plus_minimum_omitted_trisecants = q - 6
        bf_plus_minimum_repair = q - 11
        if (2 * bf_plus_minimum_omitted_trisecants
                != q - 1 + bf_plus_minimum_repair):
            raise AssertionError("the augmented Bruen--Fisher repair threshold changed")
        if (q - 3) // 2 <= 9:
            raise AssertionError("the linearized-cubic bad-slope gap changed")

        triangle_j4_spectrum = {
            1: (2 * q * q - 8 * q + 3) // 3,
            2: 3 * q - 3,
            3: 3,
            4: q * (q + 2) // 3,
        }
        triangle_j4_selector_eta1 = {
            1: 1,
            2: q - 3,
            3: 3,
            4: triangle_j4_spectrum[4],
        }
        triangle_j5_spectrum = {
            1: (2 * q * q - 8 * q + 3) // 3,
            2: 2 * q - 2,
            3: q,
            4: q * (q + 2) // 3 + 2,
        }
        for size, spectrum in ((2 * q + 4, triangle_j4_spectrum),
                               (2 * q + 5, triangle_j5_spectrum)):
            if sum(spectrum.values()) != point_count:
                raise AssertionError("a triangular survivor line count changed")
            if sum(degree * count for degree, count in spectrum.items()
                   ) != size * (q + 1):
                raise AssertionError("a triangular survivor incidence sum changed")
            if sum(degree * (degree - 1) // 2 * count
                   for degree, count in spectrum.items()) != size * (size - 1) // 2:
                raise AssertionError("a triangular survivor pair sum changed")
        eta1_size = q * q // 3 + 5 * q // 3 + 1
        eta1_incidence = (2 * q + 4) * (2 * q // 3 + 1)
        if sum(triangle_j4_selector_eta1.values()) != eta1_size:
            raise AssertionError("the triangular +1 selector size changed")
        if sum(degree * count for degree, count
               in triangle_j4_selector_eta1.items()) != eta1_incidence:
            raise AssertionError("the triangular +1 selector incidence changed")
        triangle_j4_vertex_line_profile = {
            1: q // 3 - 1,
            2: 1,
            3: 1,
            4: 2 * q // 3,
        }
        triangle_j4_generic_line_profile = {
            1: q // 3 - 2,
            2: 3,
            3: 0,
            4: 2 * q // 3,
        }
        for degree in range(1, 5):
            reconstructed = (
                9 * triangle_j4_vertex_line_profile[degree]
                + (2 * q - 5) * triangle_j4_generic_line_profile[degree]
            )
            if reconstructed != degree * triangle_j4_spectrum[degree]:
                raise AssertionError("the triangular +1 local profile changed")
        if 2 * (q - 3) != 2 * q - 6:
            raise AssertionError("the selected bisecant matching count changed")
        if (9 + 2 * (2 * q - 6) + 3) // 2 != 2 * q:
            raise AssertionError("the unselected side matching count changed")
        if 3 + 2 * (q - 4) != 2 * q - 5:
            raise AssertionError("the almost-duplex projection count changed")
        almost_duplex_colored_edges = 3 * (q - 4)
        if 2 * almost_duplex_colored_edges != 3 * (2 * q - 5) - 9:
            raise AssertionError("the almost-duplex colored graph count changed")
        cyclic_duplex_common_external_lower_bound = (q - 1) * (q - 5) // 4
        cyclic_duplex_boundary_rescue_upper_bound = 9 * (q + 1)
        if (cyclic_duplex_common_external_lower_bound
                <= cyclic_duplex_boundary_rescue_upper_bound):
            raise AssertionError("the cyclic-duplex coverage gap changed")
        direction_reconstruction = {
            1: 3 * (q // 3 - 1) + (q - 4) * (2 * q // 3 - 1),
            2: 2 * (q - 1) + 3 + (q - 4),
            3: 3,
            4: 3 * (2 * q // 3) + (q - 4) * (q // 3),
        }
        if direction_reconstruction != triangle_j4_spectrum:
            raise AssertionError("the triangular parallel-class ledger changed")
        extension_degree = 0
        q_cursor = q
        while q_cursor > 1:
            if q_cursor % 3:
                raise AssertionError("the audited field order is not ternary")
            q_cursor //= 3
            extension_degree += 1
        carry_free_mixed_moments = 6**extension_degree - 3 * q + 3
        if carry_free_mixed_moments <= q:
            raise AssertionError("the carry-free moment family lost superlinearity")
        triangular_dual_word = {
            "positive": 2 * q + 3,
            "negative": q - 3,
            "zero": q * q - 2 * q + 1,
        }
        if sum(triangular_dual_word.values()) != q * q + q + 1:
            raise AssertionError("the triangular dual-word length changed")
        if (triangular_dual_word["positive"]
                + triangular_dual_word["negative"] != 3 * q):
            raise AssertionError("the triangular dual-word weight changed")
        triangular_dual_word_line_profiles = {
            "0_positive_0_negative": q - 3,
            "1_positive_1_negative": 3 + (q - 4) * (2 * q // 3 - 1),
            "2_positive_2_negative": q - 4,
            "3_positive_0_negative": 4 * q - 2,
            "4_positive_1_negative": 2 + (q - 4) * q // 3,
            "2_positive_q_minus_4_negative": 1,
        }
        if (sum(triangular_dual_word_line_profiles.values())
                != q * q + q + 1):
            raise AssertionError("the triangular dual-word line spectrum changed")
        frobenius_fiber_normal_form = {
            "frobenius_exponent": q // 3,
            "fiber_sum_polynomial_degree_bound": q // 3,
            "fiber_product_polynomial_degree_bound": 2 * q // 3,
            "fiber_sum_consecutive_moments": 2 * q // 3 - 2,
            "fiber_square_sum_consecutive_moments": q // 3 - 2,
            "zero_completed_singleton_fibers": 3,
            "compatible_triangle_charts": 3,
            "two_monomial_completion_possible": False,
            "monomial_vandermonde_zero_run": (2 * q // 3 - 2) // 3,
            "minimum_completion_moment_support_per_chart": (
                (2 * q // 3 - 2) // 3
            ),
            "minimum_completion_trace_fourier_support_per_chart": (
                (2 * q // 3 - 2) // 3
            ),
            "minimum_completion_trace_degree_per_chart": (
                (2 * q // 3 - 2) // 3 - 1
            ),
        }
        if frobenius_fiber_normal_form["monomial_vandermonde_zero_run"] < 3:
            raise AssertionError("the monomial Vandermonde exclusion lost its zero run")
        if (frobenius_fiber_normal_form[
                "minimum_completion_moment_support_per_chart"] <= 0):
            raise AssertionError("the duplex spectral-complexity bound vanished")
        if (frobenius_fiber_normal_form[
                "minimum_completion_trace_fourier_support_per_chart"]
                != frobenius_fiber_normal_form[
                    "minimum_completion_moment_support_per_chart"]):
            raise AssertionError("Frobenius failed to preserve trace sparsity")

        field_checks.append({
            "field_order": q,
            "endpoint_delta": delta,
            "candidate_moments": candidate_data,
            "all_negative_final_gap": (
                j4_arc_u_sum - (2 * j4_defect + 3)
            ),
            "mixed_degree_four_line_count": j5_degree_four,
            "mixed_positive_generator_cap_gap": 1,
            "bruen_fisher_adjacent_core": {
                "size": 2 * q,
                "secant_offset": 0,
                "coefficient_sum": 1,
                "line_spectrum": {
                    str(degree): count for degree, count
                    in bruen_fisher_spectrum.items()
                },
                "residue_support": 3 * q - 2,
                "exceptional_point_profile": {
                    str(degree): count for degree, count
                    in bf_special_profile.items()
                },
                "generic_point_profile": {
                    str(degree): count for degree, count
                    in bf_generic_profile.items()
                },
                "minimum_omitted_trisecants": bf_minimum_omitted_trisecants,
                "repair_lower_bound_if_exact_saturated_core": bf_minimum_repair,
                "augmented_core": {
                    "size": 2 * q + 1,
                    "line_spectrum": {
                        str(degree): count for degree, count
                        in bf_plus_spectrum.items()
                    },
                    "minimum_omitted_trisecants": (
                        bf_plus_minimum_omitted_trisecants
                    ),
                    "repair_lower_bound_if_exact_saturated_core": (
                        bf_plus_minimum_repair
                    ),
                },
            },
            "two_term_linearized_cubic_family": {
                "minimum_wrong_slopes_if_linear_terms_differ": (q - 3) // 2,
                "maximum_wrong_slopes_allowed_by_concurrent_ledger": 9,
                "equal_linear_terms": (
                    "one finite double-cover slope and one graph intersection"
                ),
            },
            "constant_repair_triangular_targets": {
                "j4_all_negative_core_spectrum": {
                    str(degree): count for degree, count
                    in triangle_j4_spectrum.items()
                },
                "j4_all_negative_eta1_selector_spectrum": {
                    str(degree): count for degree, count
                    in triangle_j4_selector_eta1.items()
                },
                "j4_all_negative_eta1_line_partition": {
                    "vertex_lines": 9,
                    "tangent_line": 1,
                    "generic_lines": 2 * q - 6,
                    "selected_bisecants_form_perfect_matching_on": 2 * q - 6,
                    "almost_duplex": {
                        "size": 2 * q - 5,
                        "projection_fibers_for_a_b_and_a_over_b": {
                            "singletons": 3,
                            "doubletons": q - 4,
                        },
                        "colored_fiber_graph": {
                            "vertices": 2 * q - 5,
                            "edges": almost_duplex_colored_edges,
                            "missing_color_incidences": 9,
                            "selector_matching_edges": q - 3,
                            "unmatched_vertices": 1,
                            "edge_color_count_sum": q - 3,
                            "edge_color_count_upper_bound": 2 * q // 3 - 2,
                        },
                        "singleton_product_identity": "prod(A0)=prod(B0)prod(C0)",
                        "full_duplex_completion_gate": (
                            "bijection pi:A0->B0 with ratio multiset C0 and "
                            "three new cells"
                        ),
                        "canonical_cyclic_duplex": {
                            "carrier": ["a*b=1", "a*b=gamma"],
                            "common_external_line_lower_bound": (
                                cyclic_duplex_common_external_lower_bound
                            ),
                            "nine_boundary_point_rescue_upper_bound": (
                                cyclic_duplex_boundary_rescue_upper_bound
                            ),
                            "blocking_possible": False,
                        },
                        "affine_redei_gate": {
                            "affine_boundary_points": 6,
                            "exceptional_directions": 3,
                            "directions_with_at_most_six_missing_intercepts": q - 2,
                            "minimum_distinct_intercepts": q - 6,
                            "maximum_fiber_size": 4,
                            "carry_free_mixed_moment_vanishing": {
                                "maximum_total_degree": q - 2,
                                "constraint_count": carry_free_mixed_moments,
                                "criterion": (
                                    "base-3 addition of positive exponents "
                                    "has no carry"
                                ),
                            },
                            "ternary_dual_incidence_word": {
                                "formula": "1_D-1_L_infty-1_V",
                                "symbol_counts": triangular_dual_word,
                                "weight": 3 * q,
                                "line_code_membership_proved": False,
                                "signed_line_profiles": (
                                    triangular_dual_word_line_profiles
                                ),
                            },
                            "frobenius_fiber_quadratic_normal_form": (
                                frobenius_fiber_normal_form
                            ),
                            "full_core_direction_ledger": {
                                "two_vertex_directions": {
                                    "3_secants": 1,
                                    "2_secants": q - 1,
                                },
                                "three_infinity_boundary_directions": {
                                    "1_secants": q // 3 - 1,
                                    "2_secants": 1,
                                    "4_secants": 2 * q // 3,
                                },
                                "remaining_direction_count": q - 4,
                                "remaining_direction_profile": {
                                    "1_secants": 2 * q // 3 - 1,
                                    "2_secants": 1,
                                    "4_secants": q // 3,
                                },
                                "third_connector_3_secants": 1,
                            },
                        },
                    },
                    "vertex_line_profile": {
                        str(degree): count for degree, count
                        in triangle_j4_vertex_line_profile.items()
                    },
                    "generic_or_tangent_line_profile": {
                        str(degree): count for degree, count
                        in triangle_j4_generic_line_profile.items()
                    },
                },
                "j5_mixed_core_spectrum": {
                    str(degree): count for degree, count
                    in triangle_j5_spectrum.items()
                },
            },
        })

    output.write_text(json.dumps({
        "schema": "c949-sharp-linear-coefficient-audit-v2",
        "scope": (
            "exact arithmetic replay only; the line-code representation and "
            "pointwise/geometric inequalities remain human-proof dependencies"
        ),
        "asymptotic_compression": {
            "support_invariant": "t >= 3",
            "signed_capacity_invariant": "t <= 1+6 alpha+o(1)",
            "consequence": "alpha >= 1/3",
        },
        "endpoint_candidates_before_exact_geometry": [
            list(row) for row in endpoint_candidates
        ],
        "endpoint_candidates_after_norm_and_scalar_checks": [
            [1, -3], [2, -1], [3, 1], [4, -3], [4, 3], [5, -1]
        ],
        "raw_concurrent_rows_for_sublinear_repair": [
            list(row) for row in raw_concurrent_rows
        ],
        "raw_triangular_connector_rows_for_sublinear_repair": [
            list(row) for row in raw_triangular_rows
        ],
        "raw_triangular_connector_degrees": triangular_connector_degrees,
        "triangular_connector_survivors_after_adjacent_core_overload": [
            [4, -3], [5, -1]
        ],
        "field_checks": field_checks,
        "checked": True,
    }, indent=2, sort_keys=True) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    emit = subparsers.add_parser("emit-blocking-lp")
    emit.add_argument("--q", type=int, required=True)
    emit.add_argument("--t", type=int, required=True)
    emit.add_argument("--output", type=Path, required=True)
    certify = subparsers.add_parser("certify-highs")
    certify.add_argument("--q", type=int, required=True)
    certify.add_argument("--t", type=int, required=True)
    certify.add_argument("--solution", type=Path, required=True)
    certify.add_argument("--output", type=Path, required=True)
    solve = subparsers.add_parser("solve-cpsat")
    solve.add_argument("--q", type=int, required=True)
    solve.add_argument("--t", type=int, required=True)
    solve.add_argument("--output", type=Path, required=True)
    solve.add_argument("--seconds", type=float, default=300.0)
    solve.add_argument("--workers", type=int, default=8)
    solve.add_argument("--size", type=int)
    solve.add_argument("--tangent-count", type=int)
    solve.add_argument("--maximum-external-degree", type=int)
    check = subparsers.add_parser("check")
    check.add_argument("certificate", type=Path)
    two_character = subparsers.add_parser("two-character-audit")
    two_character.add_argument("--q", type=int, required=True)
    two_character.add_argument("--size-min", type=int, required=True)
    two_character.add_argument("--size-max", type=int, required=True)
    two_character.add_argument("--output", type=Path, required=True)
    symmetry = subparsers.add_parser("symmetry-cpsat")
    symmetry.add_argument("--q", type=int, required=True)
    symmetry.add_argument("--t", type=int, required=True)
    symmetry.add_argument("--symmetry", choices=("trace-x", "trace-xy", "scalar-13", "frobenius"), required=True)
    symmetry.add_argument("--output", type=Path, required=True)
    symmetry.add_argument("--seconds", type=float, default=300.0)
    symmetry.add_argument("--workers", type=int, default=8)
    extract = subparsers.add_parser("extract-selected-secants")
    extract.add_argument("--certificate", type=Path, required=True)
    extract.add_argument("--output", type=Path, required=True)
    inverse = subparsers.add_parser("weak-inverse-cpsat")
    inverse.add_argument("--q", type=int, required=True)
    inverse.add_argument("--arc-intersection", type=int, required=True)
    inverse.add_argument("--family", type=Path, required=True)
    inverse.add_argument("--output", type=Path, required=True)
    inverse.add_argument("--seconds", type=float, default=300.0)
    inverse.add_argument("--workers", type=int, default=8)
    inverse_check = subparsers.add_parser("check-weak-inverse")
    inverse_check.add_argument("certificate", type=Path)
    orbit_audit = subparsers.add_parser("symmetry-orbit-audit")
    orbit_audit.add_argument("--q", type=int, required=True)
    orbit_audit.add_argument("--output", type=Path, required=True)
    fixed_subplane = subparsers.add_parser("frobenius-fixed-subplane-audit")
    fixed_subplane.add_argument("--output", type=Path, required=True)
    degree_defect = subparsers.add_parser("degree-defect-audit")
    degree_defect.add_argument("--q9-construction", type=Path, required=True)
    degree_defect.add_argument("--frobenius-audit", type=Path, required=True)
    degree_defect.add_argument("--output", type=Path, required=True)
    hull_mechanism = subparsers.add_parser("frobenius-hull-mechanism-audit")
    hull_mechanism.add_argument("--frobenius-audit", type=Path, required=True)
    hull_mechanism.add_argument("--output", type=Path, required=True)
    exact_target = subparsers.add_parser("exact-target-obstruction-audit")
    exact_target.add_argument("--output", type=Path, required=True)
    sharp_linear = subparsers.add_parser("sharp-linear-coefficient-audit")
    sharp_linear.add_argument("--output", type=Path, required=True)
    structure = subparsers.add_parser("analyze-blocking-certificate")
    structure.add_argument("--certificate", type=Path, required=True)
    structure.add_argument("--output", type=Path, required=True)
    unital_mechanism = subparsers.add_parser("analyze-unital-mechanism")
    unital_mechanism.add_argument("--certificate", type=Path, required=True)
    unital_mechanism.add_argument("--output", type=Path, required=True)
    q9_construction = subparsers.add_parser("construct-q9-unital-arc")
    q9_construction.add_argument("--output", type=Path, required=True)
    five_character = subparsers.add_parser("five-character-core-cpsat")
    five_character.add_argument("--q", type=int, required=True)
    five_character.add_argument(
        "--symmetry", choices=("none", "trace-x", "trace-xy", "scalar-13", "frobenius"),
        default="none",
    )
    five_character.add_argument("--output", type=Path, required=True)
    five_character.add_argument("--seconds", type=float, default=300.0)
    five_character.add_argument("--workers", type=int, default=8)
    core_search = subparsers.add_parser("five-character-core-search")
    core_search.add_argument("--q", type=int, required=True)
    core_search.add_argument(
        "--symmetry", choices=("none", "trace-x", "trace-xy", "scalar-13", "frobenius"),
        default="none",
    )
    core_search.add_argument("--output", type=Path, required=True)
    core_search.add_argument("--seconds", type=float, default=300.0)
    core_search.add_argument("--workers", type=int, default=8)
    core_search.add_argument("--fixed-core-points", type=int)
    core_search.add_argument("--fixed-core-indices", type=int, nargs="+")
    core_search.add_argument("--fixed-line-type-counts", type=int, nargs=5)
    core_search.add_argument("--fixed-line-degrees", type=int, nargs="+")
    core_search.add_argument("--require-concurrency-cap", action="store_true")
    core_search.add_argument("--require-exact-maximal-core", action="store_true")
    core_lift = subparsers.add_parser("five-character-core-lift")
    core_lift.add_argument("--core", type=Path, required=True)
    core_lift.add_argument("--output", type=Path, required=True)
    core_lift.add_argument("--seconds", type=float, default=300.0)
    core_lift.add_argument("--workers", type=int, default=8)
    args = parser.parse_args()
    if args.command == "emit-blocking-lp":
        emit_blocking_lp(args.q, args.t, args.output)
    elif args.command == "certify-highs":
        make_certificate(args.q, args.t, args.solution, args.output)
    elif args.command == "solve-cpsat":
        solve_cpsat(args.q, args.t, args.output, args.seconds, args.workers,
                    args.size, args.tangent_count, args.maximum_external_degree)
    elif args.command == "two-character-audit":
        audit_two_character(args.q, args.size_min, args.size_max, args.output)
    elif args.command == "symmetry-cpsat":
        solve_symmetry_cpsat(args.q, args.t, args.symmetry, args.output,
                             args.seconds, args.workers)
    elif args.command == "extract-selected-secants":
        extract_selected_secants(args.certificate, args.output)
    elif args.command == "weak-inverse-cpsat":
        solve_weak_inverse(args.q, args.arc_intersection, args.family, args.output,
                           args.seconds, args.workers)
    elif args.command == "check-weak-inverse":
        check_weak_inverse(args.certificate)
    elif args.command == "symmetry-orbit-audit":
        audit_symmetry_orbits(args.q, args.output)
    elif args.command == "frobenius-fixed-subplane-audit":
        audit_frobenius_fixed_subplane(args.output)
    elif args.command == "degree-defect-audit":
        audit_degree_defect(args.q9_construction, args.frobenius_audit, args.output)
    elif args.command == "frobenius-hull-mechanism-audit":
        audit_frobenius_hull_mechanism(args.frobenius_audit, args.output)
    elif args.command == "exact-target-obstruction-audit":
        audit_exact_target_obstruction(args.output)
    elif args.command == "sharp-linear-coefficient-audit":
        audit_sharp_linear_coefficient(args.output)
    elif args.command == "analyze-blocking-certificate":
        analyze_blocking_certificate(args.certificate, args.output)
    elif args.command == "analyze-unital-mechanism":
        analyze_unital_mechanism(args.certificate, args.output)
    elif args.command == "construct-q9-unital-arc":
        construct_q9_unital_arc(args.output)
    elif args.command == "five-character-core-cpsat":
        solve_five_character_core(args.q, args.symmetry, args.output,
                                  args.seconds, args.workers)
    elif args.command == "five-character-core-search":
        search_five_character_core(args.q, args.symmetry, args.output,
                                   args.seconds, args.workers, args.fixed_core_points,
                                   args.fixed_line_type_counts, args.fixed_core_indices,
                                   args.fixed_line_degrees,
                                   args.require_concurrency_cap,
                                   args.require_exact_maximal_core)
    elif args.command == "five-character-core-lift":
        lift_five_character_core(args.core, args.output, args.seconds, args.workers)
    else:
        check_certificate(args.certificate)


if __name__ == "__main__":
    main()
