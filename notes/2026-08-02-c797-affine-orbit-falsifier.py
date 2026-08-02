#!/usr/bin/env python3
"""Exhaust the first affine conic-quotient modules for C797.

The affine action is reconstructed exactly from the equivariant matching
configuration, then verified on every perfect matching.  The census itself
runs over every point of the affine module, not only matching images.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
BASE_PATH = (
    ROOT
    / "papers"
    / "clebsch-factorization"
    / "verification"
    / "evidence"
    / "balanced_matching_geometry.py"
)
OUTPUT = Path(__file__).with_suffix(".json")
SCHEMA = "c797-affine-orbit-falsifier-v1"


def load_base():
    spec = importlib.util.spec_from_file_location("balanced_geometry", BASE_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


BASE = load_base()


def compose(left, right):
    """Permutation product left after right."""
    return tuple(left[right[i]] for i in range(len(right)))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = compose(generator, current)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def pgl_generators(q):
    nonsquares = [
        x for x in range(2, q) if pow(x, (q - 1) // 2, q) == q - 1
    ]
    assert nonsquares
    matrices = ((1, 1, 0, 1), (0, 1, 1, 0), (nonsquares[0], 0, 0, 1))
    generators = tuple(
        tuple(BASE.mobius(matrix, x, q) for x in range(q + 1))
        for matrix in matrices
    )
    group = generated_group(generators)
    assert len(group) == q * (q * q - 1)
    return generators, group


def matching_points(q):
    matchings = tuple(BASE.perfect_matchings(range(q + 1)))
    reference_product = BASE.matching_product(matchings[0], q)
    quotient_degree = (q - 3) // 2
    points = {}
    for matching in matchings:
        product = BASE.matching_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - reference_product.get(exponent, 0))
            % q
            for exponent in set(product) | set(reference_product)
        }
        points[matching] = tuple(
            BASE.quotient_by_conic(difference, quotient_degree, q)
        )
    return matchings, points


def inverse(matrix, q):
    size = len(matrix)
    augmented = [
        list(row) + [1 if i == j else 0 for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    reduced, pivots = BASE.rref(augmented, q)
    assert pivots[:size] == list(range(size))
    return [row[size:] for row in reduced[:size]]


def multiply_row_matrix(row, matrix, q):
    return tuple(
        sum(row[i] * matrix[i][j] for i in range(len(row))) % q
        for j in range(len(matrix[0]))
    )


def matrix_product(left, right, q):
    return [multiply_row_matrix(row, right, q) for row in left]


def add(left, right, q):
    return tuple((x + y) % q for x, y in zip(left, right))


def subtract(left, right, q):
    return tuple((x - y) % q for x, y in zip(left, right))


def select_affine_basis(matchings, points, q, reverse=False):
    ordered = list(reversed(matchings)) if reverse else list(matchings)
    base = ordered[0]
    differences = []
    selected = []
    for matching in ordered[1:]:
        difference = subtract(points[matching], points[base], q)
        if BASE.rank(differences + [list(difference)], q) > len(differences):
            differences.append(list(difference))
            selected.append(matching)
        if len(differences) == len(points[base]):
            break
    assert len(differences) == len(points[base])
    return base, tuple(selected), differences


def infer_affine_map(generator, matchings, points, q, reverse=False):
    base, selected, basis = select_affine_basis(matchings, points, q, reverse)
    image_base = points[BASE.image(generator, base)]
    image_differences = [
        list(subtract(points[BASE.image(generator, matching)], image_base, q))
        for matching in selected
    ]
    linear = matrix_product(inverse(basis, q), image_differences, q)
    translation = subtract(
        image_base, multiply_row_matrix(points[base], linear, q), q
    )
    return tuple(tuple(row) for row in linear), tuple(translation)


def apply_affine(action, point, q):
    linear, translation = action
    return add(multiply_row_matrix(point, linear, q), translation, q)


def verified_actions(q, generators, matchings, points):
    actions = []
    for generator in generators:
        forward = infer_affine_map(generator, matchings, points, q, reverse=False)
        replay = infer_affine_map(generator, matchings, points, q, reverse=True)
        assert forward == replay
        for matching in matchings:
            assert apply_affine(forward, points[matching], q) == points[
                BASE.image(generator, matching)
            ]
        actions.append(forward)
    return tuple(actions)


def normalize_trade(vector, q):
    pivot = next(value for value in vector if value)
    inverse_pivot = pow(pivot, -1, q)
    return tuple(value * inverse_pivot % q for value in vector)


def projective_points(dimension, q):
    for pivot in range(dimension):
        prefix = (0,) * pivot + (1,)
        for tail in itertools.product(range(q), repeat=dimension - pivot - 1):
            yield prefix + tail


def cubic_singular_count(points, trade, q):
    dimension = len(points[0])
    count = 0
    for dual_point in projective_points(dimension, q):
        gradient = [0] * dimension
        for coefficient, point in zip(trade, points):
            value = sum(x * y for x, y in zip(point, dual_point)) % q
            scale = coefficient * value * value % q
            for i, coordinate in enumerate(point):
                gradient[i] = (gradient[i] + scale * coordinate) % q
        if not any(gradient):
            count += 1
    return count


def orbit_record(orbit, matching_image, q):
    points = sorted(orbit)
    rows = BASE.row_basis(
        [[1] * len(points)] + [list(column) for column in zip(*points)], q
    )
    square = [
        [x * y % q for x, y in zip(rows[i], rows[j])]
        for i in range(len(rows))
        for j in range(i, len(rows))
    ]
    square_basis = BASE.row_basis(square, q)
    trades = BASE.nullspace(square_basis, q)
    record = {
        "representative": list(points[0]),
        "orbit_size": len(points),
        "affine_rank": len(rows),
        "schur_square_rank": len(square_basis),
        "trade_dimension": len(trades),
        "contained_in_matching_image": all(point in matching_image for point in points),
    }
    if len(trades) == 1:
        trade = normalize_trade(trades[0], q)
        profile = Counter(trade)
        record["trade_value_profile"] = {
            str(value): profile[value] for value in sorted(profile)
        }
        record["two_valued_trade"] = len(profile) == 2
        cubic = tuple(
            sum(
                trade[index] * point[i] * point[j] * point[k]
                for index, point in enumerate(points)
            )
            % q
            for i in range(len(points[0]))
            for j in range(i, len(points[0]))
            for k in range(j, len(points[0]))
        )
        assert any(cubic)
        normalized_cubic = normalize_trade(cubic, q)
        cubic_bytes = json.dumps(normalized_cubic, separators=(",", ":")).encode()
        record["signed_cubic_nonzero_coordinates"] = sum(
            value != 0 for value in normalized_cubic
        )
        record["signed_cubic_projective_sha256"] = hashlib.sha256(
            cubic_bytes
        ).hexdigest()
        record["signed_cubic_projective_singular_points"] = cubic_singular_count(
            points, trade, q
        )
    else:
        record["two_valued_trade"] = False
    return record


def point_orbit(representative, actions, q):
    orbit = {representative}
    frontier = [representative]
    while frontier:
        point = frontier.pop()
        for action in actions:
            image = apply_affine(action, point, q)
            if image not in orbit:
                orbit.add(image)
                frontier.append(image)
    return orbit


def q7_fixed_locus_obstruction(
    q, group, generator_actions, matchings, points_by_matching, matching_image
):
    assert q == 7
    candidate_matching = None
    for matching in matchings:
        orbit = point_orbit(points_by_matching[matching], generator_actions, q)
        if orbit_record(orbit, matching_image, q)["two_valued_trade"]:
            candidate_matching = matching
            break
    assert candidate_matching is not None
    matching_point = points_by_matching[candidate_matching]
    full_actions = {
        permutation: infer_affine_map(
            permutation, matchings, points_by_matching, q, reverse=False
        )
        for permutation in group
    }
    stabilizer = {
        permutation
        for permutation, action in full_actions.items()
        if apply_affine(action, matching_point, q) == matching_point
    }
    assert len(stabilizer) == 24
    dimension = len(matching_point)
    fixed_locus = [
        point
        for point in itertools.product(range(q), repeat=dimension)
        if all(
            apply_affine(full_actions[permutation], point, q) == point
            for permutation in stabilizer
        )
    ]
    assert len(fixed_locus) == q
    fixed_orbits = {
        min(point_orbit(point, generator_actions, q)):
        point_orbit(point, generator_actions, q)
        for point in fixed_locus
    }
    assert len(fixed_orbits) == q
    records = [
        orbit_record(orbit, matching_image, q)
        for _, orbit in sorted(fixed_orbits.items())
    ]
    assert all(record["two_valued_trade"] for record in records)
    assert sum(record["contained_in_matching_image"] for record in records) == 1
    cubic_hashes = Counter(
        record["signed_cubic_projective_sha256"] for record in records
    )
    return {
        "matching_point": list(matching_point),
        "stabilizer_order": len(stabilizer),
        "stabilizer_type": "S4 (order 24; identified by the B3 matching stabilizer)",
        "fixed_locus_point_count": len(fixed_locus),
        "fixed_locus_affine_dimension": 1,
        "fixed_locus_matching_image_point_count": sum(
            point in matching_image for point in fixed_locus
        ),
        "distinct_orbits_from_fixed_locus": len(fixed_orbits),
        "all_fixed_locus_orbits_have_unique_two_valued_trade": True,
        "distinct_projective_signed_cubics": len(cubic_hashes),
        "projective_signed_cubic_multiplicities": dict(sorted(cubic_hashes.items())),
        "fixed_locus_orbits": records,
    }


def census(q):
    generators, group = pgl_generators(q)
    matchings, points_by_matching = matching_points(q)
    actions = verified_actions(q, generators, matchings, points_by_matching)
    dimension = len(next(iter(points_by_matching.values())))
    universe = set(itertools.product(range(q), repeat=dimension))
    matching_image = set(points_by_matching.values())
    records = []
    while universe:
        representative = min(universe)
        orbit = point_orbit(representative, actions, q)
        assert orbit <= universe
        universe -= orbit
        records.append(orbit_record(orbit, matching_image, q))
    records.sort(key=lambda record: (record["orbit_size"], record["representative"]))
    candidates = [record for record in records if record["two_valued_trade"]]
    result = {
        "q": q,
        "module_dimension": dimension,
        "affine_point_count": q**dimension,
        "pgl_order": len(group),
        "perfect_matching_count": len(matchings),
        "distinct_matching_image_points": len(matching_image),
        "affine_orbit_count": len(records),
        "orbit_size_histogram": {
            str(size): count
            for size, count in sorted(Counter(r["orbit_size"] for r in records).items())
        },
        "unique_two_valued_trade_orbits": candidates,
    }
    if q == 7:
        result["fixed_locus_obstruction"] = q7_fixed_locus_obstruction(
            q, group, actions, matchings, points_by_matching, matching_image
        )
    return result


def certificate():
    fields = [census(q) for q in (3, 5, 7)]
    return {
        "schema": SCHEMA,
        "scope": {
            "fields": [3, 5, 7],
            "domain": (
                "every point and every PGL2 orbit in the affine conic-quotient "
                "module reconstructed from the full perfect-matching image"
            ),
            "stop_condition": "complete exhaustion of q^dim(F) affine points",
        },
        "fields": fields,
        "verdict": (
            "the carrier-free B3/H3 conjecture survives this bounded scope"
            if all(
                all(
                    record["contained_in_matching_image"]
                    for record in field["unique_two_valued_trade_orbits"]
                )
                for field in fields
            )
            else "the carrier-free B3/H3 conjecture fails in this bounded scope"
        ),
    }


def payload():
    return (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        raise SystemExit("choose exactly one of --write or --check")
    data = payload()
    if args.write:
        OUTPUT.write_bytes(data)
    elif not OUTPUT.exists() or OUTPUT.read_bytes() != data:
        raise SystemExit("C797 affine-orbit certificate is stale")
    print(
        f"C797 affine-orbit falsifier: OK sha256={hashlib.sha256(data).hexdigest()}"
    )


if __name__ == "__main__":
    main()
