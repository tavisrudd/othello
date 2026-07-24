#!/usr/bin/env python3
"""Test the direct-sum parabola arc in PG(2, 2^(2m)).

The output records ordinary uncovered loci and quadratic evaluation ranks.
All arithmetic is deterministic and dependency-free.
"""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from functools import cache
from pathlib import Path


Point = tuple[int, int, int]


def degree(poly: int) -> int:
    return poly.bit_length() - 1


def poly_mod(value: int, modulus: int) -> int:
    modulus_degree = degree(modulus)
    while degree(value) >= modulus_degree:
        value ^= modulus << (degree(value) - modulus_degree)
    return value


def poly_mul_mod(a: int, b: int, modulus: int) -> int:
    value = 0
    while b:
        if b & 1:
            value ^= a
        b >>= 1
        a <<= 1
    return poly_mod(value, modulus)


def is_irreducible(poly: int, n: int) -> bool:
    for divisor_degree in range(1, n // 2 + 1):
        for tail in range(1 << divisor_degree):
            divisor = (1 << divisor_degree) | tail
            if divisor & 1 and poly_mod(poly, divisor) == 0:
                return False
    return True


def smallest_irreducible(n: int) -> int:
    for tail in range(1, 1 << n, 2):
        candidate = (1 << n) | tail
        if is_irreducible(candidate, n):
            return candidate
    raise AssertionError("irreducible polynomial not found")


class GF2N:
    def __init__(self, n: int):
        self.n = n
        self.order = 1 << n
        self.modulus = smallest_irreducible(n)

    def mul(self, a: int, b: int) -> int:
        return poly_mul_mod(a, b, self.modulus)

    def square(self, a: int) -> int:
        return self.mul(a, a)

    def power(self, a: int, exponent: int) -> int:
        value = 1
        while exponent:
            if exponent & 1:
                value = self.mul(value, a)
            a = self.square(a)
            exponent >>= 1
        return value

    def inverse(self, a: int) -> int:
        if not a:
            raise ZeroDivisionError
        return self.power(a, self.order - 2)


@cache
def line_data(
    m: int,
) -> tuple[GF2N, tuple[int, ...], int, tuple[frozenset[int], ...]]:
    field = GF2N(2 * m)
    q_sub = 1 << m
    subfield = tuple(
        value
        for value in range(field.order)
        if field.power(value, q_sub) == value
    )
    assert len(subfield) == q_sub
    omega = next(value for value in range(2, field.order) if value not in subfield)
    projective_lines = [
        frozenset(field.mul(alpha, value) for value in subfield)
        for alpha in range(1, field.order)
    ]
    unique_lines = sorted(set(projective_lines), key=lambda line: tuple(sorted(line)))
    assert len(unique_lines) == q_sub + 1
    first = frozenset(subfield)
    second = frozenset(field.mul(omega, value) for value in subfield)
    remaining = [line for line in unique_lines if line not in {first, second}]
    lines = (first, second, *remaining)
    return field, subfield, omega, lines


def field_data(
    m: int, line_indices: tuple[int, ...]
) -> tuple[GF2N, tuple[int, ...], int, tuple[int, ...]]:
    field, subfield, omega, lines = line_data(m)
    selected_lines = [lines[index] for index in line_indices]
    parameters = tuple(sorted(set().union(*selected_lines)))
    assert len(parameters) == 1 + len(line_indices) * (len(subfield) - 1)
    return field, subfield, omega, parameters


def chord_data(
    field: GF2N, parameters: tuple[int, ...]
) -> tuple[tuple[int, int], ...]:
    return tuple(
        sorted(
            (
                x ^ y,
                field.mul(x, y),
            )
            for x, y in itertools.combinations(parameters, 2)
        )
    )


def uncovered_points(
    field: GF2N,
    parameters: tuple[int, ...],
    chords: tuple[tuple[int, int], ...],
) -> tuple[Point, ...]:
    covered_affine: set[tuple[int, int]] = set()
    covered_directions: set[int] = set()
    for slope, intercept in chords:
        covered_directions.add(slope)
        for x_coord in range(field.order):
            y_coord = field.mul(slope, x_coord) ^ intercept
            covered_affine.add((x_coord, y_coord))

    arc_affine = {(x, field.square(x)) for x in parameters}
    uncovered = [
        (1, x, y)
        for x in range(field.order)
        for y in range(field.order)
        if (x, y) not in covered_affine and (x, y) not in arc_affine
    ]
    uncovered.extend(
        (0, 1, slope)
        for slope in range(field.order)
        if slope not in covered_directions
    )
    if (0, 0, 1) not in uncovered and all(
        point != (0, 0, 1) for point in uncovered
    ):
        # Every finite-slope chord misses the vertical point at infinity.
        uncovered.append((0, 0, 1))
    return tuple(sorted(uncovered))


def direct_uncovered_points(
    field: GF2N,
    parameters: tuple[int, ...],
) -> tuple[Point, ...]:
    points = [
        *((1, x, y) for x in range(field.order) for y in range(field.order)),
        *((0, 1, slope) for slope in range(field.order)),
        (0, 0, 1),
    ]
    arc = {(1, x, field.square(x)) for x in parameters}
    lines = []
    for x, y in itertools.combinations(parameters, 2):
        slope = x ^ y
        intercept = field.mul(x, y)
        lines.append((intercept, slope, 1))
    return tuple(
        sorted(
            point
            for point in points
            if point not in arc
            and not any(
                field.mul(line[0], point[0])
                ^ field.mul(line[1], point[1])
                ^ field.mul(line[2], point[2])
                == 0
                for line in lines
            )
        )
    )


def quadratic_row(field: GF2N, point: Point) -> list[int]:
    x, y, z = point
    return [
        field.square(x),
        field.square(y),
        field.square(z),
        field.mul(x, y),
        field.mul(x, z),
        field.mul(y, z),
    ]


def kernel_basis(field: GF2N, rows: list[list[int]]) -> list[list[int]]:
    matrix = [row[:] for row in rows]
    pivots: list[int] = []
    pivot_row = 0
    for column in range(6):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(matrix))
                if matrix[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = field.inverse(matrix[pivot_row][column])
        matrix[pivot_row] = [
            field.mul(value, inverse) for value in matrix[pivot_row]
        ]
        for row in range(len(matrix)):
            factor = matrix[row][column]
            if row != pivot_row and factor:
                matrix[row] = [
                    a ^ field.mul(factor, b)
                    for a, b in zip(
                        matrix[row], matrix[pivot_row], strict=True
                    )
                ]
        pivots.append(column)
        pivot_row += 1

    free = [column for column in range(6) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * 6
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = matrix[row][free_column]
        basis.append(vector)
    return basis


def quadratic_rank(field: GF2N, points: list[Point]) -> int:
    return 6 - len(
        kernel_basis(
            field,
            [quadratic_row(field, point) for point in points],
        )
    )


def quadratic_rank_witness(
    field: GF2N, points: tuple[Point, ...]
) -> tuple[Point, ...]:
    witness: list[Point] = []
    current_rank = 0
    for point in points:
        candidate_rank = quadratic_rank(field, [*witness, point])
        if candidate_rank > current_rank:
            witness.append(point)
            current_rank = candidate_rank
            if current_rank == 6:
                break
    return tuple(witness)


def evaluate_quadratic(
    field: GF2N, coefficients: list[int], point: Point
) -> int:
    value = 0
    for coefficient, monomial in zip(
        coefficients, quadratic_row(field, point), strict=True
    ):
        value ^= field.mul(coefficient, monomial)
    return value


def nonsingular_quadratic(field: GF2N, coefficients: list[int]) -> bool:
    _, _, _, d, e, f = coefficients
    if d == e == f == 0:
        return False
    radical = (f, e, d)
    return evaluate_quadratic(field, coefficients, radical) != 0


def analyze(
    m: int,
    line_indices: tuple[int, ...],
    direct_replay: bool,
    parameters_override: tuple[int, ...] | None = None,
    family: dict[str, object] | None = None,
) -> dict[str, object]:
    field, subfield, omega, parameters = field_data(m, line_indices)
    if parameters_override is not None:
        parameters = parameters_override
    chords = chord_data(field, parameters)
    assert len(chords) == len(set(chords))
    uncovered = uncovered_points(field, parameters, chords)
    direct_match: bool | None = None
    if direct_replay:
        direct_match = uncovered == direct_uncovered_points(field, parameters)
        assert direct_match

    basis = kernel_basis(
        field,
        [quadratic_row(field, point) for point in uncovered],
    )
    rank_witness = quadratic_rank_witness(field, uncovered)
    coordinate_map = {
        u ^ field.mul(omega, v): (u, v)
        for u in subfield
        for v in subfield
    }
    unique = basis[0] if len(basis) == 1 else None
    arc_points = [(1, x, field.square(x)) for x in parameters]
    return {
        "m": m,
        "q": field.order,
        "Q": len(subfield),
        "line_count": len(line_indices),
        "line_indices": list(line_indices),
        "family": family,
        "modulus": field.modulus,
        "omega": omega,
        "arc_size": len(parameters),
        "secant_count": len(chords),
        "direction_count": len({slope for slope, _ in chords}),
        "uncovered_size": len(uncovered),
        "uncovered_infinity": [
            list(point) for point in uncovered if point[0] == 0
        ],
        "quadratic_rank": 6 - len(basis),
        "quadratic_nullity": len(basis),
        "quadratic_rank_witness": [
            {
                "point": list(point),
                "uv": [
                    list(coordinate_map[coordinate])
                    for coordinate in point[1:]
                ]
                if point[0] == 1
                else None,
            }
            for point in rank_witness
        ],
        "unique_quadratic": unique,
        "unique_avoids_arc": (
            all(evaluate_quadratic(field, unique, point) for point in arc_points)
            if unique is not None
            else None
        ),
        "unique_nonsingular": (
            nonsingular_quadratic(field, unique)
            if unique is not None
            else None
        ),
        "direct_replay": direct_match,
    }


def sweep(m: int, line_count: int) -> dict[str, object]:
    _, subfield, _, lines = line_data(m)
    assert len(lines) == len(subfield) + 1
    records = []
    # Multiplication by a nonzero field element is a projectivity of the
    # parabola and is transitive on the U-lines, so fix line zero.
    for tail in itertools.combinations(range(1, len(lines)), line_count - 1):
        record = analyze(m, (0, *tail), direct_replay=False)
        records.append(record)
    histogram = Counter(
        (
            record["uncovered_size"],
            record["quadratic_nullity"],
            record["unique_avoids_arc"],
            record["unique_nonsingular"],
        )
        for record in records
    )
    return {
        "m": m,
        "Q": len(subfield),
        "line_count": line_count,
        "normalized_subset_count": len(records),
        "histogram": [
            {
                "uncovered_size": key[0],
                "quadratic_nullity": key[1],
                "unique_avoids_arc": key[2],
                "unique_nonsingular": key[3],
                "count": count,
            }
            for key, count in sorted(
                histogram.items(),
                key=lambda item: tuple(
                    -1 if value is None else value for value in item[0]
                ),
            )
        ],
        "quadratic_survivors": [
            {
                "line_indices": record["line_indices"],
                "arc_size": record["arc_size"],
                "uncovered_size": record["uncovered_size"],
                "quadratic_nullity": record["quadratic_nullity"],
                "unique_quadratic": record["unique_quadratic"],
                "unique_avoids_arc": record["unique_avoids_arc"],
                "unique_nonsingular": record["unique_nonsingular"],
            }
            for record in records
            if record["quadratic_nullity"]
        ],
        "full_rank_certificates": [
            {
                "line_indices": record["line_indices"],
                "points": [
                    witness["point"]
                    for witness in record["quadratic_rank_witness"]
                ],
            }
            for record in records
            if record["quadratic_nullity"] == 0
        ],
    }


def graph_parameters(
    m: int, coefficient: int, exponent: int
) -> tuple[int, ...]:
    field, subfield, omega, _ = line_data(m)
    graph = {
        field.mul(
            coefficient,
            field.power(value, exponent),
        )
        ^ field.mul(omega, value)
        for value in subfield
    }
    return tuple(sorted(set(subfield) | graph))


def graph_monomial_sweep(m: int) -> dict[str, object]:
    _, subfield, _, _ = line_data(m)
    parameter_families: dict[tuple[int, ...], list[tuple[int, int]]] = {}
    for exponent in range(1, len(subfield)):
        for coefficient in subfield:
            parameters = graph_parameters(m, coefficient, exponent)
            assert len(parameters) == 2 * len(subfield) - 1
            parameter_families.setdefault(parameters, []).append(
                (coefficient, exponent)
            )

    records = []
    for parameters, descriptors in sorted(parameter_families.items()):
        coefficient, exponent = descriptors[0]
        record = analyze(
            m,
            (0, 1),
            direct_replay=False,
            parameters_override=parameters,
            family={
                "kind": "monomial_graph",
                "coefficient": coefficient,
                "exponent": exponent,
                "alias_count": len(descriptors),
            },
        )
        records.append(record)

    histogram = Counter(
        (
            record["uncovered_size"],
            record["quadratic_nullity"],
            record["unique_avoids_arc"],
            record["unique_nonsingular"],
        )
        for record in records
    )
    return {
        "m": m,
        "Q": len(subfield),
        "raw_parameter_count": len(subfield) * (len(subfield) - 1),
        "distinct_parameter_sets": len(records),
        "histogram": [
            {
                "uncovered_size": key[0],
                "quadratic_nullity": key[1],
                "unique_avoids_arc": key[2],
                "unique_nonsingular": key[3],
                "count": count,
            }
            for key, count in sorted(
                histogram.items(),
                key=lambda item: tuple(
                    -1 if value is None else value for value in item[0]
                ),
            )
        ],
        "quadratic_survivors": [
            {
                "family": record["family"],
                "arc_size": record["arc_size"],
                "uncovered_size": record["uncovered_size"],
                "quadratic_nullity": record["quadratic_nullity"],
                "unique_quadratic": record["unique_quadratic"],
                "unique_avoids_arc": record["unique_avoids_arc"],
                "unique_nonsingular": record["unique_nonsingular"],
            }
            for record in records
            if record["quadratic_nullity"]
        ],
        "full_rank_certificates": [
            {
                "family": record["family"],
                "points": [
                    witness["point"]
                    for witness in record["quadratic_rank_witness"]
                ],
            }
            for record in records
            if record["quadratic_nullity"] == 0
        ],
    }


def subfield_binary_coordinates(
    subfield: tuple[int, ...], m: int
) -> tuple[tuple[int, ...], dict[int, int]]:
    basis: list[int] = []
    span = {0}
    for value in subfield:
        if value in span:
            continue
        basis.append(value)
        span |= {entry ^ value for entry in tuple(span)}
        if len(basis) == m:
            break
    assert len(span) == len(subfield)
    coordinates = {}
    for mask in range(1 << m):
        value = 0
        for index, basis_value in enumerate(basis):
            if mask >> index & 1:
                value ^= basis_value
        coordinates[value] = mask
    return tuple(basis), coordinates


def linear_graph_parameters(m: int, images: tuple[int, ...]) -> tuple[int, ...]:
    field, subfield, omega, _ = line_data(m)
    _, coordinates = subfield_binary_coordinates(subfield, m)
    graph = set()
    for value in subfield:
        mapped = 0
        mask = coordinates[value]
        for index, image in enumerate(images):
            if mask >> index & 1:
                mapped ^= image
        graph.add(mapped ^ field.mul(omega, value))
    return tuple(sorted(set(subfield) | graph))


def linear_graph_sweep(m: int) -> dict[str, object]:
    _, subfield, _, _ = line_data(m)
    basis, _ = subfield_binary_coordinates(subfield, m)
    parameter_families: dict[tuple[int, ...], list[tuple[int, ...]]] = {}
    for images in itertools.product(subfield, repeat=m):
        parameters = linear_graph_parameters(m, images)
        parameter_families.setdefault(parameters, []).append(images)

    records = []
    for parameters, image_families in sorted(parameter_families.items()):
        images = image_families[0]
        records.append(
            analyze(
                m,
                (0, 1),
                direct_replay=False,
                parameters_override=parameters,
                family={
                    "kind": "binary_linear_graph",
                    "basis": list(basis),
                    "images": list(images),
                    "alias_count": len(image_families),
                },
            )
        )
    histogram = Counter(
        (
            record["uncovered_size"],
            record["quadratic_nullity"],
            record["unique_avoids_arc"],
            record["unique_nonsingular"],
        )
        for record in records
    )
    return {
        "m": m,
        "Q": len(subfield),
        "raw_map_count": len(subfield) ** m,
        "distinct_parameter_sets": len(records),
        "histogram": [
            {
                "uncovered_size": key[0],
                "quadratic_nullity": key[1],
                "unique_avoids_arc": key[2],
                "unique_nonsingular": key[3],
                "count": count,
            }
            for key, count in sorted(
                histogram.items(),
                key=lambda item: tuple(
                    -1 if value is None else value for value in item[0]
                ),
            )
        ],
        "quadratic_survivors": [
            {
                "family": record["family"],
                "arc_size": record["arc_size"],
                "uncovered_size": record["uncovered_size"],
                "quadratic_nullity": record["quadratic_nullity"],
                "unique_quadratic": record["unique_quadratic"],
                "unique_avoids_arc": record["unique_avoids_arc"],
                "unique_nonsingular": record["unique_nonsingular"],
            }
            for record in records
            if record["quadratic_nullity"]
        ],
        "full_rank_certificates": [
            {
                "family": record["family"],
                "points": [
                    witness["point"]
                    for witness in record["quadratic_rank_witness"]
                ],
            }
            for record in records
            if record["quadratic_nullity"] == 0
        ],
    }


def point_is_uncovered(
    field: GF2N, parameters: tuple[int, ...], point: Point
) -> bool:
    if point in {
        (1, value, field.square(value))
        for value in parameters
    }:
        return False
    for x, y in itertools.combinations(parameters, 2):
        slope = x ^ y
        intercept = field.mul(x, y)
        if (
            field.mul(intercept, point[0])
            ^ field.mul(slope, point[1])
            ^ point[2]
        ) == 0:
            return False
    return True


def verify_full_rank_certificate(
    m: int, parameters: tuple[int, ...], points: list[list[int]]
) -> None:
    field, _, _, _ = line_data(m)
    witness = tuple(tuple(point) for point in points)
    assert len(witness) == 6
    assert all(point_is_uncovered(field, parameters, point) for point in witness)
    assert quadratic_rank(field, list(witness)) == 6


def verify_certificates(evidence: dict[str, object]) -> None:
    if evidence["schema"] != "c557-direct-sum-parabola-v9":
        raise ValueError("unexpected evidence schema")
    for case in evidence["cases"]:
        if case["quadratic_nullity"] != 0:
            continue
        m = case["m"]
        _, _, _, parameters = field_data(m, tuple(case["line_indices"]))
        verify_full_rank_certificate(
            m,
            parameters,
            [entry["point"] for entry in case["quadratic_rank_witness"]],
        )
    for sweep_record in evidence["q64_normalized_sweeps"]:
        certificates = sweep_record["full_rank_certificates"]
        survivors = sweep_record["quadratic_survivors"]
        assert (
            len(certificates) + len(survivors)
            == sweep_record["normalized_subset_count"]
        )
        for certificate in certificates:
            indices = tuple(certificate["line_indices"])
            _, _, _, parameters = field_data(3, indices)
            verify_full_rank_certificate(3, parameters, certificate["points"])
    for sweep_record in evidence["monomial_graph_sweeps"]:
        certificates = sweep_record["full_rank_certificates"]
        survivors = sweep_record["quadratic_survivors"]
        assert (
            len(certificates) + len(survivors)
            == sweep_record["distinct_parameter_sets"]
        )
        m = sweep_record["m"]
        for certificate in certificates:
            family = certificate["family"]
            parameters = graph_parameters(
                m,
                family["coefficient"],
                family["exponent"],
            )
            verify_full_rank_certificate(m, parameters, certificate["points"])
    for sweep_record in evidence["linear_graph_sweeps"]:
        certificates = sweep_record["full_rank_certificates"]
        survivors = sweep_record["quadratic_survivors"]
        assert (
            len(certificates) + len(survivors)
            == sweep_record["distinct_parameter_sets"]
        )
        m = sweep_record["m"]
        for certificate in certificates:
            images = tuple(certificate["family"]["images"])
            parameters = linear_graph_parameters(m, images)
            verify_full_rank_certificate(m, parameters, certificate["points"])


def payload() -> dict[str, object]:
    return {
        "schema": "c557-direct-sum-parabola-v9",
        "cases": [
            analyze(
                m,
                tuple(range(line_count)),
                direct_replay=m <= 3,
            )
            for m in (2, 3, 4)
            for line_count in range(2, min(6, (1 << m) + 1) + 1)
        ],
        "q64_normalized_sweeps": [
            sweep(3, line_count)
            for line_count in range(2, 10)
        ],
        "monomial_graph_sweeps": [
            graph_monomial_sweep(m)
            for m in (3, 4)
        ],
        "linear_graph_sweeps": [
            linear_graph_sweep(3),
        ],
    }


def canonical_json(value: object) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-evidence", type=Path)
    parser.add_argument("--check-evidence", type=Path)
    parser.add_argument("--verify-certificates", type=Path)
    args = parser.parse_args()
    if args.verify_certificates is not None:
        verify_certificates(
            json.loads(args.verify_certificates.read_text(encoding="utf-8"))
        )
        print("certificates OK")
        return
    text = canonical_json(payload())
    if args.write_evidence is not None:
        args.write_evidence.write_text(text, encoding="utf-8")
    elif args.check_evidence is not None:
        if args.check_evidence.read_text(encoding="utf-8") != text:
            raise SystemExit("evidence mismatch")
        print("evidence OK")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
