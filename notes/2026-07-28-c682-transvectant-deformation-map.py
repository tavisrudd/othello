#!/usr/bin/env python3
"""Construct the C682 divided-transvectant deformation/incidence map."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
DIVIDED_SCRIPT = NOTES / "2026-07-28-c682-invariant-operator-divided-power.py"
DIVIDED_CERTIFICATE = DIVIDED_SCRIPT.with_suffix(".json")
CORRECTED_CERTIFICATE = NOTES / "2026-07-28-c682-corrected-bridge-mod-1331.json"
ARITHMETIC_CERTIFICATE = (
    REPOSITORY
    / "papers"
    / "clebsch-passages"
    / "verification"
    / "evidence"
    / "arithmetic_cover.json"
)
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11
MODULUS = PRIME**2
F_VECTOR = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
FROBENIUS_INDICES = (0, 1, 11, 12)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DIVIDED = load_module("c682_divided", DIVIDED_SCRIPT)
MM = DIVIDED.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matmul(left, right, modulus: int = PRIME):
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            % modulus
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matvec(matrix, vector, modulus: int):
    return [
        sum(matrix[row][column] * vector[column] for column in range(len(vector)))
        % modulus
        for row in range(len(matrix))
    ]


def normalize_projective(vector, modulus: int = PRIME):
    pivot = next(value % modulus for value in vector if value % modulus)
    inverse = pow(pivot, -1, modulus)
    return [value * inverse % modulus for value in vector]


def serialize_form(vector, degree: int):
    return [
        {"x": degree - row, "y": row, "coefficient": value}
        for row, value in enumerate(vector)
        if value
    ]


def third_matrix(right_vector):
    right = {
        (12 - row, row): value
        for row, value in enumerate(right_vector)
        if value
    }
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = DIVIDED.raw_third_transvectant_with_right(
            {(6 - column, column): 1}, right
        )
        for row in range(13):
            matrix[row][column] = image.get((12 - row, row), 0) % PRIME
    return matrix


def fifth_pair(left, right):
    output = [0, 0, 0]
    for left_y, left_coefficient in enumerate(left):
        for right_y, right_coefficient in enumerate(right):
            for index in range(6):
                output_y = left_y - index + right_y - (5 - index)
                if not 0 <= output_y <= 2:
                    continue
                output[output_y] += (
                    (-1) ** index
                    * math.comb(5, index)
                    * left_coefficient
                    * math.prod(range(6 - left_y - (5 - index) + 1, 6 - left_y + 1))
                    * math.prod(range(left_y - index + 1, left_y + 1))
                    * right_coefficient
                    * math.prod(range(6 - right_y - index + 1, 6 - right_y + 1))
                    * math.prod(range(right_y - (5 - index) + 1, right_y + 1))
                )
    return [value % PRIME for value in output]


def apolar_annihilator(plane):
    equations = []
    for vector in plane:
        equations.append(
            [
                (
                    vector[6 - column]
                    * (-1) ** (6 - column)
                    * math.factorial(6 - column)
                    * math.factorial(column)
                )
                % PRIME
                for column in range(7)
            ]
        )
    return MM.nullspace(equations, PRIME)


def isotropy_rows(plane):
    return [
        fifth_pair(plane[left], plane[right])
        for left in range(3)
        for right in range(left + 1, 3)
    ]


def conic_quadratic_parameterization():
    points, parameters = MM.COXETER.conic_parameterization(PRIME)
    equations = []
    for point, (left, right) in zip(points, parameters):
        monomials = [left * left % PRIME, left * right % PRIME, right * right % PRIME]
        row = [0] * 9
        for index, monomial in enumerate(monomials):
            row[index] = monomial * point[1] % PRIME
            row[3 + index] = -monomial * point[0] % PRIME
        equations.append(row)
        row = [0] * 9
        for index, monomial in enumerate(monomials):
            row[index] = monomial * point[2] % PRIME
            row[6 + index] = -monomial * point[0] % PRIME
        equations.append(row)
    kernel = MM.nullspace(equations, PRIME)
    assert len(kernel) == 1
    return points, parameters, [kernel[0][offset : offset + 3] for offset in (0, 3, 6)]


def polynomial_product(left, right):
    output = [0] * (len(left) + len(right) - 1)
    for left_degree, left_value in enumerate(left):
        for right_degree, right_value in enumerate(right):
            output[left_degree + right_degree] = (
                output[left_degree + right_degree] + left_value * right_value
            ) % PRIME
    return output


def euclidean_exchanger_permutation(points):
    normalized = [tuple(normalize_projective(point)) for point in points]
    permutation = []
    for x, y, z in points:
        image = tuple(normalize_projective((x, -z, y)))
        permutation.append(normalized.index(image))
    return tuple(permutation)


def operator_from_correction(primitive, correction):
    matrix = third_matrix(correction)
    coefficient = pow(240, -1, PRIME)
    assert coefficient == 5
    return [
        [
            (primitive[row][column] + coefficient * matrix[row][column]) % PRIME
            for column in range(7)
        ]
        for row in range(13)
    ]


def transformed_correction(correction, exchanger):
    lifted = [
        (F_VECTOR[index] + PRIME * correction[index]) % MODULUS
        for index in range(13)
    ]
    action = DIVIDED.symmetric_action_mod(exchanger, 12, 1, MODULUS)
    transformed = matvec(action, lifted, MODULUS)
    normalization = pow(transformed[1], -1, MODULUS)
    transformed = [normalization * value % MODULUS for value in transformed]
    assert [value % PRIME for value in transformed] == [
        value % PRIME for value in F_VECTOR
    ]
    quotient = []
    for index in range(13):
        difference = (transformed[index] - F_VECTOR[index]) % MODULUS
        assert difference % PRIME == 0
        quotient.append(difference // PRIME)
    return quotient, normalization


def flatten(matrix):
    return [value for row in matrix for value in row]


def certificate():
    divided = json.loads(DIVIDED_CERTIFICATE.read_text(encoding="utf-8"))
    corrected = json.loads(CORRECTED_CERTIFICATE.read_text(encoding="utf-8"))
    arithmetic = json.loads(ARITHMETIC_CERTIFICATE.read_text(encoding="utf-8"))
    primitive = divided["sym6_primitive_matrix"]
    correction = [0] * 13
    for term in corrected["first_correction_digit_from_F"]:
        correction[term["y"]] = term["coefficient"]

    points, parameters, quadratic_map = conic_quadratic_parameterization()
    permutation = euclidean_exchanger_permutation(points)
    exchanger = tuple(DIVIDED.recover_pgl_matrix(permutation, tuple(parameters)))
    assert exchanger == (1, 3, 3, 6)
    assert arithmetic["exchanger"]["matrix"] == [[1, 0, 0], [0, 0, -1], [0, 1, 0]]

    conjugate_correction, normalization = transformed_correction(correction, exchanger)
    operator = operator_from_correction(primitive, correction)
    conjugate_operator = operator_from_correction(primitive, conjugate_correction)
    assert MM.rank(operator, PRIME) == MM.rank(conjugate_operator, PRIME) == 4

    source_action = DIVIDED.symmetric_action_mod(exchanger, 6, 3, PRIME)
    target_action = DIVIDED.symmetric_action_mod(exchanger, 12, 1, PRIME)
    inverse_exchanger = DIVIDED.inverse_2x2_mod(exchanger, PRIME)
    inverse_source_action = DIVIDED.symmetric_action_mod(
        inverse_exchanger, 6, 3, PRIME
    )
    assert (
        matmul(matmul(target_action, operator), inverse_source_action)
        == conjugate_operator
    )

    kernel = MM.nullspace(operator, PRIME)
    conjugate_kernel = MM.nullspace(conjugate_operator, PRIME)
    assert len(kernel) == len(conjugate_kernel) == 3
    assert MM.rank(kernel + conjugate_kernel, PRIME) == 6
    assert MM.rank(
        conjugate_kernel + [matvec(source_action, row, PRIME) for row in kernel],
        PRIME,
    ) == 3
    assert isotropy_rows(kernel) == isotropy_rows(conjugate_kernel) == [[0, 0, 0]] * 3

    annihilator = apolar_annihilator(kernel)
    conjugate_annihilator = apolar_annihilator(conjugate_kernel)
    intersection = apolar_annihilator(kernel + conjugate_kernel)
    assert len(annihilator) == len(conjugate_annihilator) == 4
    assert len(intersection) == 1
    incidence_vector = normalize_projective(intersection[0])
    assert incidence_vector == [1, 0, 6, 0, 6, 0, 1]
    incidence_image = matvec(source_action, incidence_vector, PRIME)
    assert incidence_image == [(-value) % PRIME for value in incidence_vector]

    xyz_restriction = polynomial_product(
        polynomial_product(quadratic_map[0], quadratic_map[1]), quadratic_map[2]
    )
    assert xyz_restriction == [6 * value % PRIME for value in incidence_vector]

    directions = [third_matrix([int(index == basis) for index in range(13)]) for basis in range(13)]
    theta_matrix = [
        [flatten(directions[column])[row] for column in range(13)]
        for row in range(13 * 7)
    ]
    theta_kernel = MM.nullspace(theta_matrix, PRIME)
    frobenius_basis = [
        [int(index == basis) for index in range(13)] for basis in FROBENIUS_INDICES
    ]
    assert MM.rank(theta_matrix, PRIME) == 9
    assert MM.rank(theta_kernel + frobenius_basis, PRIME) == 4
    augmented_operator_directions = [
        flatten(primitive)
    ] + [[5 * value % PRIME for value in flatten(direction)] for direction in directions]
    augmented_rank = MM.rank(
        [list(column) for column in zip(*augmented_operator_directions)], PRIME
    )
    assert augmented_rank == 10

    raw_conjugate = matvec(
        DIVIDED.symmetric_action_mod(exchanger, 12, 1, PRIME),
        correction,
        PRIME,
    )
    exchanger_cocycle = [
        (conjugate_correction[index] - raw_conjugate[index]) % PRIME
        for index in range(13)
    ]
    cocycle_operator = third_matrix(exchanger_cocycle)
    conjugated_primitive = matmul(
        matmul(target_action, primitive), inverse_source_action
    )
    assert all(
        (
            conjugated_primitive[row][column]
            - primitive[row][column]
            - 5 * cocycle_operator[row][column]
        )
        % PRIME
        == 0
        for row in range(13)
        for column in range(7)
    )

    quotient_coordinates = [index for index in range(13) if index not in FROBENIUS_INDICES]
    quotient_pair = [
        [vector[index] for index in quotient_coordinates]
        for vector in (correction, conjugate_correction)
    ]
    assert MM.rank(quotient_pair, PRIME) == 2
    quotient_directions = [directions[index] for index in quotient_coordinates]

    def recover_extended_normal_line(plane):
        equations = []
        for vector in plane:
            for output in range(13):
                equations.append(
                    [
                        sum(
                            primitive[output][column] * vector[column]
                            for column in range(7)
                        )
                        % PRIME
                    ]
                    + [
                        5
                        * sum(
                            direction[output][column] * vector[column]
                            for column in range(7)
                        )
                        % PRIME
                        for direction in quotient_directions
                    ]
                )
        normal_line = MM.nullspace(equations, PRIME)
        assert len(normal_line) == 1
        return MM.rank(equations, PRIME), normalize_projective(normal_line[0])

    selected_inverse_rank, selected_recovered_line = recover_extended_normal_line(kernel)
    conjugate_inverse_rank, conjugate_recovered_line = recover_extended_normal_line(
        conjugate_kernel
    )
    assert selected_recovered_line == [1] + quotient_pair[0]
    assert conjugate_recovered_line == [1] + quotient_pair[1]

    inputs = (
        DIVIDED_SCRIPT,
        DIVIDED_CERTIFICATE,
        CORRECTED_CERTIFICATE,
        ARITHMETIC_CERTIFICATE,
    )
    return {
        "schema": "c682-transvectant-deformation-map-v1",
        "field": "F_11",
        "bases": {
            "H_equals_Sym6": "X^(6-i)Y^i, 0<=i<=6",
            "dodecics_equals_Sym12": "X^(12-i)Y^i, 0<=i<=12",
        },
        "extended_normal_space": {
            "ordinary_normal_quotient": (
                "Sym^12/(V^(1) tensor V), with Frobenius indices 0,1,11,12 removed"
            ),
            "ordinary_normal_dimension": 9,
            "ordinary_third_transvectant_rank": MM.rank(theta_matrix, PRIME),
            "ordinary_third_transvectant_kernel": theta_kernel,
            "bockstein_direction": "P_F, the primitive divided operator of the fixed lift F",
            "P_F_is_outside_ordinary_transvectant_image": True,
            "extended_normal_dimension": augmented_rank,
            "homogenized_map": (
                "widehatTheta(a,[L])=a*P_F+5*(-,L)_3; "
                "kappa([a,L])=ker(widehatTheta(a,[L])) on the rank-four locus"
            ),
        },
        "exchanger": {
            "euclidean_matrix": arithmetic["exchanger"]["matrix"],
            "parameter_permutation": list(permutation),
            "binary_PGL2_matrix": list(exchanger),
            "determinant_mod_11": (
                exchanger[0] * exchanger[3] - exchanger[1] * exchanger[2]
            )
            % PRIME,
            "normalization_mod_121": normalization,
            "operator_cocycle": serialize_form(exchanger_cocycle, 12),
            "operator_cocycle_quotient_coordinates": [
                exchanger_cocycle[index] for index in quotient_coordinates
            ],
            "cocycle_identity": (
                "rho12(R) P_F rho6(R)^(-1)-P_F=5*(-,c_R)_3"
            ),
        },
        "normal_lines": {
            "selected_line": "(1,[K]) in P(F_11 direct_sum N)",
            "selected_K": serialize_form(correction, 12),
            "conjugate_line": "(1,[K_R])=R*(1,[K])",
            "conjugate_K": serialize_form(conjugate_correction, 12),
            "quotient_coordinate_indices": quotient_coordinates,
            "quotient_coordinate_pair": quotient_pair,
            "lines_are_distinct": True,
        },
        "kernel_map": {
            "selected_operator_rank": MM.rank(operator, PRIME),
            "conjugate_operator_rank": MM.rank(conjugate_operator, PRIME),
            "selected_kernel": kernel,
            "conjugate_kernel": conjugate_kernel,
            "kernels_are_distinct": True,
            "sum_dimension": MM.rank(kernel + conjugate_kernel, PRIME),
            "exchanger_covariance": True,
            "fifth_transvectant_isotropy_selected": isotropy_rows(kernel),
            "fifth_transvectant_isotropy_conjugate": isotropy_rows(conjugate_kernel),
            "inverse_annihilator_construction": (
                "U maps to the projective kernel of "
                "(a,[L]) -> widehatTheta(a,[L]) restricted to U"
            ),
            "selected_inverse_equation_rank": selected_inverse_rank,
            "conjugate_inverse_equation_rank": conjugate_inverse_rank,
            "selected_recovered_extended_normal_line": selected_recovered_line,
            "conjugate_recovered_extended_normal_line": conjugate_recovered_line,
            "kernel_and_extended_annihilator_are_inverse_on_golden_pair": True,
        },
        "incidence_map": {
            "definition": (
                "([a,L],[f]) maps to ([f],ker widehatTheta(a,[L])) "
                "when f lies in the apolar annihilator of the kernel"
            ),
            "selected_annihilator_four_plane": annihilator,
            "conjugate_annihilator_four_plane": conjugate_annihilator,
            "annihilator_intersection_dimension": len(intersection),
            "common_incidence_line": incidence_vector,
            "exchanger_scalar_on_common_line": PRIME - 1,
            "conic_quadratic_parameterization": quadratic_map,
            "xyz_restriction_to_parameter_conic": xyz_restriction,
            "xyz_restriction_scalar_times_common_line": 6,
            "orientation_scalars_mod_11": [4, 7],
            "conclusion": (
                "The two exchanged extended normal lines map to two distinct "
                "fifth-transvectant-isotropic parent planes whose annihilator "
                "four-planes meet in the binary sextic line representing xyz."
            ),
        },
        "trust_boundary": [
            "Exact F_11 linear algebra constructs and checks the extended normal and incidence maps.",
            "The identification of the isotropic-plane scheme with the Mukai-Umemura threefold is a human theorem imported from Hitchin.",
            "The known finite-etale degree-two incidence theorem at xyz makes the two constructed points the complete fibre; the script does not reprove global degree two.",
            "The calculation is for the marked mod-11 fibre and does not assert good reduction of the global incidence comparison.",
            "No novelty claim or Paper III manuscript change is made.",
        ],
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in inputs
        },
    }


def serialized_certificate():
    return (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized_certificate()
    if args.check:
        if OUTPUT.read_bytes() != payload:
            raise SystemExit("certificate mismatch")
        print("PASS: transvectant deformation-map certificate matches")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
