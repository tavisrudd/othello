#!/usr/bin/env python3
"""Independent replay of the C411 six-representative derivation."""

from __future__ import annotations

import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERT = json.loads((HERE / "2026-07-20-c411-double-coset-hecke.json").read_text())
SCOUT = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("c411_independent_c406_replay", HERE / "2026-07-20-c406-matching-module-replay.py")
C378 = R.C378_REPLAY


def normalize(vector, q):
    pivot = next(value for value in vector if value % q)
    inverse = pow(pivot, -1, q)
    return tuple(value * inverse % q for value in vector)


def cross(left, right, q):
    return (
        (left[1] * right[2] - left[2] * right[1]) % q,
        (left[2] * right[0] - left[0] * right[2]) % q,
        (left[0] * right[1] - left[1] * right[0]) % q,
    )


def main():
    q = 11
    source = next(record for record in SCOUT["types"] if record["type"] == "H3")
    endpoints = [tuple(point) for point in source["p1_endpoints"]]
    base = tuple(tuple(pair) for pair in source["coxeter_invariant_matching"])
    _points, pgl, psl = R.mobius_groups(q)
    matchings = sorted({R.image_matching(element, base) for element in pgl})
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    plus_sheet = {R.image_matching(element, base) for element in psl}
    assert len(matchings) == 22 and len(plus_sheet) == 11

    projective_points = sorted(
        {
            normalize(vector, q)
            for vector in itertools.product(range(q), repeat=3)
            if vector != (0, 0, 0)
        }
    )
    h3_conic = [point for point in projective_points if sum(value * value for value in point) % q == 0]
    conic_base = h3_conic[0]
    pencil = [
        line
        for line in projective_points
        if sum(left * right for left, right in zip(line, conic_base)) % q == 0
    ]
    first = pencil[0]
    second = next(line for line in pencil[1:] if cross(first, line, q) != (0, 0, 0))
    parameterized_conic = []
    for left, right in endpoints:
        line = normalize(
            tuple((left * first[index] + right * second[index]) % q for index in range(3)), q
        )
        incident = [
            point
            for point in h3_conic
            if sum(a * b for a, b in zip(line, point)) % q == 0
        ]
        parameterized_conic.append(
            conic_base if len(incident) == 1 else next(point for point in incident if point != conic_base)
        )

    rows = []
    for point_index, (point, (left, right)) in enumerate(zip(parameterized_conic[:5], endpoints[:5])):
        standard = (left * left % q, left * right % q, right * right % q)
        for output in range(3):
            row = [0] * 14
            for input_coordinate in range(3):
                row[3 * output + input_coordinate] = standard[input_coordinate]
            row[9 + point_index] = -point[output] % q
            rows.append(row)
    solution = R.nullspace(rows, q)
    assert len(solution) == 1
    standard_to_h3 = [solution[0][3 * row : 3 * row + 3] for row in range(3)]
    h3_to_standard = R.matrix_inverse(standard_to_h3, q)

    plus_group = C378.a5(8)
    minus_group = C378.a5(4)
    k_group = plus_group & minus_group
    assert len(k_group) == 12
    c378_certificate = json.loads(C378.CERT.read_text())
    unordered_relations = C378.orbits(C378.linear(k_group))
    representatives = [
        tuple(item["representative"]) for item in c378_certificate["common_relation_metadata"]
    ]
    relations = [
        next(relation for relation in unordered_relations if representative in relation)
        for representative in representatives
    ]
    relation_permutation = []
    for relation in relations:
        image = {C378.mv(C378.J, vector) for vector in relation}
        relation_permutation.append(next(index for index, target in enumerate(relations) if image == target))
    odd_pairs = [
        (index, image) for index, image in enumerate(relation_permutation) if index < image
    ]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
    projective_relations = [
        sorted({C378.normv(vector) for vector in relation if vector != (0, 0, 0)})
        for relation in relations
    ]

    conic_index = {point: index for index, point in enumerate(parameterized_conic)}
    k_actions = {
        tuple(conic_index[normalize(C378.mv(matrix, point), q)] for point in parameterized_conic)
        for matrix in k_group
    }
    unseen = set(range(len(matchings)))
    k_orbits = []
    while unseen:
        representative = min(unseen)
        part = {
            matching_index[R.image_matching(action, matchings[representative])]
            for action in k_actions
        }
        unseen -= part
        k_orbits.append(part)
    assert sorted(map(len, k_orbits)) == [1, 1, 4, 4, 6, 6]

    def product_zero(product, h3_point):
        standard = R.matrix_vector(h3_to_standard, h3_point, q)
        return (
            sum(
                coefficient
                * pow(standard[0], exponent[0], q)
                * pow(standard[1], exponent[1], q)
                * pow(standard[2], exponent[2], q)
                for exponent, coefficient in product.items()
            )
            % q
            == 0
        )

    derived = []
    for part in sorted(k_orbits, key=lambda item: min(item)):
        representative_index = min(part)
        matching = matchings[representative_index]
        product = R.secant_product(matching, endpoints, q)
        zero_counts = [
            sum(product_zero(product, point) for point in relation)
            for relation in projective_relations
        ]
        profile = [zero_counts[left] - zero_counts[right] for left, right in odd_pairs]
        derived.append(
            {
                "representative_index": representative_index,
                "orbit_size": len(part),
                "sheet": 0 if matching in plus_sheet else 1,
                "relation_zero_counts": zero_counts,
                "depth_profile": profile,
            }
        )

    primary = CERT["double_cosets"]["representatives"]
    assert [
        {
            key: record[key]
            for key in ("representative_index", "orbit_size", "sheet", "relation_zero_counts", "depth_profile")
        }
        for record in primary
    ] == derived

    positive = sorted(
        (record for record in derived if record["sheet"] == 0), key=lambda record: record["orbit_size"]
    )
    weights = [record["orbit_size"] for record in positive]
    profiles = [record["depth_profile"] for record in positive]
    assert weights == [1, 4, 6]
    assert [
        sum(weight * profile[column] for weight, profile in zip(weights, profiles))
        for column in range(4)
    ] == [0, 0, 0, 0]
    assert R.matrix_rank(profiles, q) == 2
    assert R.nullspace(profiles, q) == [[2, 2, 1, 0], [9, 8, 0, 1]]
    cubic_witness = 2 * sum(weight * profile[0] ** 3 for weight, profile in zip(weights, profiles)) % q
    assert cubic_witness == CERT["compressed_trade"]["cubic_first_coordinate_witness_mod_11"] == 6
    print("C411 independent six-representative replay OK")


if __name__ == "__main__":
    main()
