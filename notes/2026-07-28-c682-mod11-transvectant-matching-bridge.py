#!/usr/bin/env python3
"""Exact mod-11 comparison of the C682 transvectant and C651 matching cubic."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPOSITORY = HERE.parent
EVIDENCE = REPOSITORY / "papers" / "clebsch-factorization" / "verification" / "evidence"
MATCHING_MODULE_PATH = EVIDENCE / "matching_module.py"
SCOUT_PATH = EVIDENCE / "matching_orbit_scout.json"
C651_PATH = HERE / "2026-07-26-c651-hitchin-tensor-bridge.py"
C651_CERTIFICATE_PATH = HERE / "2026-07-26-c651-hitchin-tensor-bridge.json"
CERTIFICATE_PATH = HERE / "2026-07-28-c682-mod11-transvectant-matching-bridge.json"
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MM = load_module("c682_mod11_matching_module", MATCHING_MODULE_PATH)
C651 = load_module("c682_mod11_c651", C651_PATH)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def binomial(n: int, k: int) -> int:
    return math.comb(n, k) if 0 <= k <= n else 0


def falling(n: int, k: int) -> int:
    if k < 0 or n < k:
        return 0
    return math.prod(range(n - k + 1, n + 1))


def polynomial_action(degree: int, matrix: tuple[int, int, int, int]) -> list[list[int]]:
    """Substitution action on X^(degree-k)Y^k, in increasing Y-degree."""
    a, b, c, d = matrix
    action = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        x_power = degree - column
        y_power = column
        for left_y in range(x_power + 1):
            left = (
                binomial(x_power, left_y)
                * pow(a, x_power - left_y, PRIME)
                * pow(b, left_y, PRIME)
            )
            for right_y in range(y_power + 1):
                right = (
                    binomial(y_power, right_y)
                    * pow(c, y_power - right_y, PRIME)
                    * pow(d, right_y, PRIME)
                )
                row = left_y + right_y
                action[row][column] = (
                    action[row][column] + left * right
                ) % PRIME
    return action


def projective_action(
    degree: int,
    matrix: tuple[int, int, int, int],
    determinant: int,
) -> list[list[int]]:
    """The scalar-independent action det^(-degree/2) Sym^degree."""
    scale = pow(determinant, -(degree // 2), PRIME)
    return [
        [(scale * entry) % PRIME for entry in row]
        for row in polynomial_action(degree, matrix)
    ]


def pgl_matrix_data(
    parameters: tuple[tuple[int, int], ...],
) -> dict[tuple[int, ...], tuple[tuple[int, int, int, int], int]]:
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    data = {}
    for entries in itertools.product(range(PRIME), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % PRIME
        if not determinant:
            continue
        normalized = MM.normalize_matrix(entries, PRIME)
        if normalized != entries:
            continue
        permutation = tuple(
            parameter_index[
                MM.COXETER.normalize_pair(
                    (a * left + b * right, c * left + d * right),
                    PRIME,
                )
            ]
            for left, right in parameters
        )
        data[permutation] = (entries, determinant)
    assert len(data) == PRIME * (PRIME * PRIME - 1)
    return data


def third_transvectant_matrix() -> list[list[int]]:
    """Primitive (content divided out) map (p,Phi_12)_3 reduced mod 11."""
    phi = [(1, 11, 1), (11, 6, 6), (-1, 1, 11)]
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        px, py = 6 - column, column
        for index in range(4):
            left = (
                (-1) ** index
                * math.comb(3, index)
                * falling(px, 3 - index)
                * falling(py, index)
            )
            if not left:
                continue
            for coefficient, fx, fy in phi:
                right = (
                    coefficient
                    * falling(fx, index)
                    * falling(fy, 3 - index)
                )
                if not right:
                    continue
                row = py - index + fy - (3 - index)
                matrix[row][column] += left * right
    divisor = math.gcd(*(entry for row in matrix for entry in row))
    assert divisor == 2640
    return [[entry // divisor % PRIME for entry in row] for row in matrix]


def matrix_scale(scalar: int, matrix: list[list[int]]) -> list[list[int]]:
    return [[scalar * entry % PRIME for entry in row] for row in matrix]


def projective_normalize_matrix(matrix: list[list[int]]) -> tuple[int, ...]:
    flattened = [entry % PRIME for row in matrix for entry in row]
    pivot = next(entry for entry in flattened if entry)
    inverse = pow(pivot, -1, PRIME)
    return tuple(inverse * entry % PRIME for entry in flattened)


def matrix_submatrix_rows(
    matrix: list[list[int]],
    rows: list[int],
) -> list[list[int]]:
    return [matrix[row] for row in rows]


def image_action(
    image_basis: list[list[int]],
    codomain_action: list[list[int]],
    independent_rows: list[int],
) -> list[list[int]]:
    target = MM.matrix_product(codomain_action, image_basis, PRIME)
    square_basis = matrix_submatrix_rows(image_basis, independent_rows)
    square_target = matrix_submatrix_rows(target, independent_rows)
    result = MM.matrix_product(
        MM.matrix_inverse(square_basis, PRIME),
        square_target,
        PRIME,
    )
    assert MM.matrix_product(image_basis, result, PRIME) == target
    return result


def standard_four_action(permutation: tuple[int, ...]) -> list[list[int]]:
    """Action on sum(y_i)=0 in the basis e_i-e_4, 0 <= i < 4."""
    return [
        [
            (
                int(row == permutation[column])
                - int(row == permutation[4])
            )
            % PRIME
            for column in range(4)
        ]
        for row in range(4)
    ]


def hom_basis(
    left_actions: list[list[list[int]]],
    right_actions: list[list[list[int]]],
) -> list[list[int]]:
    equations = []
    for left, right in zip(left_actions, right_actions):
        for row in range(4):
            for column in range(4):
                equation = [0] * 16
                for middle in range(4):
                    equation[middle * 4 + column] += left[row][middle]
                    equation[row * 4 + middle] -= right[middle][column]
                equations.append([entry % PRIME for entry in equation])
    return MM.nullspace(equations, PRIME)


def normalized_matrix(vector: list[int]) -> list[list[int]]:
    pivot = next(entry for entry in vector if entry)
    inverse = pow(pivot, -1, PRIME)
    normalized = [inverse * entry % PRIME for entry in vector]
    return [normalized[4 * row : 4 * row + 4] for row in range(4)]


def clebsch_tensor() -> list[int]:
    inverse_three = pow(3, -1, PRIME)
    return [
        0 if a == b == c else -inverse_three % PRIME
        for a, b, c in itertools.product(range(4), repeat=3)
    ]


def tensor_transform(matrix: list[list[int]], tensor: list[int]) -> list[int]:
    value = {
        (a, b, c): tensor[16 * a + 4 * b + c]
        for a, b, c in itertools.product(range(4), repeat=3)
    }
    return [
        sum(
            matrix[a][i] * matrix[b][j] * matrix[c][k] * value[(i, j, k)]
            for i, j, k in itertools.product(range(4), repeat=3)
        )
        % PRIME
        for a, b, c in itertools.product(range(4), repeat=3)
    ]


def matching_workspace():
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
    coordinates = [
        [vector[index] for index in coordinate_pivots]
        for vector in quotient_vectors
    ]
    first_sheet = {
        MM.matching_image(element, min(orbit))
        for element in psl_group
    }
    signs = [1 if matching in first_sheet else -1 % PRIME for matching in orbit]
    cube_basis = list(itertools.combinations_with_replacement(range(10), 3))
    cubic = [
        sum(
            sign * MM.symmetric_power(vector, 3, PRIME)[index]
            for sign, vector in zip(signs, coordinates)
        )
        % PRIME
        for index in range(len(cube_basis))
    ]
    _point_reduced, point_basis_indices = MM.rref(MM.transpose(coordinates), PRIME)
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
        return MM.matrix_product(target_basis, point_basis_inverse, PRIME)

    return {
        "parameters": endpoints,
        "full_group": full_group,
        "psl_group": psl_group,
        "parent_group": parent_group,
        "base_matching": base_matching,
        "orbit": orbit,
        "first_sheet": first_sheet,
        "coordinates": coordinates,
        "signs": signs,
        "cube_basis": cube_basis,
        "cubic": cubic,
        "induced_action": induced_action,
    }


def transformed_matching_cubic(
    action: list[list[int]],
    coordinates: list[list[int]],
    signs: list[int],
) -> list[int]:
    transformed = [
        MM.matrix_vector(action, vector, PRIME)
        for vector in coordinates
    ]
    powers = [MM.symmetric_power(vector, 3, PRIME) for vector in transformed]
    return [
        sum(
            sign * power[index]
            for sign, power in zip(signs, powers)
        )
        % PRIME
        for index in range(220)
    ]


def build_certificate() -> dict[str, object]:
    workspace = matching_workspace()
    full_group = workspace["full_group"]
    psl_group = workspace["psl_group"]
    parent_group = workspace["parent_group"]
    matrix_data = pgl_matrix_data(workspace["parameters"])
    assert set(matrix_data) == full_group
    determinant_character = {
        element: (
            1
            if matrix_data[element][1] in {square * square % PRIME for square in range(1, PRIME)}
            else -1 % PRIME
        )
        for element in full_group
    }
    assert {
        element for element, character in determinant_character.items() if character == 1
    } == psl_group
    assert parent_group <= psl_group

    transvectant = third_transvectant_matrix()
    assert MM.rank(transvectant, PRIME) == 4
    pivot_columns = [0, 1, 2, 4]
    image_basis = [
        [transvectant[row][column] for column in pivot_columns]
        for row in range(13)
    ]
    _reduced, independent_rows = MM.rref(MM.transpose(image_basis), PRIME)
    assert len(independent_rows) == 4

    phi = [0] * 13
    phi[1], phi[11] = 1, -1 % PRIME
    transvectant_twisted_elements = set()
    dickson_character = True
    degree_six_actions = {}
    degree_twelve_actions = {}
    for element in full_group:
        matrix, determinant = matrix_data[MM.inverse(element)]
        action_six = projective_action(6, matrix, determinant)
        action_twelve = projective_action(12, matrix, determinant)
        degree_six_actions[element] = action_six
        degree_twelve_actions[element] = action_twelve
        character = determinant_character[element]
        dickson_character &= (
            MM.matrix_vector(action_twelve, phi, PRIME)
            == [character * entry % PRIME for entry in phi]
        )
        if MM.matrix_product(transvectant, action_six, PRIME) == matrix_scale(
                character,
                MM.matrix_product(action_twelve, transvectant, PRIME),
            ):
            transvectant_twisted_elements.add(element)
    assert dickson_character
    assert len(transvectant_twisted_elements) == 60
    assert transvectant_twisted_elements <= psl_group

    conjugator = next(
        element
        for element in sorted(full_group)
        if {
            MM.compose(
                MM.compose(element, member),
                MM.inverse(element),
            )
            for member in transvectant_twisted_elements
        }
        == parent_group
    )
    marked_transvectant = MM.matrix_product(
        MM.matrix_product(
            degree_twelve_actions[conjugator],
            transvectant,
            PRIME,
        ),
        MM.matrix_inverse(degree_six_actions[conjugator], PRIME),
        PRIME,
    )

    def moved_transvectant(element):
        return MM.matrix_product(
            MM.matrix_product(
                degree_twelve_actions[element],
                marked_transvectant,
                PRIME,
            ),
            MM.matrix_inverse(degree_six_actions[element], PRIME),
            PRIME,
        )

    marked_stabilizer = {
        element
        for element in full_group
        if projective_normalize_matrix(moved_transvectant(element))
        == projective_normalize_matrix(marked_transvectant)
    }
    assert marked_stabilizer == parent_group, (
        len(marked_stabilizer),
        len(marked_stabilizer & parent_group),
    )
    transvectant_orbit = {
        projective_normalize_matrix(moved_transvectant(element))
        for element in full_group
    }
    assert len(transvectant_orbit) == 22

    matching_to_transvectant = {}
    for element in full_group:
        matching = MM.matching_image(element, workspace["base_matching"])
        image = projective_normalize_matrix(moved_transvectant(element))
        if matching in matching_to_transvectant:
            assert matching_to_transvectant[matching] == image
        matching_to_transvectant[matching] = image
    assert len(matching_to_transvectant) == 22
    assert set(matching_to_transvectant.values()) == transvectant_orbit

    base_matching_sheet = {
        MM.matching_image(element, workspace["base_matching"])
        for element in psl_group
    }
    base_transvectant_sheet = {
        projective_normalize_matrix(moved_transvectant(element))
        for element in psl_group
    }
    assert len(base_matching_sheet) == len(base_transvectant_sheet) == 11
    assert {
        matching_to_transvectant[matching]
        for matching in base_matching_sheet
    } == base_transvectant_sheet

    five_actions = C651.natural_five_action(parent_group)[1]
    generators = MM.permutation_generators(parent_group)
    marked_pivot_columns = MM.rref(marked_transvectant, PRIME)[1]
    assert len(marked_pivot_columns) == 4
    image_actions = [
        image_action(
            [
                [marked_transvectant[row][column] for column in marked_pivot_columns]
                for row in range(13)
            ],
            degree_twelve_actions[element],
            MM.rref(
                MM.transpose(
                    [
                        [
                            marked_transvectant[row][column]
                            for column in marked_pivot_columns
                        ]
                        for row in range(13)
                    ]
                ),
                PRIME,
            )[1],
        )
        for element in generators
    ]
    four_actions = [standard_four_action(five_actions[element]) for element in generators]
    bridge_basis = hom_basis(image_actions, four_actions)
    assert len(bridge_basis) == 1
    standard_to_image = normalized_matrix(bridge_basis[0])
    assert MM.rank(standard_to_image, PRIME) == 4
    marked_image_basis = [
        [marked_transvectant[row][column] for column in marked_pivot_columns]
        for row in range(13)
    ]
    marked_independent_rows = MM.rref(
        MM.transpose(marked_image_basis),
        PRIME,
    )[1]
    assert all(
        MM.matrix_product(
            image_action(
                marked_image_basis,
                degree_twelve_actions[element],
                marked_independent_rows,
            ),
            standard_to_image,
            PRIME,
        )
        == MM.matrix_product(
            standard_to_image,
            standard_four_action(five_actions[element]),
            PRIME,
        )
        for element in parent_group
    )

    c651_certificate = json.loads(C651_CERTIFICATE_PATH.read_text(encoding="utf-8"))
    assert c651_certificate["clebsch_restriction_scalar"] == 4
    standard_cubic = clebsch_tensor()
    image_to_standard = MM.matrix_inverse(standard_to_image, PRIME)
    image_cubic = tensor_transform(
        MM.transpose(image_to_standard),
        [4 * entry % PRIME for entry in standard_cubic],
    )
    assert any(image_cubic)
    assert all(
        tensor_transform(
            MM.transpose(
                MM.matrix_inverse(
                    image_action(
                        marked_image_basis,
                        degree_twelve_actions[element],
                        marked_independent_rows,
                    ),
                    PRIME,
                )
            ),
            image_cubic,
        )
        == image_cubic
        for element in parent_group
    )

    matching_cubic = workspace["cubic"]
    assert matching_cubic == c651_certificate["signed_cubic_coordinates"]
    matching_character = all(
        transformed_matching_cubic(
            workspace["induced_action"](element),
            workspace["coordinates"],
            workspace["signs"],
        )
        == [
            determinant_character[element] * entry % PRIME
            for entry in matching_cubic
        ]
        for element in full_group
    )
    assert matching_character

    exchanger = min(full_group - psl_group)
    exchanged_sheet = {
        MM.matching_image(exchanger, matching)
        for matching in workspace["first_sheet"]
    }
    assert exchanged_sheet == set(workspace["orbit"]) - workspace["first_sheet"]
    assert determinant_character[exchanger] == -1 % PRIME

    return {
        "schema": "c682-mod11-transvectant-matching-bridge-v1",
        "field": "F_11",
        "pgl_order": len(full_group),
        "psl_order": len(psl_group),
        "parent_a5_order": len(parent_group),
        "matching_orbit_size": len(workspace["orbit"]),
        "matching_sheet_sizes": [
            len(workspace["first_sheet"]),
            len(workspace["orbit"]) - len(workspace["first_sheet"]),
        ],
        "projective_action": "det(g)^(-n/2) Sym^n(g) on binary forms of even degree n",
        "dickson_dodecic_character": "quadratic determinant character",
        "primitive_transvectant_rank": MM.rank(transvectant, PRIME),
        "primitive_transvectant_matrix": transvectant,
        "unmarked_transvectant_projective_stabilizer_order": len(
            transvectant_twisted_elements
        ),
        "unmarked_transvectant_projective_stabilizer_in_psl": True,
        "marking_conjugator": list(conjugator),
        "marked_transvectant_matrix": marked_transvectant,
        "marked_transvectant_projective_stabilizer_order": len(marked_stabilizer),
        "marked_transvectant_orbit_size": len(transvectant_orbit),
        "matching_to_transvectant_orbit_bijection": True,
        "matching_to_transvectant_psl_sheet_compatibility": True,
        "image_basis_pivot_columns": marked_pivot_columns,
        "image_basis_independent_rows": marked_independent_rows,
        "a5_standard_to_transvectant_image_hom_dimension": len(bridge_basis),
        "a5_standard_to_transvectant_image": standard_to_image,
        "c651_matching_cubic_scalar_on_clebsch_tensor": 4,
        "matching_cubic_on_transvectant_image": image_cubic,
        "matching_cubic_character_checked_elements": len(full_group),
        "matching_cubic_character": "quadratic determinant character",
        "exchanger_permutation": list(exchanger),
        "exchanger_swaps_matching_sheets": True,
        "exchanger_swaps_transvectant_sheets": True,
        "conclusion": (
            "After conjugating the primitive transvectant to the frozen C651 "
            "A5 marking, its 22-element PGL2(11) orbit is equivariantly identical "
            "to the matching orbit and the two PSL2(11) sheets agree. Its "
            "rank-four image and the C651 Clebsch four-space have a one-dimensional "
            "A5 Hom space, and the C651 signed cubic gives the nonzero invariant "
            "cubic line on that image. The matching cubic transforms by the "
            "quadratic determinant character, while every outer element exchanges "
            "the matched transvectant sheets."
        ),
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (
                MATCHING_MODULE_PATH,
                SCOUT_PATH,
                C651_PATH,
                C651_CERTIFICATE_PATH,
            )
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    encoded = canonical_bytes(certificate)
    if args.write:
        CERTIFICATE_PATH.write_bytes(encoded)
    else:
        assert CERTIFICATE_PATH.read_bytes() == encoded
    print(
        "C682 mod-11 transvectant--matching bridge: OK "
        f"({certificate['pgl_order']} PGL elements, "
        f"rank {certificate['primitive_transvectant_rank']}, "
        "matched outer sheets)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
