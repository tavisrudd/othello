#!/usr/bin/env python3
"""Build the exact Paper II--Hitchin cubic bridge over F_11."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
EVIDENCE = (
    REPOSITORY
    / "papers"
    / "clebsch-factorization"
    / "verification"
    / "evidence"
)
MATCHING_MODULE_PATH = EVIDENCE / "matching_module.py"
SCOUT_PATH = EVIDENCE / "matching_orbit_scout.json"
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MM = load_module("c651_matching_module", MATCHING_MODULE_PATH)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def permutation_matrix(permutation: tuple[int, ...]) -> list[list[int]]:
    size = len(permutation)
    return [
        [int(row == permutation[column]) for column in range(size)]
        for row in range(size)
    ]


def element_order(permutation: tuple[int, ...]) -> int:
    identity = tuple(range(len(permutation)))
    power = identity
    for order in range(1, 61):
        power = MM.compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError("element order exceeds A5 bound")


def natural_five_action(
    group: set[tuple[int, ...]],
) -> tuple[list[frozenset[tuple[int, ...]]], dict[tuple[int, ...], tuple[int, ...]]]:
    identity = tuple(range(len(next(iter(group)))))
    involutions = [element for element in group if element_order(element) == 2]
    four_groups = {
        frozenset(
            [identity]
            + [
                other
                for other in involutions
                if MM.compose(element, other) == MM.compose(other, element)
            ]
        )
        for element in involutions
    }
    assert len(four_groups) == 5
    assert all(len(subgroup) == 4 for subgroup in four_groups)
    four_groups = sorted(four_groups, key=lambda subgroup: sorted(subgroup))

    a4_subgroups = []
    for four_group in four_groups:
        normalizer = frozenset(
            element
            for element in group
            if frozenset(
                MM.compose(
                    MM.compose(element, member),
                    MM.inverse(element),
                )
                for member in four_group
            )
            == four_group
        )
        assert len(normalizer) == 12
        a4_subgroups.append(normalizer)
    assert len(set(a4_subgroups)) == 5
    index = {subgroup: position for position, subgroup in enumerate(a4_subgroups)}

    actions = {}
    for element in group:
        inverse = MM.inverse(element)
        actions[element] = tuple(
            index[
                frozenset(
                    MM.compose(MM.compose(element, member), inverse)
                    for member in subgroup
                )
            ]
            for subgroup in a4_subgroups
        )
    assert len(set(actions.values())) == 60
    return a4_subgroups, actions


def pair_action(permutation: tuple[int, ...]) -> tuple[int, ...]:
    pairs = list(itertools.combinations(range(5), 2))
    index = {pair: position for position, pair in enumerate(pairs)}
    return tuple(
        index[tuple(sorted((permutation[left], permutation[right])))]
        for left, right in pairs
    )


def intertwiner_basis(
    w_actions: list[list[list[int]]],
    p_actions: list[list[list[int]]],
) -> list[list[int]]:
    equations = []
    size = 10
    for w_action, p_action in zip(w_actions, p_actions):
        for row in range(size):
            for column in range(size):
                equation = [0] * (size * size)
                for middle in range(size):
                    equation[middle * size + column] += w_action[row][middle]
                    equation[row * size + middle] -= p_action[middle][column]
                equations.append([value % PRIME for value in equation])
    basis = MM.nullspace(equations, PRIME)
    assert len(basis) == 3
    return basis


def reshape(vector: list[int]) -> list[list[int]]:
    return [vector[10 * row : 10 * row + 10] for row in range(10)]


def chosen_intertwiner(basis: list[list[int]]) -> tuple[list[int], list[list[int]]]:
    for coefficients in itertools.product(range(PRIME), repeat=len(basis)):
        if not any(coefficients):
            continue
        vector = [
            sum(coefficient * basis_vector[index] for coefficient, basis_vector in zip(coefficients, basis))
            % PRIME
            for index in range(100)
        ]
        matrix = reshape(vector)
        if MM.rank(matrix, PRIME) == 10:
            return list(coefficients), matrix
    raise AssertionError("the two modules admit no invertible intertwiner")


def h3_workspace() -> dict[str, object]:
    scout = json.loads(SCOUT_PATH.read_text(encoding="utf-8"))
    record = next(item for item in scout["types"] if item["type"] == "H3")
    conic, parameters = MM.COXETER.conic_parameterization(PRIME)
    endpoints = tuple(parameters)
    full_group, psl_group = MM.full_pgl(PRIME, parameters)
    parent_group = MM.h3_group(PRIME, conic)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {MM.matching_image(element, base_matching) for element in full_group}
    )
    assert len(orbit) == 22
    orbit_index = {matching: index for index, matching in enumerate(orbit)}

    base_product = MM.matching_product(base_matching, endpoints, PRIME)
    quotient_vectors = []
    for matching in orbit:
        product = MM.matching_product(matching, endpoints, PRIME)
        difference = {
            exponent: (
                product.get(exponent, 0) - base_product.get(exponent, 0)
            )
            % PRIME
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(MM.quotient_by_conic(difference, 4, PRIME))
    image_matrix = MM.transpose(quotient_vectors)
    _reduced, coordinate_pivots = MM.rref(MM.transpose(image_matrix), PRIME)
    assert len(coordinate_pivots) == 10
    coordinates = [
        [vector[index] for index in coordinate_pivots]
        for vector in quotient_vectors
    ]

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {
            MM.matching_image(element, representative)
            for element in psl_group
        }
        unseen -= sheet
        sheets.append(sheet)
    assert sorted(map(len, sheets)) == [11, 11]
    signs = [
        1 if matching in sheets[0] else -1 % PRIME
        for matching in orbit
    ]
    cube_basis = list(itertools.combinations_with_replacement(range(10), 3))
    cubic = [
        sum(
            sign * power[index]
            for sign, power in zip(
                signs,
                [MM.symmetric_power(vector, 3, PRIME) for vector in coordinates],
            )
        )
        % PRIME
        for index in range(len(cube_basis))
    ]
    assert any(cubic)

    _point_reduced, point_basis_indices = MM.rref(
        MM.transpose(coordinates), PRIME
    )
    point_basis = MM.transpose(
        [coordinates[index] for index in point_basis_indices]
    )
    point_basis_inverse = MM.matrix_inverse(point_basis, PRIME)
    base_index = orbit_index[base_matching]

    def induced_action(element: tuple[int, ...]) -> list[list[int]]:
        action = tuple(
            orbit_index[MM.matching_image(element, matching)]
            for matching in orbit
        )
        moved_base = action[base_index]
        target_basis = MM.transpose(
            [
                [
                    (
                        coordinates[action[index]][coordinate]
                        - coordinates[moved_base][coordinate]
                    )
                    % PRIME
                    for coordinate in range(10)
                ]
                for index in point_basis_indices
            ]
        )
        matrix = MM.matrix_product(
            target_basis, point_basis_inverse, PRIME
        )
        assert all(
            MM.matrix_vector(matrix, coordinates[index], PRIME)
            == [
                (
                    coordinates[action[index]][coordinate]
                    - coordinates[moved_base][coordinate]
                )
                % PRIME
                for coordinate in range(10)
            ]
            for index in range(len(orbit))
        )
        return matrix

    assert parent_group == {
        element
        for element in full_group
        if MM.matching_image(element, base_matching) == base_matching
    }
    return {
        "parent_group": parent_group,
        "induced_action": induced_action,
        "cubic": cubic,
        "cube_basis": cube_basis,
        "coordinates": coordinates,
    }


def restrict_cubic(
    cubic: list[int],
    cube_basis: list[tuple[int, int, int]],
    intertwiner: list[list[int]],
) -> list[list[list[int]]]:
    inverse = MM.matrix_inverse(intertwiner, PRIME)
    pair_embedding = []
    for left, right in itertools.combinations(range(5), 2):
        pair_embedding.append(
            [
                (
                    int(left == coordinate)
                    + int(right == coordinate)
                    - int(left == 4)
                    - int(right == 4)
                )
                % PRIME
                for coordinate in range(4)
            ]
        )
    contraction = [
        [
            sum(inverse[pair][w] * pair_embedding[pair][coordinate] for pair in range(10))
            % PRIME
            for coordinate in range(4)
        ]
        for w in range(10)
    ]
    cubic_by_index = dict(zip(cube_basis, cubic))
    return [
        [
            [
                sum(
                    cubic_by_index[tuple(sorted((i, j, k)))]
                    * contraction[i][a]
                    * contraction[j][b]
                    * contraction[k][c]
                    for i in range(10)
                    for j in range(10)
                    for k in range(10)
                )
                % PRIME
                for c in range(4)
            ]
            for b in range(4)
        ]
        for a in range(4)
    ]


def clebsch_scalar(restricted: list[list[list[int]]]) -> int:
    inverse_three = pow(3, -1, PRIME)
    target = [
        [
            [
                0 if a == b == c else -inverse_three % PRIME
                for c in range(4)
            ]
            for b in range(4)
        ]
        for a in range(4)
    ]
    scalar = None
    for a, b, c in itertools.product(range(4), repeat=3):
        if target[a][b][c]:
            candidate = (
                restricted[a][b][c]
                * pow(target[a][b][c], -1, PRIME)
                % PRIME
            )
            scalar = candidate if scalar is None else scalar
            assert candidate == scalar
        else:
            assert restricted[a][b][c] == 0
    assert scalar not in (None, 0)
    return scalar


def build_certificate() -> dict[str, object]:
    workspace = h3_workspace()
    parent_group = workspace["parent_group"]
    _subgroups, five_actions = natural_five_action(parent_group)
    generators = MM.permutation_generators(parent_group)
    w_actions = [workspace["induced_action"](element) for element in generators]
    pair_permutations = [pair_action(five_actions[element]) for element in generators]
    p_actions = [permutation_matrix(permutation) for permutation in pair_permutations]
    hom_basis = intertwiner_basis(w_actions, p_actions)
    coefficients, intertwiner = chosen_intertwiner(hom_basis)
    assert all(
        MM.matrix_product(workspace["induced_action"](element), intertwiner, PRIME)
        == MM.matrix_product(
            intertwiner,
            permutation_matrix(pair_action(five_actions[element])),
            PRIME,
        )
        for element in parent_group
    )
    restricted = restrict_cubic(
        workspace["cubic"], workspace["cube_basis"], intertwiner
    )
    scalar = clebsch_scalar(restricted)
    flattened_cubic = workspace["cubic"]
    flattened_restriction = [
        restricted[a][b][c]
        for a, b, c in itertools.product(range(4), repeat=3)
    ]
    return {
        "schema": "clebsch-hitchin-tensor-bridge-v1",
        "field": "F_11",
        "parent_group_order": len(parent_group),
        "a4_subgroup_count": 5,
        "natural_five_action_order": len(set(five_actions.values())),
        "pair_module_dimension": 10,
        "quotient_module_dimension": 10,
        "intertwiner_space_dimension": len(hom_basis),
        "chosen_intertwiner_coefficients": coefficients,
        "chosen_intertwiner": intertwiner,
        "chosen_intertwiner_rank": MM.rank(intertwiner, PRIME),
        "signed_cubic_coordinates": flattened_cubic,
        "signed_cubic_sha256": hashlib.sha256(bytes(flattened_cubic)).hexdigest(),
        "clebsch_restriction_tensor": flattened_restriction,
        "clebsch_restriction_scalar": scalar,
        "clebsch_restriction_nonzero": True,
        "integral_clebsch_line": "sigma_3=(sum_i y_i^3)/3 on sum_i y_i=0",
        "gaunt_scalar_over_q": "-784000/1247103",
        "gaunt_denominator_divisible_by_11": 1247103 % 11 == 0,
        "cross_characteristic_claim": (
            "Both tensors generate the integral Clebsch invariant cubic line; "
            "the rational Gaunt normalization is not reduced modulo 11."
        ),
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (MATCHING_MODULE_PATH, SCOUT_PATH)
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT.relative_to(REPOSITORY)}")
        return 0
    if not OUTPUT.is_file() or OUTPUT.read_text(encoding="utf-8") != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    print("Clebsch--Hitchin tensor bridge certificate: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
