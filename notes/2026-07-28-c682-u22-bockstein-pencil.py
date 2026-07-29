#!/usr/bin/env python3
"""Globalize the marked U_22 section and invariant pencil through 11^2."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
import tempfile
from functools import reduce
from pathlib import Path


PRIME = 11
MODULUS = PRIME**2
LIFT_MODULUS = PRIME**3
NOTES = Path(__file__).resolve().parent
OUTPUT = NOTES / "2026-07-28-c682-u22-bockstein-pencil.json"
U22_SCRIPT = NOTES / "2026-07-28-c682-u22-linear-section.py"
U22_CERTIFICATE = NOTES / "2026-07-28-c682-u22-linear-section.json"
BRIDGE_CERTIFICATE = NOTES / "2026-07-28-c682-corrected-bridge-mod-1331.json"
DEFORMATION_CERTIFICATE = (
    NOTES / "2026-07-28-c682-transvectant-deformation-map.json"
)
RANK_CERTIFICATE = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
TRIPLES = list(itertools.combinations(range(7), 3))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


U22 = load_module("c682_u22_linear_section", U22_SCRIPT)
RANK = U22.RANK
MM = U22.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rank_mod_prime(rows):
    matrix = [[value % PRIME for value in row] for row in rows]
    if not matrix:
        return 0
    row = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (
                index
                for index in range(row, len(matrix))
                if matrix[index][column]
            ),
            None,
        )
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inverse = pow(matrix[row][column], -1, PRIME)
        matrix[row] = [value * inverse % PRIME for value in matrix[row]]
        for other in range(len(matrix)):
            if other == row or not matrix[other][column]:
                continue
            scale = matrix[other][column]
            matrix[other] = [
                (left - scale * right) % PRIME
                for left, right in zip(matrix[other], matrix[row])
            ]
        row += 1
    return row


def solve_square_mod_prime(matrix, rhs):
    size = len(matrix)
    augmented = [
        [value % PRIME for value in row] + [rhs[index] % PRIME]
        for index, row in enumerate(matrix)
    ]
    pivot_row = 0
    for column in range(size):
        pivot = next(
            (
                index
                for index in range(pivot_row, size)
                if augmented[index][column]
            ),
            None,
        )
        assert pivot is not None
        augmented[pivot_row], augmented[pivot] = (
            augmented[pivot],
            augmented[pivot_row],
        )
        inverse = pow(augmented[pivot_row][column], -1, PRIME)
        augmented[pivot_row] = [
            value * inverse % PRIME for value in augmented[pivot_row]
        ]
        for other in range(size):
            if other == pivot_row or not augmented[other][column]:
                continue
            scale = augmented[other][column]
            augmented[other] = [
                (left - scale * right) % PRIME
                for left, right in zip(
                    augmented[other], augmented[pivot_row]
                )
            ]
        pivot_row += 1
    assert pivot_row == size
    return [augmented[index][-1] for index in range(size)]


def primitive_transvectant_tensor(left_degree, right_degree, order):
    output_degree = left_degree + right_degree - 2 * order
    tensor = []
    nonzero = []
    for left_index in range(left_degree + 1):
        left_rows = []
        for right_index in range(right_degree + 1):
            output = [0] * (output_degree + 1)
            for index in range(order + 1):
                left_x_order = order - index
                left_y_order = index
                right_x_order = index
                right_y_order = order - index
                if (
                    left_degree - left_index < left_x_order
                    or left_index < left_y_order
                    or right_degree - right_index < right_x_order
                    or right_index < right_y_order
                ):
                    continue
                left_coefficient = (
                    math.factorial(left_degree - left_index)
                    // math.factorial(
                        left_degree - left_index - left_x_order
                    )
                    * math.factorial(left_index)
                    // math.factorial(left_index - left_y_order)
                )
                right_coefficient = (
                    math.factorial(right_degree - right_index)
                    // math.factorial(
                        right_degree - right_index - right_x_order
                    )
                    * math.factorial(right_index)
                    // math.factorial(right_index - right_y_order)
                )
                x_degree = (
                    left_degree
                    - left_index
                    - left_x_order
                    + right_degree
                    - right_index
                    - right_x_order
                )
                output_index = output_degree - x_degree
                output[output_index] += (
                    (-1) ** index
                    * math.comb(order, index)
                    * left_coefficient
                    * right_coefficient
                )
            left_rows.append(output)
            nonzero.extend(abs(value) for value in output if value)
        tensor.append(left_rows)
    divisor = reduce(math.gcd, nonzero)
    return [
        [[value // divisor for value in output] for output in row]
        for row in tensor
    ], divisor


# The primitive highest-weight projection
# Lambda^3 Sym^6 -> Sym^12 in lexicographic Plucker order.
PROJECTION_COEFFICIENTS = [
    1,
    3,
    6,
    10,
    15,
    3,
    8,
    15,
    24,
    6,
    15,
    27,
    10,
    24,
    15,
    1,
    3,
    6,
    10,
    3,
    8,
    15,
    6,
    15,
    10,
    1,
    3,
    6,
    3,
    8,
    6,
    1,
    3,
    3,
    1,
]


def verify_projection_equivariance():
    def wedge_action(triple, position, direction):
        entries = list(triple)
        coefficient = (
            6 - entries[position] if direction == 1 else entries[position]
        )
        entries[position] += direction
        if (
            entries[position] < 0
            or entries[position] > 6
            or len(set(entries)) < 3
        ):
            return None, 0
        inversions = sum(
            entries[left] > entries[right]
            for left in range(3)
            for right in range(left + 1, 3)
        )
        return tuple(sorted(entries)), coefficient * (-1) ** inversions

    triple_index = {triple: index for index, triple in enumerate(TRIPLES)}
    for triple in TRIPLES:
        output_index = sum(triple) - 3
        coefficient = PROJECTION_COEFFICIENTS[triple_index[triple]]
        for direction in (1, -1):
            left = 0
            for position in range(3):
                moved, scale = wedge_action(triple, position, direction)
                if moved is not None:
                    left += (
                        scale
                        * PROJECTION_COEFFICIENTS[triple_index[moved]]
                    )
            right = (
                (12 - output_index) * coefficient
                if direction == 1
                else output_index * coefficient
            )
            if not 0 <= output_index + direction <= 12:
                right = 0
            assert left == right


EPSILON_TERMS = {
    (0, 3, 6): -30,
    (0, 4, 5): 20,
    (1, 2, 6): 20,
    (1, 3, 5): -5,
    (2, 3, 4): 2,
}


def epsilon_form():
    return [EPSILON_TERMS.get(triple, 0) for triple in TRIPLES]


def lifted_invariant():
    bridge = json.loads(BRIDGE_CERTIFICATE.read_text(encoding="utf-8"))
    answer = [0] * 13
    for term in bridge["normalized_invariant_dodecic_mod_1331"]:
        answer[term["y"]] = term["coefficient"]
    return answer


def divided_covariant(order, invariant):
    tensor, divisor = primitive_transvectant_tensor(12, 12, order)
    output_dimension = 25 - 2 * order
    rows = [[0] * len(TRIPLES) for _ in range(output_dimension)]
    numerators = [[0] * len(TRIPLES) for _ in range(output_dimension)]
    for column, triple in enumerate(TRIPLES):
        source_index = sum(triple) - 3
        projection_scale = PROJECTION_COEFFICIENTS[column]
        for output_index in range(output_dimension):
            numerator = projection_scale * sum(
                tensor[source_index][right_index][output_index]
                * invariant[right_index]
                for right_index in range(13)
            )
            assert numerator % PRIME == 0
            numerators[output_index][column] = numerator
            rows[output_index][column] = (
                numerator // PRIME
            ) % MODULUS
    assert any(
        value % MODULUS
        for row in numerators
        for value in row
    )
    return rows, divisor


def fifth_forms():
    tensor, divisor = primitive_transvectant_tensor(6, 6, 5)
    forms = [
        [
            [
                tensor[left][right][output] % MODULUS
                for right in range(7)
            ]
            for left in range(7)
        ]
        for output in range(3)
    ]
    old = U22.fifth_forms()
    old_flat = [
        old[output][left][right] % PRIME
        for output in range(3)
        for left in range(7)
        for right in range(7)
    ]
    new_flat = [
        forms[output][left][right] % PRIME
        for output in range(3)
        for left in range(7)
        for right in range(7)
    ]
    first = next(index for index, value in enumerate(old_flat) if value)
    scale = new_flat[first] * pow(old_flat[first], -1, PRIME) % PRIME
    assert all(
        new == scale * prior % PRIME
        for new, prior in zip(new_flat, old_flat)
    )
    return forms, divisor, scale


def determinant3(matrix, modulus):
    return (
        matrix[0][0]
        * (
            matrix[1][1] * matrix[2][2]
            - matrix[1][2] * matrix[2][1]
        )
        - matrix[0][1]
        * (
            matrix[1][0] * matrix[2][2]
            - matrix[1][2] * matrix[2][0]
        )
        + matrix[0][2]
        * (
            matrix[1][0] * matrix[2][1]
            - matrix[1][1] * matrix[2][0]
        )
    ) % modulus


def plucker(plane, modulus):
    return [
        determinant3(
            [[plane[row][column] for column in triple] for row in range(3)],
            modulus,
        )
        for triple in TRIPLES
    ]


def chart_from_plane(plane):
    matrix = [[value % PRIME for value in row] for row in plane]
    row = 0
    pivots = []
    for column in range(7):
        pivot = next(
            (
                index
                for index in range(row, 3)
                if matrix[index][column]
            ),
            None,
        )
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inverse = pow(matrix[row][column], -1, PRIME)
        matrix[row] = [value * inverse % PRIME for value in matrix[row]]
        for other in range(3):
            if other == row or not matrix[other][column]:
                continue
            scale = matrix[other][column]
            matrix[other] = [
                (left - scale * right) % PRIME
                for left, right in zip(matrix[other], matrix[row])
            ]
        pivots.append(column)
        row += 1
        if row == 3:
            break
    assert len(pivots) == 3
    nonpivots = [column for column in range(7) if column not in pivots]
    variables = [
        matrix[row][column]
        for row in range(3)
        for column in nonpivots
    ]
    return pivots, nonpivots, variables


def plane_from_chart(pivots, nonpivots, variables, modulus):
    plane = [[0] * 7 for _ in range(3)]
    for row, column in enumerate(pivots):
        plane[row][column] = 1
    cursor = 0
    for row in range(3):
        for column in nonpivots:
            plane[row][column] = variables[cursor] % modulus
            cursor += 1
    return plane


def section_equations(plane, forms, quotient_rows, modulus):
    equations = []
    for left, right in ((0, 1), (0, 2), (1, 2)):
        for form in forms:
            equations.append(
                sum(
                    plane[left][first]
                    * form[first][second]
                    * plane[right][second]
                    for first in range(7)
                    for second in range(7)
                )
                % modulus
            )
    point = plucker(plane, modulus)
    equations.extend(
        sum(
            quotient_rows[row][column] * point[column]
            for column in range(len(TRIPLES))
        )
        % modulus
        for row in range(3)
    )
    assert len(equations) == 12
    return equations


def hensel_lift_plane(plane, forms, quotient_rows):
    pivots, nonpivots, variables = chart_from_plane(plane)
    base_plane = plane_from_chart(
        pivots, nonpivots, variables, MODULUS
    )
    base = section_equations(
        base_plane, forms, quotient_rows, MODULUS
    )
    assert all(value % PRIME == 0 for value in base)
    jacobian = []
    for equation in range(12):
        jacobian.append([])
        for variable in range(12):
            perturbed = variables[:]
            perturbed[variable] += PRIME
            values = section_equations(
                plane_from_chart(
                    pivots, nonpivots, perturbed, MODULUS
                ),
                forms,
                quotient_rows,
                MODULUS,
            )
            jacobian[equation].append(
                ((values[equation] - base[equation]) % MODULUS)
                // PRIME
            )
    assert rank_mod_prime(jacobian) == 12
    correction = solve_square_mod_prime(
        jacobian,
        [(-value // PRIME) % PRIME for value in base],
    )
    lifted_variables = [
        (value + PRIME * digit) % MODULUS
        for value, digit in zip(variables, correction)
    ]
    lifted = plane_from_chart(
        pivots, nonpivots, lifted_variables, MODULUS
    )
    assert section_equations(
        lifted, forms, quotient_rows, MODULUS
    ) == [0] * 12
    return lifted, pivots


def evaluate(form, point, modulus):
    return sum(
        left * right for left, right in zip(form, point)
    ) % modulus


def normalize_point(point, modulus):
    pivot = next(value for value in point if value % PRIME)
    inverse = pow(pivot, -1, modulus)
    return tuple(value * inverse % modulus for value in point)


def source_planes_mod_11():
    operator_basis = RANK.operator_basis()
    parameters = [
        (parameter, sheet)
        for sheet in (1, PRIME - 1)
        for parameter in range(PRIME)
    ]
    source_points = [
        RANK.parameter_point(parameter, sheet)
        for parameter, sheet in parameters
    ]
    planes = [
        MM.nullspace(RANK.operator_at(point, operator_basis), PRIME)
        for point in source_points
    ]
    return parameters, planes


def match_index(planes, target):
    normalized_target = normalize_point(plucker(target, PRIME), PRIME)
    matches = [
        index
        for index, plane in enumerate(planes)
        if normalize_point(plucker(plane, PRIME), PRIME)
        == normalized_target
    ]
    assert len(matches) == 1
    return matches[0]


def span_relation_mod_11(base_rows, target):
    columns = len(base_rows)
    augmented = [
        [base_rows[column][row] % PRIME for column in range(columns)]
        + [target[row] % PRIME]
        for row in range(len(target))
    ]
    pivot_row = 0
    pivots = []
    for column in range(columns):
        pivot = next(
            (
                index
                for index in range(pivot_row, len(augmented))
                if augmented[index][column]
            ),
            None,
        )
        if pivot is None:
            continue
        augmented[pivot_row], augmented[pivot] = (
            augmented[pivot],
            augmented[pivot_row],
        )
        inverse = pow(augmented[pivot_row][column], -1, PRIME)
        augmented[pivot_row] = [
            value * inverse % PRIME
            for value in augmented[pivot_row]
        ]
        for other in range(len(augmented)):
            if (
                other == pivot_row
                or not augmented[other][column]
            ):
                continue
            scale = augmented[other][column]
            augmented[other] = [
                (left - scale * right) % PRIME
                for left, right in zip(
                    augmented[other], augmented[pivot_row]
                )
            ]
        pivots.append(column)
        pivot_row += 1
    assert all(
        not row[-1] for row in augmented[pivot_row:]
    )
    solution = [0] * columns
    for row, column in enumerate(pivots):
        solution[column] = augmented[row][-1]
    return solution


def build_certificate():
    verify_projection_equivariance()
    invariant = lifted_invariant()
    quotient_rows, order_11_divisor = divided_covariant(11, invariant)
    eta_rows, order_12_divisor = divided_covariant(12, invariant)
    assert len(eta_rows) == 1
    eta = eta_rows[0]
    epsilon = epsilon_form()
    forms, order_5_divisor, fifth_scale = fifth_forms()

    old_contractions = U22.contraction_equations(U22.fifth_forms())
    old_section_forms = []
    for terms in (
        [((0, 1, 2), 1)],
        [((0, 1, 3), 1), ((3, 5, 6), 1)],
        [((4, 5, 6), 1)],
    ):
        old_section_forms.append(
            [
                next(
                    (
                        coefficient
                        for triple, coefficient in terms
                        if triple == current
                    ),
                    0,
                )
                for current in TRIPLES
            ]
        )
    assert rank_mod_prime(old_contractions) == 21
    assert rank_mod_prime(old_contractions + quotient_rows) == 24
    assert rank_mod_prime(old_contractions + old_section_forms) == 24
    assert (
        rank_mod_prime(
            old_contractions + quotient_rows + old_section_forms
        )
        == 24
    )

    old_invariants = []
    for terms in (
        [((0, 3, 6), 5), ((0, 4, 5), 8)],
        [((0, 1, 3), 10), ((3, 5, 6), 1)],
    ):
        old_invariants.append(
            [
                next(
                    (
                        coefficient
                        for triple, coefficient in terms
                        if triple == current
                    ),
                    0,
                )
                for current in TRIPLES
            ]
        )
    invariant_basis = old_contractions + old_invariants
    epsilon_relation = span_relation_mod_11(invariant_basis, epsilon)
    eta_relation = span_relation_mod_11(invariant_basis, eta)
    assert epsilon_relation[-2:] == [7, 0]
    assert eta_relation[-2:] == [0, 8]

    parameters, planes = source_planes_mod_11()
    lifted_rows = [
        hensel_lift_plane(plane, forms, quotient_rows)
        for plane in planes
    ]
    lifted_planes = [row[0] for row in lifted_rows]
    assert len(
        {
            normalize_point(plucker(plane, MODULUS), MODULUS)
            for plane in lifted_planes
        }
    ) == 22

    pencil_values = []
    for parameter, plane in zip(parameters, lifted_planes):
        point = plucker(plane, MODULUS)
        epsilon_value = evaluate(epsilon, point, MODULUS)
        eta_value = evaluate(eta, point, MODULUS)
        u_value = 8 * epsilon_value % MODULUS
        v_value = 7 * eta_value % MODULUS
        assert math.gcd(v_value, PRIME) == 1
        ratio = u_value * pow(v_value, -1, MODULUS) % MODULUS
        assert ratio % PRIME == parameter[1]
        pencil_values.append(
            {
                "source_t_mod_11": parameter[0],
                "source_sheet_mod_11": parameter[1],
                "epsilon": epsilon_value,
                "eta": eta_value,
                "u_tilde": u_value,
                "v_tilde": v_value,
                "raw_ratio": ratio,
            }
        )

    deformation = json.loads(
        DEFORMATION_CERTIFICATE.read_text(encoding="utf-8")
    )
    bridge = json.loads(BRIDGE_CERTIFICATE.read_text(encoding="utf-8"))
    selected_kernel = [
        [value % PRIME for value in row]
        for row in bridge["operator_kernel_mod_121"]
    ]
    conjugate_kernel = deformation["kernel_map"]["conjugate_kernel"]
    selected_index = match_index(planes, selected_kernel)
    conjugate_index = match_index(planes, conjugate_kernel)
    selected_ratio = pencil_values[selected_index]["raw_ratio"]
    conjugate_ratio = pencil_values[conjugate_index]["raw_ratio"]
    sqrt5 = (
        bridge["golden_character_field"]["selected_sqrt5_mod_1331"]
        % MODULUS
    )
    denominator = (selected_ratio - conjugate_ratio) % MODULUS
    assert math.gcd(denominator, PRIME) == 1
    slope = 2 * sqrt5 * pow(denominator, -1, MODULUS) % MODULUS
    intercept = (
        -slope * (selected_ratio + conjugate_ratio)
        * pow(2, -1, MODULUS)
    ) % MODULUS
    assert (
        slope * selected_ratio + intercept
    ) % MODULUS == sqrt5
    assert (
        slope * conjugate_ratio + intercept
    ) % MODULUS == (-sqrt5) % MODULUS
    assert slope % PRIME == sqrt5 % PRIME
    assert intercept % PRIME == 0

    ratio_histogram = {}
    for row in pencil_values:
        key = str(row["raw_ratio"])
        ratio_histogram[key] = ratio_histogram.get(key, 0) + 1

    inputs = {}
    for path in (
        U22_SCRIPT,
        U22_CERTIFICATE,
        BRIDGE_CERTIFICATE,
        DEFORMATION_CERTIFICATE,
        RANK_CERTIFICATE,
    ):
        inputs[str(path.relative_to(NOTES.parent))] = {
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        }

    return {
        "schema": "c682-u22-bockstein-pencil-v1",
        "base": {
            "prime": PRIME,
            "section_modulus": MODULUS,
            "invariant_modulus_before_division": LIFT_MODULUS,
            "interpretation": (
                "the first two levels of the compatible Z_11 tower"
            ),
        },
        "inputs": inputs,
        "primitive_clebsch_gordan_maps": {
            "projection": "Lambda^3 Sym^6 -> Sym^12",
            "projection_coefficients_lexicographic_plucker_order": (
                PROJECTION_COEFFICIENTS
            ),
            "projection_is_sl2_equivariant_over_Z": True,
            "order_5_raw_derivative_gcd": order_5_divisor,
            "order_11_raw_derivative_gcd": order_11_divisor,
            "order_12_raw_derivative_gcd": order_12_divisor,
        },
        "global_section": {
            "definition": (
                "Lambda_I=P(ker(c_omega) intersect "
                "ker((pi_12(-),I)_11/11))"
            ),
            "divided_order_11_map_shape": [3, 35],
            "divided_order_11_rank_mod_11": rank_mod_prime(
                quotient_rows
            ),
            "reduction_plus_contraction_rank": rank_mod_prime(
                old_contractions + quotient_rows
            ),
            "old_sparse_section_plus_contraction_rank": rank_mod_prime(
                old_contractions + old_section_forms
            ),
            "combined_rank": rank_mod_prime(
                old_contractions + quotient_rows + old_section_forms
            ),
            "reduction_is_the_previous_P10_section": True,
            "fifth_transvectant_scale_against_prior_mod_11": fifth_scale,
        },
        "global_invariant_pencil": {
            "epsilon": {
                "definition": (
                    "primitive SL2-invariant alternating trilinear "
                    "form on Sym^6"
                ),
                "terms": [
                    {"plucker": list(triple), "coefficient": coefficient}
                    for triple, coefficient in EPSILON_TERMS.items()
                ],
                "reduction_mod_contraction": "epsilon=7*u",
            },
            "eta": {
                "definition": "(pi_12(-),I)_12/11",
                "reduction_mod_contraction": "eta=8*v",
            },
            "lifted_normalization": {
                "u_tilde": "8*epsilon",
                "v_tilde": "7*eta",
                "reduction": "(u_tilde,v_tilde)=(u,v) mod 11",
                "raw_ratio": "r=u_tilde/v_tilde",
            },
            "all_22_denominators_are_units": True,
            "ratio_histogram_mod_121": ratio_histogram,
            "multiplication_characteristic_polynomial_mod_121": (
                "(T-100)^1*(T-43)^5*(T-45)^10*(T-54)^6"
            ),
            "special_fibre_characteristic_polynomial": (
                "(T-1)^11*(T+1)^11=(T^2-1)^11"
            ),
            "point_values": pencil_values,
        },
        "hensel_section": {
            "point_count": len(lifted_planes),
            "all_chart_jacobian_ranks_mod_11": 12,
            "all_points_lift_uniquely_mod_121": True,
            "all_lifts_are_distinct": True,
            "conclusion": (
                "the transverse reduced special section lifts to a "
                "finite-etale degree-22 section over Z_11"
            ),
        },
        "golden_incidence_comparison": {
            "selected_point_index": selected_index,
            "conjugate_point_index": conjugate_index,
            "selected_special_orbit_size": 1,
            "conjugate_special_orbit_size": 5,
            "selected_raw_ratio_mod_121": selected_ratio,
            "conjugate_raw_ratio_mod_121": conjugate_ratio,
            "selected_sqrt5_mod_121": sqrt5,
            "orientation_coordinate": (
                "w=slope*r+intercept on the two-point incidence fibre"
            ),
            "slope_mod_121": slope,
            "intercept_mod_121": intercept,
            "special_fibre_formula": "w=4*(u/v) mod 11",
            "exact_centered_formula": (
                "w=sqrt5*(2*r-r_plus-r_minus)/(r_plus-r_minus)"
            ),
            "golden_midpoint_mod_121": (
                (selected_ratio + conjugate_ratio)
                * pow(2, -1, MODULUS)
                % MODULUS
            ),
            "golden_half_difference_mod_121": (
                (selected_ratio - conjugate_ratio)
                * pow(2, -1, MODULUS)
                % MODULUS
            ),
            "raw_ratio_is_not_odd_mod_121": (
                (selected_ratio + conjugate_ratio) % MODULUS != 0
            ),
            "conclusion": (
                "u/v separates the incidence sheets, but its exact "
                "orientation normalization is the centered affine "
                "coordinate, not an uncorrected scalar multiple"
            ),
        },
        "trust_boundary": {
            "certifies": [
                "the primitive integral projection and divided contractions",
                "recovery of the prior F_11 section and invariant pencil",
                "unique Hensel lifts of all 22 transverse points mod 11^2",
                "the raw pencil values on the two golden incidence lifts",
                "the exact affine comparison with the orientation coordinate",
            ],
            "uses_classically": [
                "the U_22 fifth-transvectant Grassmannian model",
                "the degree-two local incidence theorem at the golden point",
                "Hensel's lemma and finite-etale lifting over Z_11",
            ],
            "does_not_claim": [
                "global good reduction of Hitchin's comparison",
                "a characteristic-zero equality of uncentered u/v and w",
                "manuscript novelty or promotion",
            ],
        },
    }


def canonical_bytes(certificate):
    return (
        json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    ).encode("utf-8")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / OUTPUT.name
            path.write_bytes(payload)
            assert path.read_bytes() == OUTPUT.read_bytes()
        print("c682 u22 bockstein pencil: PASS")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
