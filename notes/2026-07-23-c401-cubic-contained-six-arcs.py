#!/usr/bin/env python3
"""Exact semilinear census for C401's low-degree uncovered loci."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter
from itertools import combinations, permutations, product
from pathlib import Path


STEM = "2026-07-23-c401-cubic-contained-six-arcs"
SCHEMA = "c401-cubic-contained-six-arcs-v1"
FIELDS = (4, 5, 7, 8, 9, 11, 13, 16, 17)
C398_STEM = "2026-07-20-c398-conic-deep-hole-classification"


def load_c398(root: Path):
    path = root / "notes" / f"{C398_STEM}.py"
    spec = importlib.util.spec_from_file_location("c398", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.FiniteField.DATA[16] = (2, 4, (1, 1, 0, 0))  # x^4+x+1
    module.FiniteField.DATA[17] = (17, 1, ())
    return module


def linear_row(point: tuple[int, int, int]) -> tuple[int, ...]:
    return point


def projective_images(c398, field, arc):
    return {
        c398.frame_normalize(field, ordered, arc)
        for ordered in permutations(arc, 4)
    }


def projective_suborbits(c398, field, arc):
    remaining = set(c398.semilinear_images(field, arc))
    representatives = []
    while remaining:
        seed = min(remaining)
        orbit = projective_images(c398, field, seed)
        assert orbit <= remaining
        representatives.append(
            {
                "arc": [list(point) for point in min(orbit)],
                "projective_automorphism_order": 360 // len(orbit),
            }
        )
        remaining.difference_update(orbit)
    return representatives


def projective_automorphism_permutations(c398, field, arc):
    index = {point: position for position, point in enumerate(arc)}
    answer = set()
    for ordered in permutations(arc, 4):
        inverse = c398.inverse3(field, ordered[:3])
        fourth = c398.mat_vec(field, inverse, ordered[3])
        diagonal = tuple(field.inverse(entry) for entry in fourth)

        def image(point):
            coordinates = c398.mat_vec(field, inverse, point)
            return c398.normalize(
                field,
                tuple(
                    field.mul(diagonal[i], coordinates[i]) for i in range(3)
                ),
            )

        images = tuple(image(point) for point in arc)
        if set(images) == set(arc):
            answer.add(tuple(index[point] for point in images))
    return tuple(sorted(answer))


def perfect_matchings(items: tuple[int, ...]):
    if not items:
        yield ()
        return
    first = items[0]
    for position in range(1, len(items)):
        second = items[position]
        remaining = items[1:position] + items[position + 1 :]
        for matching in perfect_matchings(remaining):
            yield ((first, second),) + matching


def permutation_order(permutation):
    current = tuple(range(len(permutation)))
    identity = current
    for order in range(1, len(permutation) + 1):
        current = tuple(permutation[current[index]] for index in identity)
        if current == identity:
            return order
    raise AssertionError("permutation order exceeded its degree")


def cubic_row(field, point: tuple[int, int, int]) -> tuple[int, ...]:
    x, y, z = point
    mul = field.mul
    return (
        mul(mul(x, x), x),
        mul(mul(y, y), y),
        mul(mul(z, z), z),
        mul(mul(x, x), y),
        mul(mul(x, x), z),
        mul(mul(y, y), x),
        mul(mul(y, y), z),
        mul(mul(z, z), x),
        mul(mul(z, z), y),
        mul(mul(x, y), z),
    )


def dot(field, left: tuple[int, ...], right: tuple[int, ...]) -> int:
    answer = 0
    for a, b in zip(left, right):
        answer = field.add(answer, field.mul(a, b))
    return answer


def projective_span(field, basis: tuple[tuple[int, ...], ...]):
    """Yield each projective vector in a nonzero span exactly once."""
    width = len(basis[0])
    for pivot in range(len(basis)):
        for tail in product(range(field.q), repeat=len(basis) - pivot - 1):
            coefficients = (0,) * pivot + (1,) + tail
            vector = [0] * width
            for coefficient, row in zip(coefficients, basis):
                for index, value in enumerate(row):
                    vector[index] = field.add(
                        vector[index], field.mul(coefficient, value)
                    )
            yield tuple(vector)


def all_projective_vectors(field, width: int):
    basis = tuple(
        tuple(1 if i == j else 0 for j in range(width)) for i in range(width)
    )
    yield from projective_span(field, basis)


def evaluate(field, form: tuple[int, ...], row: tuple[int, ...]) -> int:
    return dot(field, form, row)


def zero_set(field, form, rows, points):
    return frozenset(
        point for point, row in zip(points, rows) if evaluate(field, form, row) == 0
    )


def polynomial_product(field, factors: tuple[tuple[int, int, int], ...], degree: int):
    polynomial = {(0, 0, 0): 1}
    for factor in factors:
        next_polynomial: dict[tuple[int, int, int], int] = {}
        for exponent, coefficient in polynomial.items():
            for variable, value in enumerate(factor):
                new_exponent = list(exponent)
                new_exponent[variable] += 1
                key = tuple(new_exponent)
                term = field.mul(coefficient, value)
                next_polynomial[key] = field.add(next_polynomial.get(key, 0), term)
        polynomial = next_polynomial
    if degree == 2:
        monomials = (
            (2, 0, 0),
            (0, 2, 0),
            (0, 0, 2),
            (1, 1, 0),
            (1, 0, 1),
            (0, 1, 1),
        )
    else:
        monomials = (
            (3, 0, 0),
            (0, 3, 0),
            (0, 0, 3),
            (2, 1, 0),
            (2, 0, 1),
            (1, 2, 0),
            (0, 2, 1),
            (1, 0, 2),
            (0, 1, 2),
            (1, 1, 1),
        )
    return tuple(polynomial.get(monomial, 0) for monomial in monomials)


def normalize_form(field, form: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in form if value)
    inverse = field.inverse(pivot)
    return tuple(field.mul(inverse, value) for value in form)


def line_data(field, points):
    point_rows = tuple(linear_row(point) for point in points)
    answer = []
    for form in all_projective_vectors(field, 3):
        answer.append((form, zero_set(field, form, point_rows, points)))
    return tuple(answer)


def linear_divisors(curve_points, lines):
    return tuple(form for form, points in lines if points <= curve_points)


def classify_quadratic(field, form, quadratic_rows, points, lines):
    curve_points = zero_set(field, form, quadratic_rows, points)
    divisors = linear_divisors(curve_points, lines)
    if len(divisors) == 2:
        return "two_distinct_rational_lines"
    if len(divisors) == 1:
        square = normalize_form(
            field, polynomial_product(field, (divisors[0], divisors[0]), 2)
        )
        assert normalize_form(field, form) == square
        return "double_rational_line"
    assert not divisors
    if len(curve_points) == 1:
        return "nonsplit_conjugate_line_pair"
    assert len(curve_points) == field.q + 1
    return "nonsingular_conic"


def classify_cubic(field, form, cubic_rows, points, lines):
    curve_points = zero_set(field, form, cubic_rows, points)
    divisors = linear_divisors(curve_points, lines)
    if not divisors:
        # Every survivor has at least two rational points. A geometrically
        # reducible cubic with no rational component has at most one.
        assert len(curve_points) >= 2
        return "irreducible_cubic"
    if len(divisors) == 3:
        if len(curve_points) == 3 * field.q + 1:
            return "three_rational_lines_concurrent"
        assert len(curve_points) == 3 * field.q
        return "three_rational_lines_triangle"
    if len(divisors) == 2:
        return "double_rational_line_plus_distinct_line"
    assert len(divisors) == 1
    line = divisors[0]
    cube = normalize_form(field, polynomial_product(field, (line, line, line), 3))
    if normalize_form(field, form) == cube:
        return "triple_rational_line"
    if len(curve_points) <= field.q + 2:
        if len(curve_points) == field.q + 1:
            return "rational_line_plus_nonsplit_pair_concurrent"
        assert len(curve_points) == field.q + 2
        return "rational_line_plus_nonsplit_pair_nonconcurrent"
    intersections = 2 * (field.q + 1) - len(curve_points)
    labels = {0: "external", 1: "tangent", 2: "secant"}
    assert intersections in labels
    return f"rational_line_plus_nonsingular_conic_{labels[intersections]}"


def field_record(root: Path, q: int) -> dict[str, object]:
    c398 = load_c398(root)
    field = c398.FiniteField(q)
    points = c398.projective_points(field)
    quadratic_rows = tuple(c398.quadratic_row(field, point) for point in points)
    cubic_rows = tuple(cubic_row(field, point) for point in points)
    lines = line_data(field, points)
    arc_orbits = c398.normalized_arcs(field)
    projective_class_count = sum(
        len(projective_suborbits(c398, field, arc)) for arc, _ in arc_orbits
    )
    survivors = []
    for arc, presentation_orbit_size in arc_orbits:
        locus = c398.uncovered_locus(field, arc, points)
        if not locus:
            continue
        linear_basis = c398.nullspace(
            field, [linear_row(point) for point in locus], 3
        )
        quadratic_basis = c398.nullspace(
            field, [c398.quadratic_row(field, point) for point in locus], 6
        )
        cubic_basis = c398.nullspace(
            field, [cubic_row(field, point) for point in locus], 10
        )
        if not cubic_basis:
            continue
        if linear_basis:
            minimum_degree = 1
            minimum_forms = tuple(projective_span(field, linear_basis))
            minimum_types = {"rational_line": len(minimum_forms)}
            minimum_representatives = {"rational_line": list(minimum_forms[0])}
        elif quadratic_basis:
            minimum_degree = 2
            minimum_types = Counter()
            minimum_representatives = {}
            for form in projective_span(field, quadratic_basis):
                curve_type = classify_quadratic(
                    field, form, quadratic_rows, points, lines
                )
                minimum_types[curve_type] += 1
                minimum_representatives.setdefault(curve_type, list(form))
        else:
            minimum_degree = 3
            minimum_types = Counter()
            minimum_representatives = {}
            for form in projective_span(field, cubic_basis):
                curve_type = classify_cubic(
                    field, form, cubic_rows, points, lines
                )
                minimum_types[curve_type] += 1
                minimum_representatives.setdefault(curve_type, list(form))
        minimum_components = {}
        if minimum_degree == 1:
            minimum_components["rational_line"] = {
                "components": [minimum_representatives["rational_line"]],
                "locus_points_per_component": [len(locus)],
            }
        elif minimum_degree == 2:
            line_sets = {form: line_points for form, line_points in lines}
            for curve_type, representative in minimum_representatives.items():
                curve_points = zero_set(
                    field, tuple(representative), quadratic_rows, points
                )
                divisors = linear_divisors(curve_points, lines)
                if divisors:
                    minimum_components[curve_type] = {
                        "components": [list(divisor) for divisor in divisors],
                        "factor_intersection_in_locus": (
                            len(divisors) == 2
                            and bool(line_sets[divisors[0]] & line_sets[divisors[1]] & set(locus))
                        ),
                        "locus_points_per_component": [
                            len(line_sets[divisor] & set(locus)) for divisor in divisors
                        ],
                    }
        stabilizer_order = c398.automorphism_order(field, arc)
        assert presentation_orbit_size * stabilizer_order == 360 * field.degree
        assert locus == c398.support_three_locus(field, arc, points)
        survivors.append(
            {
                "arc": [list(point) for point in arc],
                "automorphism_order": stabilizer_order,
                "cubic_kernel_dimension": len(cubic_basis),
                "grs_parent": c398.lies_on_conic(field, arc, points),
                "linear_kernel_dimension": len(linear_basis),
                "locus": [list(point) for point in locus],
                "locus_size": len(locus),
                "minimum_containing_degree": minimum_degree,
                "minimum_degree_curve_components": dict(
                    sorted(minimum_components.items())
                ),
                "minimum_degree_curve_type_counts": dict(sorted(minimum_types.items())),
                "minimum_degree_curve_type_representatives": dict(
                    sorted(minimum_representatives.items())
                ),
                "normalized_presentation_orbit_size": presentation_orbit_size,
                "projective_subclasses": projective_suborbits(c398, field, arc),
                "quadratic_kernel_dimension": len(quadratic_basis),
            }
        )
    return {
        "q": q,
        "projective_six_arc_orbits": projective_class_count,
        "projective_points": len(points),
        "semilinear_six_arc_orbits": len(arc_orbits),
        "survivor_count": len(survivors),
        "survivors": survivors,
    }


def q9_reducible_upgrade(root: Path, records):
    c398 = load_c398(root)
    field = c398.FiniteField(9)
    points = c398.projective_points(field)
    record = next(record for record in records if record["q"] == 9)
    survivor = next(
        survivor
        for survivor in record["survivors"]
        if not survivor["grs_parent"]
        and survivor["locus_size"] == 8
        and "two_distinct_rational_lines"
        in survivor["minimum_degree_curve_type_counts"]
    )
    arc = tuple(tuple(point) for point in survivor["arc"])
    locus = set(tuple(point) for point in survivor["locus"])
    components = {
        tuple(form)
        for form in survivor["minimum_degree_curve_components"][
            "two_distinct_rational_lines"
        ]["components"]
    }
    lines = line_data(field, points)
    tangent_histogram = Counter()
    maximum_tangents = []
    factor_profiles = []
    for form, line_points in lines:
        arc_hits = [index for index, point in enumerate(arc) if point in line_points]
        if len(arc_hits) != 1:
            continue
        locus_points = len(locus & set(line_points))
        tangent_histogram[locus_points] += 1
        if locus_points == 4:
            maximum_tangents.append(form)
            secant_multiplicities = Counter(
                sum(
                    not c398.det3(field, left, right, point)
                    for left, right in combinations(arc, 2)
                )
                for point in line_points
            )
            factor_profiles.append(
                {
                    "base_vertex_index": arc_hits[0],
                    "form": list(form),
                    "locus_points": locus_points,
                    "secant_multiplicity_histogram": {
                        str(value): count
                        for value, count in sorted(secant_multiplicities.items())
                    },
                }
            )
    assert set(maximum_tangents) == components
    automorphisms = projective_automorphism_permutations(c398, field, arc)
    remaining = set(range(len(arc)))
    point_orbits = []
    while remaining:
        seed = min(remaining)
        orbit = sorted({permutation[seed] for permutation in automorphisms})
        point_orbits.append(orbit)
        remaining.difference_update(orbit)
    brianchon_points = []
    for matching in perfect_matchings(tuple(range(len(arc)))):
        common = [
            point
            for point in points
            if all(
                not c398.det3(field, arc[left], arc[right], point)
                for left, right in matching
            )
        ]
        if common:
            assert len(common) == 1
            brianchon_points.append(
                {
                    "matching": [list(pair) for pair in matching],
                    "point": list(common[0]),
                }
            )
    short_orbit = next(orbit for orbit in point_orbits if len(orbit) == 2)
    assert sorted(profile["base_vertex_index"] for profile in factor_profiles) == short_orbit
    maximum_automorphism_order = max(
        permutation_order(permutation) for permutation in automorphisms
    )
    assert len(automorphisms) == maximum_automorphism_order == 4
    return {
        "brianchon_count": len(brianchon_points),
        "brianchon_points": brianchon_points,
        "factor_line_profiles": sorted(
            factor_profiles, key=lambda profile: profile["form"]
        ),
        "pgl_arc_point_orbits": sorted(point_orbits, key=lambda orbit: (len(orbit), orbit)),
        "pgl_permutation_group": "C4",
        "pgl_permutation_group_order": len(automorphisms),
        "tangent_locus_histogram": {
            str(value): count for value, count in sorted(tangent_histogram.items())
        },
    }


def build_certificate(root: Path, fields: tuple[int, ...] = FIELDS):
    records = [field_record(root, q) for q in fields]
    if fields == FIELDS:
        c398_certificate = json.loads(
            (root / "notes" / f"{C398_STEM}.json").read_text()
        )
        c398_arcs = {
            (record["q"], tuple(tuple(point) for point in survivor["arc"]))
            for record in c398_certificate["fields"]
            for survivor in record["survivors"]
        }
        consumed_arcs = {
            (record["q"], tuple(tuple(point) for point in survivor["arc"]))
            for record in records
            for survivor in record["survivors"]
            if not survivor["grs_parent"]
            and "nonsingular_conic"
            in survivor["minimum_degree_curve_type_counts"]
        }
        assert consumed_arcs == c398_arcs
    return {
        "schema": SCHEMA,
        "c398_cross_check": {
            "non_grs_nonsingular_conic_classes_consumed": (
                len(c398_arcs) if fields == FIELDS else None
            ),
            "source_certificate": f"notes/{C398_STEM}.json",
        },
        "field_size_reduction": {
            "cubic_point_bound": "#C(F_q) <= 3(q+1)",
            "coverage_inequality": "q^2-2q-2 <= 15(q+1)",
            "largest_integer_q": 17,
            "residual_prime_powers_with_six_arcs": list(FIELDS),
        },
        "fields": records,
        "q9_reducible_intrinsic_upgrade": (
            q9_reducible_upgrade(root, records) if fields == FIELDS else None
        ),
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def check_tracked(root: Path) -> None:
    tracked = root / "notes" / f"{STEM}.json"
    expected = tracked.read_bytes()
    with tempfile.TemporaryDirectory(prefix="c401-check-", dir="/home/tavis") as directory:
        generated = Path(directory) / tracked.name
        generated.write_bytes(canonical_bytes(build_certificate(root)))
        actual = generated.read_bytes()
    if actual != expected:
        raise SystemExit(f"generated certificate differs from {tracked}")
    digest = hashlib.sha256(expected).hexdigest()
    print(f"checked {tracked.relative_to(root)} ({len(expected)} bytes, sha256 {digest})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--fields", nargs="*", type=int, choices=FIELDS)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    if args.check:
        check_tracked(root)
        return
    output = args.output or root / "notes" / f"{STEM}.json"
    fields = tuple(args.fields) if args.fields else FIELDS
    output.write_bytes(canonical_bytes(build_certificate(root, fields)))
    print(output)


if __name__ == "__main__":
    main()
