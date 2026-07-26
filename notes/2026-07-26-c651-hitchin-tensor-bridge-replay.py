#!/usr/bin/env python3
"""Independent replay of the C651 exact tensor bridge certificate."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
EVIDENCE = REPOSITORY / "papers" / "clebsch-factorization" / "verification" / "evidence"
REPLAY_PATH = EVIDENCE / "matching_module_replay.py"
SCOUT_PATH = EVIDENCE / "matching_orbit_scout.json"
CERTIFICATE_PATH = Path(__file__).with_name("2026-07-26-c651-hitchin-tensor-bridge.json")
Q = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("c651_independent_matching_replay", REPLAY_PATH)


def permutation_matrix(permutation):
    return [
        [int(row == permutation[column]) for column in range(len(permutation))]
        for row in range(len(permutation))
    ]


def pair_action(permutation):
    pairs = list(itertools.combinations(range(5), 2))
    index = {pair: position for position, pair in enumerate(pairs)}
    return tuple(
        index[tuple(sorted((permutation[left], permutation[right])))]
        for left, right in pairs
    )


def five_action(group):
    identity = tuple(range(len(next(iter(group)))))
    involutions = [element for element in group if R.element_order(element) == 2]
    four_groups = {
        frozenset(
            [identity]
            + [
                other
                for other in involutions
                if R.compose(element, other) == R.compose(other, element)
            ]
        )
        for element in involutions
    }
    assert len(four_groups) == 5
    normalizers = sorted(
        (
            frozenset(
                element
                for element in group
                if frozenset(
                    R.compose(R.compose(element, member), R.invert(element))
                    for member in four_group
                )
                == four_group
            )
            for four_group in four_groups
        ),
        key=lambda subgroup: sorted(subgroup),
    )
    assert len(set(normalizers)) == 5
    assert all(len(subgroup) == 12 for subgroup in normalizers)
    index = {subgroup: position for position, subgroup in enumerate(normalizers)}
    actions = {}
    for element in group:
        inverse = R.invert(element)
        actions[element] = tuple(
            index[
                frozenset(
                    R.compose(R.compose(element, member), inverse)
                    for member in subgroup
                )
            ]
            for subgroup in normalizers
        )
    assert len(set(actions.values())) == 60
    return actions


def main() -> int:
    certificate = json.loads(CERTIFICATE_PATH.read_text(encoding="utf-8"))
    scout = json.loads(SCOUT_PATH.read_text(encoding="utf-8"))
    record = next(item for item in scout["types"] if item["type"] == "H3")
    endpoints, pgl, psl = R.mobius_groups(Q)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({R.image_matching(element, base) for element in pgl})
    stabilizer = {
        element for element in pgl if R.image_matching(element, base) == base
    }
    assert len(orbit) == 22 and len(stabilizer) == 60

    base_product = R.secant_product(base, endpoints, Q)
    vectors = []
    for matching in orbit:
        product = R.secant_product(matching, endpoints, Q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % Q
            for exponent in set(product) | set(base_product)
        }
        vectors.append(R.conic_quotient(difference, 4, Q))
    image_rows = R.transpose(vectors)
    _reduced, coordinate_rows = R.row_reduce(R.transpose(image_rows), Q)
    assert len(coordinate_rows) == 10
    coordinates = [[vector[index] for index in coordinate_rows] for vector in vectors]

    sheet = {R.image_matching(element, min(orbit)) for element in psl}
    assert len(sheet) == 11
    signs = [1 if matching in sheet else -1 % Q for matching in orbit]
    cube_basis = list(itertools.combinations_with_replacement(range(10), 3))
    cubic = [
        sum(
            sign * R.power_coordinates(vector, 3, Q)[index]
            for sign, vector in zip(signs, coordinates)
        )
        % Q
        for index in range(len(cube_basis))
    ]
    assert cubic == certificate["signed_cubic_coordinates"]
    assert hashlib.sha256(bytes(cubic)).hexdigest() == certificate["signed_cubic_sha256"]

    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    _point_reduced, point_basis_indices = R.row_reduce(R.transpose(coordinates), Q)
    point_basis = R.transpose([coordinates[index] for index in point_basis_indices])
    point_basis_inverse = R.matrix_inverse(point_basis, Q)
    base_index = orbit_index[base]

    def induced_action(element):
        action = [
            orbit_index[R.image_matching(element, matching)]
            for matching in orbit
        ]
        moved_base = action[base_index]
        target_basis = R.transpose(
            [
                [
                    (coordinates[action[index]][coordinate] - coordinates[moved_base][coordinate])
                    % Q
                    for coordinate in range(10)
                ]
                for index in point_basis_indices
            ]
        )
        return R.matrix_product(target_basis, point_basis_inverse, Q)

    actions = five_action(stabilizer)
    intertwiner = certificate["chosen_intertwiner"]
    assert R.matrix_rank(intertwiner, Q) == 10
    assert all(
        R.matrix_product(induced_action(element), intertwiner, Q)
        == R.matrix_product(
            intertwiner,
            permutation_matrix(pair_action(actions[element])),
            Q,
        )
        for element in stabilizer
    )

    generators = R.group_generators(stabilizer)
    equations = []
    for element in generators:
        w_action = induced_action(element)
        p_action = permutation_matrix(pair_action(actions[element]))
        for row in range(10):
            for column in range(10):
                equation = [0] * 100
                for middle in range(10):
                    equation[middle * 10 + column] += w_action[row][middle]
                    equation[row * 10 + middle] -= p_action[middle][column]
                equations.append([value % Q for value in equation])
    assert len(R.nullspace(equations, Q)) == certificate["intertwiner_space_dimension"] == 3

    inverse = R.matrix_inverse(intertwiner, Q)
    pair_embedding = [
        [
            (
                int(left == coordinate)
                + int(right == coordinate)
                - int(left == 4)
                - int(right == 4)
            )
            % Q
            for coordinate in range(4)
        ]
        for left, right in itertools.combinations(range(5), 2)
    ]
    contraction = [
        [
            sum(inverse[pair][w] * pair_embedding[pair][coordinate] for pair in range(10))
            % Q
            for coordinate in range(4)
        ]
        for w in range(10)
    ]
    values = dict(zip(cube_basis, cubic))
    restricted = [
        sum(
            values[tuple(sorted((i, j, k)))]
            * contraction[i][a]
            * contraction[j][b]
            * contraction[k][c]
            for i in range(10)
            for j in range(10)
            for k in range(10)
        )
        % Q
        for a, b, c in itertools.product(range(4), repeat=3)
    ]
    target = [
        0 if a == b == c else -pow(3, -1, Q) % Q
        for a, b, c in itertools.product(range(4), repeat=3)
    ]
    scalar = certificate["clebsch_restriction_scalar"]
    assert scalar == 4
    assert restricted == certificate["clebsch_restriction_tensor"]
    assert restricted == [scalar * value % Q for value in target]
    assert 1247103 % 11 == 0
    print(
        "independent tensor bridge replay: OK "
        "(22 orbit points, 60 group elements, Hom dimension 3, scalar 4)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
