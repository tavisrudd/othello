#!/usr/bin/env python3
"""Exact C376 Clebsch cubic, double-six, and chirality compatibility checker."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-19-c376-clebsch-cubic-chirality.json"
C341_PATH = ROOT / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"


def load_c341():
    assert hashlib.sha256(C341_PATH.read_bytes()).hexdigest() == C341_SHA256
    spec = importlib.util.spec_from_file_location("c341_for_c376", C341_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def inv(value: int, q: int) -> int:
    assert value % q
    return pow(value % q, q - 2, q)


def normalize(vector: tuple[int, ...], q: int) -> tuple[int, ...]:
    reduced = tuple(value % q for value in vector)
    pivot = next(value for value in reduced if value)
    scale = inv(pivot, q)
    return tuple(value * scale % q for value in reduced)


def rref(rows: list[list[int]], q: int) -> tuple[list[list[int]], list[int]]:
    matrix = [[value % q for value in row] for row in rows]
    if not matrix:
        return matrix, []
    pivot_row = 0
    pivots: list[int] = []
    for column in range(len(matrix[0])):
        choice = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column]),
            None,
        )
        if choice is None:
            continue
        matrix[pivot_row], matrix[choice] = matrix[choice], matrix[pivot_row]
        scale = inv(matrix[pivot_row][column], q)
        matrix[pivot_row] = [value * scale % q for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row or not matrix[row][column]:
                continue
            multiple = matrix[row][column]
            matrix[row] = [
                (matrix[row][index] - multiple * matrix[pivot_row][index]) % q
                for index in range(len(matrix[row]))
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix[:pivot_row], pivots


def rank(rows: list[list[int]], q: int) -> int:
    return len(rref(rows, q)[1])


def nullspace(rows: list[list[int]], width: int, q: int) -> list[tuple[int, ...]]:
    reduced, pivots = rref(rows, q)
    free = [column for column in range(width) if column not in pivots]
    result = []
    for free_column in free:
        vector = [0] * width
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % q
        result.append(tuple(vector))
    return result


def monomials(degree: int, variables: int) -> list[tuple[int, ...]]:
    if variables == 1:
        return [(degree,)]
    result = []
    for first in range(degree, -1, -1):
        for tail in monomials(degree - first, variables - 1):
            result.append((first,) + tail)
    return result


def monomial_value(exponents: tuple[int, ...], point: tuple[int, ...], q: int) -> int:
    value = 1
    for exponent, coordinate in zip(exponents, point):
        value = value * pow(coordinate, exponent, q) % q
    return value


def evaluate(
    coefficients: tuple[int, ...],
    basis: list[tuple[int, ...]],
    point: tuple[int, ...],
    q: int,
) -> int:
    return sum(
        coefficient * monomial_value(exponent, point, q)
        for coefficient, exponent in zip(coefficients, basis)
    ) % q


def derivative_row(
    basis: list[tuple[int, ...]], point: tuple[int, ...], variable: int, q: int
) -> list[int]:
    row = []
    for exponent in basis:
        if exponent[variable] == 0:
            row.append(0)
            continue
        lowered = list(exponent)
        coefficient = lowered[variable]
        lowered[variable] -= 1
        row.append(coefficient * monomial_value(tuple(lowered), point, q) % q)
    return row


def projective_points(dimension: int, q: int) -> list[tuple[int, ...]]:
    result = []
    for pivot in range(dimension):
        suffix_length = dimension - pivot - 1
        for suffix in itertools.product(range(q), repeat=suffix_length):
            result.append((0,) * pivot + (1,) + suffix)
    return result


def polynomial_system(
    degree: int, points: list[tuple[int, int, int]], multiplicity: int, q: int
) -> tuple[list[tuple[int, int, int]], list[tuple[int, ...]]]:
    basis = monomials(degree, 3)
    rows: list[list[int]] = []
    for point in points:
        if multiplicity == 1:
            rows.append([monomial_value(exponent, point, q) for exponent in basis])
        elif multiplicity == 2:
            rows.extend(derivative_row(basis, point, variable, q) for variable in range(3))
        else:
            raise ValueError(multiplicity)
    return basis, nullspace(rows, len(basis), q)


def map_point(
    point: tuple[int, int, int],
    polynomial_basis: list[tuple[int, int, int]],
    system: list[tuple[int, ...]],
    q: int,
) -> tuple[int, ...]:
    return normalize(
        tuple(evaluate(polynomial, polynomial_basis, point, q) for polynomial in system), q
    )


def rowspace_key(rows: list[tuple[int, ...]], q: int) -> tuple[tuple[int, ...], ...]:
    reduced, pivots = rref([list(row) for row in rows], q)
    assert len(pivots) == len(rows)
    return tuple(tuple(row) for row in reduced)


def line_points(line: tuple[tuple[int, ...], tuple[int, ...]], q: int) -> frozenset[tuple[int, ...]]:
    first, second = line
    points = {
        normalize(tuple((first[index] + scale * second[index]) % q for index in range(4)), q)
        for scale in range(q)
    }
    points.add(normalize(second, q))
    assert len(points) == q + 1
    return frozenset(points)


def tangent_complement(point: tuple[int, int, int], q: int) -> list[tuple[int, int, int]]:
    rows = [list(point)]
    complement = []
    for candidate in [(1, 0, 0), (0, 1, 0), (0, 0, 1)]:
        if rank(rows + [list(candidate)], q) > len(rows):
            rows.append(list(candidate))
            complement.append(candidate)
    assert len(complement) == 2
    return complement


def exceptional_line(
    point: tuple[int, int, int],
    cubic_basis: list[tuple[int, int, int]],
    cubic_system: list[tuple[int, ...]],
    q: int,
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    image_vectors = []
    gradients = [
        [
            sum(
                polynomial[index] * derivative_row(cubic_basis, point, variable, q)[index]
                for index in range(len(cubic_basis))
            )
            % q
            for polynomial in cubic_system
        ]
        for variable in range(3)
    ]
    for direction in tangent_complement(point, q):
        image_vectors.append(
            tuple(
                sum(direction[variable] * gradients[variable][coordinate] for variable in range(3))
                % q
                for coordinate in range(4)
            )
        )
    key = rowspace_key(image_vectors, q)
    assert len(key) == 2
    return key  # type: ignore[return-value]


def image_line_from_plane_locus(
    locus: list[tuple[int, int, int]],
    base_points: set[tuple[int, int, int]],
    cubic_basis: list[tuple[int, int, int]],
    cubic_system: list[tuple[int, ...]],
    q: int,
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    images = {
        map_point(point, cubic_basis, cubic_system, q)
        for point in locus
        if point not in base_points
    }
    assert len(images) >= 2
    rows = []
    for image in sorted(images):
        if rank(rows + [list(image)], q) > len(rows):
            rows.append(list(image))
        if len(rows) == 2:
            break
    key = rowspace_key(rows, q)
    assert all(rank([list(row) for row in key] + [list(image)], q) == 2 for image in images)
    return key  # type: ignore[return-value]


def projective_equivalences(c341, source, target, q: int) -> list[tuple[int, ...]]:
    passing = []
    for permutation in itertools.permutations(range(6)):
        matrix = c341.frame_map(
            source[:4], [target[permutation[index]] for index in range(4)], q
        )
        if all(
            c341.normalize(c341.mat_vec(matrix, source[index], q), q)
            == target[permutation[index]]
            for index in range(6)
        ):
            passing.append(permutation)
    return passing


def set_orbits(group: set[tuple[int, ...]], size: int) -> list[list[tuple[int, ...]]]:
    unseen = set(itertools.combinations(range(6), size))
    result = []
    while unseen:
        seed = min(unseen)
        orbit = {tuple(sorted(permutation[index] for index in seed)) for permutation in group}
        unseen -= orbit
        result.append(sorted(orbit))
    return sorted(result, key=lambda orbit: orbit[0])


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def inverse_permutation(permutation: tuple[int, ...]) -> tuple[int, ...]:
    inverse = [0] * len(permutation)
    for index, image in enumerate(permutation):
        inverse[image] = index
    return tuple(inverse)


def main() -> dict[str, object]:
    q, tau = 11, 8
    c341 = load_c341()
    points = [
        c341.normalize(point, q)
        for point in [
            (0, 1, 1 - tau),
            (0, 1, tau - 1),
            (1, 1 - tau, 0),
            (1, tau - 1, 0),
            (1, 0, -tau),
            (1, 0, tau),
        ]
    ]
    assert len(set(points)) == 6
    assert all(rank([list(points[index]) for index in triple], q) == 3 for triple in itertools.combinations(range(6), 3))

    plane_points = projective_points(3, q)
    base_set = set(points)

    conic_basis = monomials(2, 3)
    five_point_conics: list[tuple[int, ...]] = []
    conic_loci: list[list[tuple[int, int, int]]] = []
    for omitted in range(6):
        selected = [point for index, point in enumerate(points) if index != omitted]
        _, system = polynomial_system(2, selected, 1, q)
        assert len(system) == 1
        conic = normalize(system[0], q)
        locus = [point for point in plane_points if evaluate(conic, conic_basis, point, q) == 0]
        assert len(locus) == q + 1
        assert all(points[index] in locus for index in range(6) if index != omitted)
        assert points[omitted] not in locus
        five_point_conics.append(conic)
        conic_loci.append(locus)

    quintic_basis, quintic_system = polynomial_system(5, points, 2, q)
    assert len(quintic_system) == 3
    second_points = []
    for locus in conic_loci:
        images = {
            map_point(point, quintic_basis, quintic_system, q)
            for point in locus
            if point not in base_set
        }
        assert len(images) == 1
        second_points.append(next(iter(images)))
    assert len(set(second_points)) == 6
    assert all(rank([list(second_points[index]) for index in triple], q) == 3 for triple in itertools.combinations(range(6), 3))

    conjugate_tau = 4
    conjugate_points = [
        c341.normalize(point, q)
        for point in [
            (0, 1, 1 - conjugate_tau),
            (0, 1, conjugate_tau - 1),
            (1, 1 - conjugate_tau, 0),
            (1, conjugate_tau - 1, 0),
            (1, 0, -conjugate_tau),
            (1, 0, conjugate_tau),
        ]
    ]
    second_to_conjugate = projective_equivalences(c341, second_points, conjugate_points, q)
    assert len(second_to_conjugate) == 60
    source_to_conjugate = projective_equivalences(c341, points, conjugate_points, q)
    assert len(source_to_conjugate) == 60
    source_to_second = projective_equivalences(c341, points, second_points, q)
    assert len(source_to_second) == 60

    cubic_basis, cubic_system = polynomial_system(3, points, 1, q)
    assert len(cubic_system) == 4
    lines: dict[str, tuple[tuple[int, ...], tuple[int, ...]]] = {}
    for index, point in enumerate(points):
        lines[f"E{index}"] = exceptional_line(point, cubic_basis, cubic_system, q)
    for left, right in itertools.combinations(range(6), 2):
        cross = (
            points[left][1] * points[right][2] - points[left][2] * points[right][1],
            points[left][2] * points[right][0] - points[left][0] * points[right][2],
            points[left][0] * points[right][1] - points[left][1] * points[right][0],
        )
        locus = [point for point in plane_points if sum(cross[i] * point[i] for i in range(3)) % q == 0]
        assert len(locus) == q + 1
        lines[f"L{left}{right}"] = image_line_from_plane_locus(
            locus, base_set, cubic_basis, cubic_system, q
        )
    for index, locus in enumerate(conic_loci):
        lines[f"Q{index}"] = image_line_from_plane_locus(
            locus, base_set, cubic_basis, cubic_system, q
        )
    assert len(lines) == 27 and len(set(lines.values())) == 27

    line_names = sorted(lines)
    line_point_sets = {name: line_points(lines[name], q) for name in line_names}
    intersections = {
        tuple(sorted((left, right)))
        for left, right in itertools.combinations(line_names, 2)
        if line_point_sets[left] & line_point_sets[right]
    }
    assert len(intersections) == 135
    tritangent_triples = [
        triple
        for triple in itertools.combinations(line_names, 3)
        if all(tuple(sorted(pair)) in intersections for pair in itertools.combinations(triple, 2))
    ]
    assert len(tritangent_triples) == 45
    eckardt_triples = [
        triple
        for triple in tritangent_triples
        if set.intersection(*(set(line_point_sets[name]) for name in triple))
    ]
    assert len(eckardt_triples) == 10

    cubic_monomials = monomials(3, 4)
    image_points = {
        map_point(point, cubic_basis, cubic_system, q)
        for point in plane_points
        if point not in base_set
    }
    cubic_relations = nullspace(
        [[monomial_value(exponent, point, q) for exponent in cubic_monomials] for point in image_points],
        len(cubic_monomials),
        q,
    )
    assert len(cubic_relations) == 1
    cubic_equation = normalize(cubic_relations[0], q)
    singular_points = []
    for point in projective_points(4, q):
        if evaluate(cubic_equation, cubic_monomials, point, q):
            continue
        gradient = [
            sum(cubic_equation[index] * derivative_row(cubic_monomials, point, variable, q)[index] for index in range(len(cubic_monomials))) % q
            for variable in range(4)
        ]
        if not any(gradient):
            singular_points.append(point)
    assert not singular_points

    skew = {
        tuple(sorted((left, right)))
        for left, right in itertools.combinations(line_names, 2)
        if tuple(sorted((left, right))) not in intersections
    }
    sixers = [
        tuple(combination)
        for combination in itertools.combinations(line_names, 6)
        if all(tuple(sorted(pair)) in skew for pair in itertools.combinations(combination, 2))
    ]
    assert len(sixers) == 72
    sixer_set = set(sixers)
    opposite: dict[tuple[str, ...], tuple[str, ...]] = {}
    for first in sixers:
        candidates = []
        for second in sixers:
            if set(first) & set(second):
                continue
            degrees = [
                sum(tuple(sorted((line, other))) in intersections for other in second)
                for line in first
            ]
            if degrees == [5] * 6:
                candidates.append(second)
        assert len(candidates) == 1
        opposite[first] = candidates[0]
    double_sixes = {tuple(sorted((first, second))) for first, second in opposite.items()}
    assert len(double_sixes) == 36
    e_row = tuple(f"E{index}" for index in range(6))
    q_row = tuple(f"Q{index}" for index in range(6))
    assert e_row in sixer_set and q_row in sixer_set and opposite[e_row] == q_row

    projective_group = c341.projective_stabilizer_group(set(points), q)
    assert len(projective_group) == 60
    point_index = {point: index for index, point in enumerate(points)}
    induced_a5 = {
        tuple(point_index[c341.normalize(c341.mat_vec(matrix, point, q), q)] for point in points)
        for matrix in projective_group
    }
    assert len(induced_a5) == 60
    triple_orbits = set_orbits(induced_a5, 3)
    assert [len(orbit) for orbit in triple_orbits] == [10, 10]

    symmetric_group = set(itertools.permutations(range(6)))
    normalizer = set()
    for permutation in symmetric_group:
        inverse = inverse_permutation(permutation)
        conjugate = {
            compose(compose(permutation, element), inverse) for element in induced_a5
        }
        if conjugate == induced_a5:
            normalizer.add(permutation)
    assert len(normalizer) == 120
    outer_coset = normalizer - induced_a5
    assert len(outer_coset) == 60
    assert set(source_to_second) == outer_coset
    assert set(source_to_conjugate) == outer_coset
    assert set(second_to_conjugate) == induced_a5
    orbit_index = {triple: index for index, orbit in enumerate(triple_orbits) for triple in orbit}
    assert all(
        {
            orbit_index[tuple(sorted(permutation[index] for index in triple))]
            for triple in triple_orbits[0]
        }
        == {1}
        for permutation in outer_coset
    )

    eckardt_types = Counter(
        tuple(sorted(name[0] for name in triple)) for triple in eckardt_triples
    )
    matching_eckardt = []
    for triple in eckardt_triples:
        if all(name.startswith("L") for name in triple):
            edges = [tuple(map(int, name[1:])) for name in triple]
            matching_eckardt.append(tuple(sorted(edges)))

    triple_features = []
    for triple in itertools.combinations(range(6), 3):
        complement = tuple(index for index in range(6) if index not in triple)
        e_lines = {f"E{index}" for index in triple}
        q_lines = {f"Q{index}" for index in triple}
        matching_transversals = sum(
            all(sum(vertex in triple for vertex in edge) == 1 for edge in matching)
            for matching in matching_eckardt
        )
        feature = {
            "triple": list(triple),
            "complement": list(complement),
            "chirality": orbit_index[triple],
            "sixers_containing_E_triple": sum(e_lines <= set(sixer) for sixer in sixers),
            "sixers_containing_Q_triple": sum(q_lines <= set(sixer) for sixer in sixers),
            "eckardt_matching_transversals": matching_transversals,
        }
        triple_features.append(feature)

    feature_by_chirality: dict[str, dict[str, list[int]]] = {}
    for chirality in range(2):
        rows = [row for row in triple_features if row["chirality"] == chirality]
        feature_by_chirality[str(chirality)] = {
            key: sorted({int(row[key]) for row in rows})
            for key in [
                "sixers_containing_E_triple",
                "sixers_containing_Q_triple",
                "eckardt_matching_transversals",
            ]
        }

    return {
        "schema": "c376-clebsch-cubic-chirality-v1",
        "field": q,
        "tau": tau,
        "source_points": [list(point) for point in points],
        "quintic_cremona": {
            "monomial_count": len(quintic_basis),
            "monomials": [list(exponent) for exponent in quintic_basis],
            "linear_system_dimension": len(quintic_system),
            "linear_system_basis": [list(polynomial) for polynomial in quintic_system],
            "five_point_conics": [list(conic) for conic in five_point_conics],
            "second_points": [list(point) for point in second_points],
            "source_to_second_equivalences": len(source_to_second),
            "source_to_second_permutation_class": "outer_normalizer_coset",
            "equivalences_to_golden_conjugate": len(second_to_conjugate),
            "second_to_golden_conjugate_permutation_class": "A5",
            "source_equivalences_to_golden_conjugate": len(source_to_conjugate),
            "source_to_golden_conjugate_permutation_class": "outer_normalizer_coset",
        },
        "cubic_surface": {
            "anticanonical_dimension": len(cubic_system),
            "equation_coefficients": list(cubic_equation),
            "equation_monomials": [list(exponent) for exponent in cubic_monomials],
            "rational_singular_points": len(singular_points),
            "line_count": len(lines),
            "lines": {
                name: [list(row) for row in lines[name]] for name in sorted(lines)
            },
            "intersecting_line_pairs": len(intersections),
            "tritangent_triples": len(tritangent_triples),
            "eckardt_triples": [list(triple) for triple in eckardt_triples],
            "eckardt_type_histogram": {"".join(key): value for key, value in sorted(eckardt_types.items())},
            "matching_eckardt_count": len(matching_eckardt),
            "sixer_count": len(sixers),
            "double_six_count": len(double_sixes),
            "distinguished_double_six": [list(e_row), list(q_row)],
        },
        "chirality": {
            "a5_order": len(induced_a5),
            "normalizer_order": len(normalizer),
            "triple_orbits": [[list(triple) for triple in orbit] for orbit in triple_orbits],
            "features_by_chirality": feature_by_chirality,
            "triple_features": triple_features,
        },
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    encoded = canonical_bytes(main())
    if arguments.check:
        assert OUTPUT.read_bytes() == encoded
        print("C376 check passed")
    else:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT}")
