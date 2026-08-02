#!/usr/bin/env python3
"""Exact H3 fixed-line gate for C798.

The script reconstructs the affine conic-quotient action from the complete
matching image, solves the A5-fixed affine equations, and checks every point
of the resulting fixed locus without enumerating the ambient 11^15 points.
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
C797_PATH = HERE / "2026-08-02-c797-affine-orbit-falsifier.py"
OUTPUT = Path(__file__).with_suffix(".json")
SCHEMA = "c798-h3-fixed-line-v1"
Q = 11
H3_MATCHING = (
    (0, 1),
    (2, 5),
    (3, 7),
    (4, 9),
    (6, 8),
    (10, 11),
)


def load_c797():
    spec = importlib.util.spec_from_file_location("c797_affine", C797_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


C797 = load_c797()
BASE = C797.BASE


def fixed_affine_points(actions, dimension, q):
    equations = []
    for linear, translation in actions:
        for output in range(dimension):
            row = [
                (linear[source][output] - (1 if source == output else 0)) % q
                for source in range(dimension)
            ]
            equations.append(row + [(-translation[output]) % q])
    reduced, pivots = BASE.rref(equations, q)
    assert not any(
        not any(row[:dimension]) and row[dimension] for row in reduced
    )
    pivot_columns = [pivot for pivot in pivots if pivot < dimension]
    free_columns = [i for i in range(dimension) if i not in pivot_columns]
    points = []
    for values in itertools.product(range(q), repeat=len(free_columns)):
        point = [0] * dimension
        for column, value in zip(free_columns, values):
            point[column] = value
        for row_index, pivot in reversed(list(enumerate(pivot_columns))):
            row = reduced[row_index]
            point[pivot] = (
                row[dimension]
                - sum(row[column] * point[column] for column in free_columns)
            ) % q
        points.append(tuple(point))
    return tuple(sorted(points)), len(free_columns)


def normalized_tensor(points, trade, degree, q):
    dimension = len(points[0])
    tensor = []
    for indices in itertools.combinations_with_replacement(range(dimension), degree):
        value = 0
        for coefficient, point in zip(trade, points):
            term = coefficient
            for index in indices:
                term = term * point[index] % q
            value = (value + term) % q
        tensor.append(value)
    assert any(tensor)
    return C797.normalize_trade(tuple(tensor), q)


def cubic_catalecticant_rank(points, trade, q):
    dimension = len(points[0])
    columns = tuple(itertools.combinations_with_replacement(range(dimension), 2))
    matrix = []
    for first in range(dimension):
        row = []
        for second, third in columns:
            row.append(
                sum(
                    coefficient
                    * point[first]
                    * point[second]
                    * point[third]
                    for coefficient, point in zip(trade, points)
                )
                % q
            )
        matrix.append(row)
    return BASE.rank(matrix, q)


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
        trade = C797.normalize_trade(trades[0], q)
        profile = {}
        for value in sorted(set(trade)):
            profile[str(value)] = trade.count(value)
        record["trade_value_profile"] = profile
        record["two_valued_trade"] = len(profile) == 2
        for degree in (3, 4):
            tensor = normalized_tensor(points, trade, degree, q)
            encoded = json.dumps(tensor, separators=(",", ":")).encode()
            record[f"signed_degree_{degree}_projective_sha256"] = hashlib.sha256(
                encoded
            ).hexdigest()
            record[f"signed_degree_{degree}_nonzero_coordinates"] = sum(
                value != 0 for value in tensor
            )
        record["cubic_catalecticant_rank"] = cubic_catalecticant_rank(
            points, trade, q
        )
    else:
        record["two_valued_trade"] = False
    return record


def certificate():
    generators, group = C797.pgl_generators(Q)
    matchings, points_by_matching = C797.matching_points(Q)
    generator_actions = C797.verified_actions(
        Q, generators, matchings, points_by_matching
    )
    matching_image = set(points_by_matching.values())
    h3_point = points_by_matching[H3_MATCHING]
    h3_orbit = C797.point_orbit(h3_point, generator_actions, Q)
    assert len(h3_orbit) == 22
    stabilizer = {
        permutation
        for permutation in group
        if BASE.image(permutation, H3_MATCHING) == H3_MATCHING
    }
    assert len(stabilizer) == 60
    stabilizer_actions = tuple(
        C797.infer_affine_map(
            permutation, matchings, points_by_matching, Q, reverse=False
        )
        for permutation in sorted(stabilizer)
    )
    fixed_points, fixed_dimension = fixed_affine_points(
        stabilizer_actions, len(h3_point), Q
    )
    fixed_orbits = {
        min(C797.point_orbit(point, generator_actions, Q)):
        C797.point_orbit(point, generator_actions, Q)
        for point in fixed_points
    }
    records = [
        orbit_record(orbit, matching_image, Q)
        for _, orbit in sorted(fixed_orbits.items())
    ]
    assert fixed_dimension == 1
    assert len(fixed_points) == Q
    assert len(fixed_orbits) == Q
    assert all(record["orbit_size"] == 22 for record in records)
    assert all(record["schur_square_rank"] == 21 for record in records)
    assert all(record["trade_dimension"] == 1 for record in records)
    assert all(record["two_valued_trade"] for record in records)
    assert sum(record["contained_in_matching_image"] for record in records) == 1
    assert Counter(record["affine_rank"] for record in records) == Counter(
        {11: 10, 10: 1}
    )
    assert Counter(record["cubic_catalecticant_rank"] for record in records) == Counter(
        {10: 10, 9: 1}
    )
    assert len({record["signed_degree_3_projective_sha256"] for record in records}) == Q
    assert len({record["signed_degree_4_projective_sha256"] for record in records}) == Q
    return {
        "schema": SCHEMA,
        "scope": {
            "field": Q,
            "ambient_affine_dimension": len(h3_point),
            "ambient_point_count_not_enumerated": Q ** len(h3_point),
            "method": (
                "reconstruct the affine action from all perfect matchings, "
                "solve the A5-fixed linear equations, and enumerate only the fixed locus"
            ),
        },
        "pgl_order": len(group),
        "perfect_matching_count": len(matchings),
        "distinct_matching_image_points": len(matching_image),
        "h3_orbit_size": len(h3_orbit),
        "h3_stabilizer_order": len(stabilizer),
        "h3_stabilizer_type": "A5 (order 60; identified as the H3 matching stabilizer)",
        "fixed_locus_affine_dimension": fixed_dimension,
        "fixed_locus_point_count": len(fixed_points),
        "fixed_locus_matching_image_point_count": sum(
            point in matching_image for point in fixed_points
        ),
        "distinct_orbits_from_fixed_locus": len(fixed_orbits),
        "affine_rank_histogram": dict(
            sorted(Counter(record["affine_rank"] for record in records).items())
        ),
        "cubic_catalecticant_rank_histogram": dict(
            sorted(
                Counter(
                    record["cubic_catalecticant_rank"] for record in records
                ).items()
            )
        ),
        "distinct_projective_signed_cubics": len(
            {record["signed_degree_3_projective_sha256"] for record in records}
        ),
        "distinct_projective_signed_quartics": len(
            {record["signed_degree_4_projective_sha256"] for record in records}
        ),
        "fixed_locus_orbits": records,
        "verdict": (
            "H3 has the predicted eleven-placement ambiguity line"
            if fixed_dimension == 1
            and len(fixed_points) == Q
            and len(fixed_orbits) == Q
            and all(record["two_valued_trade"] for record in records)
            and sum(record["contained_in_matching_image"] for record in records) == 1
            else "the predicted H3 ambiguity-line pattern fails"
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
        raise SystemExit("C798 H3 fixed-line certificate is stale")
    print(f"C798 H3 fixed-line: OK sha256={hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
