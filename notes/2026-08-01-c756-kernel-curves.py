#!/usr/bin/env python3
"""Extract and certify the three exceptional C756 missing-set kernel curves."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations, product
import json
from pathlib import Path

import flint
from flint import nmod_mpoly_ctx
import sympy
from sympy import diff, groebner, symbols


HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-08-01-c756-masked-rs-collision-audit.json"
OUTPUT = HERE / "2026-08-01-c756-kernel-curves.json"
CASES = {13: 4, 29: 7, 31: 6}


def normalize(vector: tuple[int, ...], q: int) -> tuple[int, ...]:
    for value in reversed(vector):
        if value % q:
            scale = pow(value, -1, q)
            return tuple(entry * scale % q for entry in vector)
    raise AssertionError("zero projective vector")


def cross(left: tuple[int, int, int], right: tuple[int, int, int], q: int):
    return normalize((
        left[1] * right[2] - left[2] * right[1],
        left[2] * right[0] - left[0] * right[2],
        left[0] * right[1] - left[1] * right[0],
    ), q)


def projective_points(q: int):
    return ([(x, y, 1) for x in range(q) for y in range(q)]
            + [(x, 1, 0) for x in range(q)] + [(1, 0, 0)])


def dot(left, right, q: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % q


def monomial_exponents(degree: int):
    return [(a, b, degree - a - b)
            for a in range(degree + 1) for b in range(degree - a + 1)]


def rref_mod_q(matrix: list[list[int]], q: int):
    matrix = [row[:] for row in matrix]
    pivots = []
    row = 0
    columns = len(matrix[0]) if matrix else 0
    for column in range(columns):
        pivot = next((r for r in range(row, len(matrix))
                      if matrix[r][column] % q), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        scale = pow(matrix[row][column], -1, q)
        matrix[row] = [entry * scale % q for entry in matrix[row]]
        for other in range(len(matrix)):
            if other != row and matrix[other][column] % q:
                factor = matrix[other][column]
                matrix[other] = [
                    (left - factor * right) % q
                    for left, right in zip(matrix[other], matrix[row])
                ]
        pivots.append(column)
        row += 1
        if row == len(matrix):
            break
    return matrix, pivots


def one_dimensional_kernel(matrix: list[list[int]], q: int):
    rref, pivots = rref_mod_q(matrix, q)
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    assert len(free) == 1
    vector = [0] * len(matrix[0])
    vector[free[0]] = 1
    for row, column in enumerate(pivots):
        vector[column] = -rref[row][free[0]] % q
    # Canonical projective normalization: the x^d coefficient is one.
    assert vector[-1]
    scale = pow(vector[-1], -1, q)
    vector = [entry * scale % q for entry in vector]
    assert all(sum(a * b for a, b in zip(row, vector)) % q == 0
               for row in matrix)
    return vector, len(pivots)


def evaluate(coefficients, exponents, point, q: int) -> int:
    x, y, z = point
    return sum(
        coefficient * pow(x, a, q) * pow(y, b, q) * pow(z, c, q)
        for coefficient, (a, b, c) in zip(coefficients, exponents)
    ) % q


def gradient(coefficients, exponents, point, q: int):
    answer = []
    for coordinate in range(3):
        value = 0
        for coefficient, exponent in zip(coefficients, exponents):
            if exponent[coordinate] == 0:
                continue
            reduced = list(exponent)
            reduced[coordinate] -= 1
            term = coefficient * exponent[coordinate]
            for base, power in zip(point, reduced):
                term *= pow(base, power, q)
            value += term
        answer.append(value % q)
    return tuple(answer)


def pgl2(q: int):
    """Canonical normalized representatives of PGL(2,q)."""
    for leading_zeroes in range(4):
        for tail in product(range(q), repeat=3 - leading_zeroes):
            matrix = (0,) * leading_zeroes + (1,) + tail
            a, b, c, d = matrix
            if (a * d - b * c) % q:
                yield matrix


def pgl2_multiply(left, right, q: int):
    a, b, c, d = left
    e, f, g, h = right
    return normalize(((a * e + b * g) % q, (a * f + b * h) % q,
                      (c * e + d * g) % q, (c * f + d * h) % q), q)


def pgl2_order(element, q: int) -> int:
    value = (1, 0, 0, 1)
    for order in range(1, q * (q * q - 1) + 1):
        value = pgl2_multiply(value, element, q)
        if value == (1, 0, 0, 1):
            return order
    raise AssertionError("element order exceeded group order")


def conic_action(matrix, point, q: int):
    """The symmetric-square PGL(2,q) action preserving y^2=xz."""
    return normalize(raw_conic_action(matrix, point, q), q)


def raw_conic_action(matrix, point, q: int):
    a, b, c, d = matrix
    x, y, z = point
    return (
        (a * a * x + 2 * a * b * y + b * b * z) % q,
        (a * c * x + (a * d + b * c) * y + b * d * z) % q,
        (c * c * x + 2 * c * d * y + d * d * z) % q,
    )


def group_orbits(group, points, q: int):
    remaining = set(points)
    answer = []
    while remaining:
        point = min(remaining)
        orbit = {conic_action(element, point, q) for element in group}
        assert orbit <= remaining or orbit.isdisjoint(remaining) is False
        answer.append(orbit)
        remaining -= orbit
    return answer


def is_arc(points, q: int) -> bool:
    return all(dot(cross(left, right, q), third, q)
               for left, right, third in combinations(points, 3))


def is_conic_external(points, conic, q: int) -> bool:
    return all(all(dot(cross(left, right, q), point, q)
                   for point in conic)
               for left, right in combinations(points, 2))


def orbit_unions_of_size(orbits, target: int):
    eligible = [orbit for orbit in orbits if len(orbit) <= target]

    def visit(index, chosen, size):
        if size == target:
            yield set().union(*chosen) if chosen else set()
            return
        if size > target:
            return
        for next_index in range(index, len(eligible)):
            orbit = eligible[next_index]
            yield from visit(next_index + 1, chosen + [orbit], size + len(orbit))

    yield from visit(0, [], 0)


def centered(value: int, q: int) -> int:
    return value if value <= q // 2 else value - q


def identify_group(order_profile) -> str:
    known = {
        ((1, 1), (2, 3), (3, 2)): "S3",
        ((1, 1), (2, 5), (5, 4)): "D10",
        ((1, 1), (2, 15), (3, 20), (5, 24)): "A5",
    }
    return known[tuple(sorted(order_profile.items()))]


def extract_case(q: int, degree: int, witness):
    witness = set(map(tuple, witness))
    points = projective_points(q)
    conic = {point for point in points
             if (point[1] * point[1] - point[0] * point[2]) % q == 0}
    chords = {cross(left, right, q) for left, right in combinations(witness, 2)}
    multiplicity = {
        point: sum(dot(line, point, q) == 0 for line in chords)
        for point in points
    }
    missing = {point for point in points
               if point not in conic and multiplicity[point] == 0}
    exponents = monomial_exponents(degree)
    evaluation_matrix = [[
        pow(x, a, q) * pow(y, b, q) * pow(z, c, q) % q
        for a, b, c in exponents
    ] for x, y, z in sorted(missing)]
    coefficients, rank = one_dimensional_kernel(evaluation_matrix, q)
    curve = {point for point in points
             if evaluate(coefficients, exponents, point, q) == 0}
    singular_rational = {point for point in curve
                         if gradient(coefficients, exponents, point, q) == (0, 0, 0)}
    assert missing <= curve

    # FLINT gives an independent exact factorization over the base field.
    context = nmod_mpoly_ctx.get(("x", "y", "z"), q)
    polynomial = context.from_dict({
        exponent: coefficient
        for exponent, coefficient in zip(exponents, coefficients) if coefficient
    })
    constant, factors = polynomial.factor()
    assert int(constant) == 1
    assert len(factors) == 1 and factors[0][1] == 1 and factors[0][0] == polynomial

    # Three affine charts cover P^2. Unit Jacobian ideals certify geometric
    # smoothness; a smooth positive-degree plane curve is absolutely irreducible.
    sx, sy, sz = symbols("x y z")
    variables = (sx, sy, sz)
    expression = sum(
        coefficient * sx ** a * sy ** b * sz ** c
        for coefficient, (a, b, c) in zip(coefficients, exponents)
    )
    smooth_chart_certificates = {}
    for chart in variables:
        chart_expression = expression.subs(chart, 1)
        remaining = [variable for variable in variables if variable != chart]
        basis = groebner(
            [chart_expression] + [diff(chart_expression, variable)
                                  for variable in remaining],
            *remaining, modulus=q,
        )
        is_unit = len(basis.polys) == 1 and basis.polys[0].as_expr() == 1
        assert is_unit
        smooth_chart_certificates[str(chart)] = "unit_ideal"

    # The degree-d rational point set also determines the polynomial line.
    curve_matrix = [[
        pow(x, a, q) * pow(y, b, q) * pow(z, c, q) % q
        for a, b, c in exponents
    ] for x, y, z in sorted(curve)]
    _, curve_pivots = rref_mod_q(curve_matrix, q)
    curve_kernel_dimension = len(exponents) - len(curve_pivots)
    assert curve_kernel_dimension == 1

    all_pgl2 = list(pgl2(q))
    witness_stabilizer = [
        element for element in all_pgl2
        if {conic_action(element, point, q) for point in witness} == witness
    ]
    curve_stabilizer = [
        element for element in all_pgl2
        if {conic_action(element, point, q) for point in curve} == curve
    ]
    assert set(witness_stabilizer) == set(curve_stabilizer)
    order_profile = dict(sorted(Counter(
        pgl2_order(element, q) for element in witness_stabilizer
    ).items()))

    # Measure how much of the curve is forced by its stabilizer character.
    # A pivot set of point evaluations determines every degree-d form because
    # d<q.  On that set, impose F(gP)=lambda_g F(P) for every stabilizer element.
    full_evaluation = [[
        pow(x, a, q) * pow(y, b, q) * pow(z, c, q) % q
        for a, b, c in exponents
    ] for x, y, z in points]
    _, determining_indices = rref_mod_q(
        [list(column) for column in zip(*full_evaluation)], q
    )
    assert len(determining_indices) == len(exponents)
    determining_points = [points[index] for index in determining_indices]
    character_values = []
    character_constraints = []
    conic_power_same_character = degree % 2 == 0
    test_point = next(point for point in points
                      if evaluate(coefficients, exponents, point, q))
    test_value = evaluate(coefficients, exponents, test_point, q)
    for element in witness_stabilizer:
        transformed_test = raw_conic_action(element, test_point, q)
        scalar = (evaluate(coefficients, exponents, transformed_test, q)
                  * pow(test_value, -1, q)) % q
        character_values.append(scalar)
        assert all(
            evaluate(coefficients, exponents,
                     raw_conic_action(element, point, q), q)
            == scalar * evaluate(coefficients, exponents, point, q) % q
            for point in points
        )
        if degree % 2 == 0:
            half_degree = degree // 2
            conic_power_same_character &= all(
                ((transformed[1] * transformed[1]
                  - transformed[0] * transformed[2]) ** half_degree
                 - scalar * (point[1] * point[1]
                             - point[0] * point[2]) ** half_degree) % q == 0
                for point in points
                for transformed in [raw_conic_action(element, point, q)]
            )
        for point in determining_points:
            transformed = raw_conic_action(element, point, q)
            character_constraints.append([
                (pow(transformed[0], a, q) * pow(transformed[1], b, q)
                 * pow(transformed[2], c, q)
                 - scalar * pow(point[0], a, q) * pow(point[1], b, q)
                 * pow(point[2], c, q)) % q
                for a, b, c in exponents
            ])
    _, character_pivots = rref_mod_q(character_constraints, q)
    character_space_dimension = len(exponents) - len(character_pivots)

    off_conic_orbits = group_orbits(witness_stabilizer, set(points) - conic, q)
    missing_orbits = group_orbits(witness_stabilizer, missing, q)
    conic_orbits = group_orbits(witness_stabilizer, conic, q)
    witness_orbits = group_orbits(witness_stabilizer, witness, q)

    invariant_arcs = []
    for candidate in orbit_unions_of_size(off_conic_orbits, len(witness)):
        if not is_arc(candidate, q) or not is_conic_external(candidate, conic, q):
            continue
        candidate_chords = {
            cross(left, right, q) for left, right in combinations(candidate, 2)
        }
        candidate_missing = {
            point for point in points
            if point not in conic
            and all(dot(line, point, q) for line in candidate_chords)
        }
        invariant_arcs.append({
            "is_selected_witness": candidate == witness,
            "missing_count": len(candidate_missing),
            "missing_lies_on_selected_curve": all(
                evaluate(coefficients, exponents, point, q) == 0
                for point in candidate_missing
            ),
        })
    invariant_arcs.sort(key=lambda row: (
        row["missing_count"], row["missing_lies_on_selected_curve"],
        row["is_selected_witness"],
    ))

    chord_curve_intersections = Counter(
        sum(point in curve and dot(line, point, q) == 0 for point in points)
        for line in chords
    )
    curve_off_conic_multiplicities = Counter(
        multiplicity[point] for point in curve - conic
    )

    return {
        "q": q,
        "degree": degree,
        "genus": (degree - 1) * (degree - 2) // 2,
        "witness": sorted(map(list, witness)),
        "missing_count": len(missing),
        "evaluation_rank": rank,
        "monomial_count": len(exponents),
        "kernel_dimension": len(exponents) - rank,
        "normalization": "coefficient of x^degree equals 1",
        "polynomial_terms": [
            {"exponents": list(exponent), "coefficient": centered(coefficient, q)}
            for exponent, coefficient in zip(exponents, coefficients) if coefficient
        ],
        "flint_factorization": "irreducible over F_q",
        "smooth_chart_certificates": smooth_chart_certificates,
        "geometric_classification": "smooth absolutely irreducible plane curve",
        "curve_rational_points": len(curve),
        "curve_degree_kernel_dimension": curve_kernel_dimension,
        "rational_singular_points": len(singular_rational),
        "curve_point_decomposition": {
            "missing": len(curve & missing),
            "on_conic": len(curve & conic),
            "arc_vertices": len(curve & witness),
            "covered_off_conic_nonvertices": len(curve - missing - conic - witness),
        },
        "curve_off_conic_chord_multiplicity_profile": dict(sorted(
            curve_off_conic_multiplicities.items()
        )),
        "chord_curve_rational_intersection_profile": dict(sorted(
            chord_curve_intersections.items()
        )),
        "conic_preserving_stabilizer": {
            "order": len(witness_stabilizer),
            "isomorphism_type": identify_group(order_profile),
            "element_order_profile": order_profile,
            "curve_character_scalar_profile": dict(sorted(Counter(
                character_values
            ).items())),
            "degree_d_character_space_dimension": character_space_dimension,
            "conic_power_in_same_character_space": (
                conic_power_same_character if degree % 2 == 0 else None
            ),
            "equals_selected_witness_stabilizer": True,
            "witness_orbit_sizes": sorted(map(len, witness_orbits)),
            "missing_orbit_sizes": sorted(map(len, missing_orbits)),
            "conic_orbit_sizes": sorted(map(len, conic_orbits)),
            "off_conic_orbit_size_profile": dict(sorted(Counter(
                map(len, off_conic_orbits)
            ).items())),
        },
        "stabilizer_invariant_external_arcs": {
            "count": len(invariant_arcs),
            "missing_count_profile": dict(sorted(Counter(
                row["missing_count"] for row in invariant_arcs
            ).items())),
            "selected_curve_container_count": sum(
                row["missing_lies_on_selected_curve"] for row in invariant_arcs
            ),
            "selected_witness_count": sum(
                row["is_selected_witness"] for row in invariant_arcs
            ),
        },
    }


def generate():
    records = json.loads(INPUT.read_text())["records"]
    by_q = {record["q"]: record for record in records}
    rows = []
    for q, degree in CASES.items():
        record = by_q[q]
        assert record["p"] == q
        rows.append(extract_case(q, degree, record["extremal_max_cov_witness"]))
    return {
        "schema": "c756-kernel-curves-v1",
        "scope": (
            "the selected maximum-coverage extremal witness in each of the prime "
            "fields q=13,29,31, at its first unexpected Hilbert degree"
        ),
        "dependencies": {
            "python-flint": flint.__version__,
            "sympy": sympy.__version__,
        },
        "input": INPUT.name,
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
