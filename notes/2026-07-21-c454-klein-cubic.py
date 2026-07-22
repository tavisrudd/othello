#!/usr/bin/env python3
"""Exact character and modular-module certificate for C454/T7."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


SCHEMA = "c454-klein-cubic-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C406_SCRIPT = HERE / "2026-07-20-c406-matching-module.py"
C406_SCOUT = HERE / "2026-07-20-c406-matching-orbit-scout.json"
C406_CERT = HERE / "2026-07-20-c406-matching-module.json"
C412_CERT = HERE / "2026-07-20-c412-relative-cubic-depth-plane.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c454_c406", C406_SCRIPT)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def conjugacy_classes(group):
    inverses = {element: C406.inverse(element) for element in group}
    unseen = set(group)
    result = []
    while unseen:
        representative = min(unseen)
        members = {
            C406.compose(C406.compose(element, representative), inverses[element])
            for element in group
        }
        result.append((representative, members))
        unseen -= members
    return sorted(result, key=lambda item: (C406.permutation_order(item[0]), min(item[1])))


def permutation_power(permutation, exponent):
    result = tuple(range(len(permutation)))
    for _ in range(exponent):
        result = C406.compose(permutation, result)
    return result


def prime_factors(number):
    result = []
    divisor = 2
    while divisor * divisor <= number:
        if number % divisor == 0:
            result.append(divisor)
            while number % divisor == 0:
                number //= divisor
        divisor += 1
    if number > 1:
        result.append(number)
    return result


def extension_multiply(left, right, prime, nonsquare):
    return (
        (left[0] * right[0] + nonsquare * left[1] * right[1]) % prime,
        (left[0] * right[1] + left[1] * right[0]) % prime,
    )


def extension_power(value, exponent, prime, nonsquare):
    result = (1, 0)
    while exponent:
        if exponent & 1:
            result = extension_multiply(result, value, prime, nonsquare)
        value = extension_multiply(value, value, prime, nonsquare)
        exponent //= 2
    return result


def extension_inverse(value, prime, nonsquare):
    norm_inverse = pow(
        (value[0] * value[0] - nonsquare * value[1] * value[1]) % prime,
        -1,
        prime,
    )
    return value[0] * norm_inverse % prime, -value[1] * norm_inverse % prime


def primitive_extension_element(prime, nonsquare):
    order = prime * prime - 1
    for real in range(prime):
        for imag in range(prime):
            candidate = (real, imag)
            if candidate != (0, 0) and all(
                extension_power(candidate, order // divisor, prime, nonsquare) != (1, 0)
                for divisor in prime_factors(order)
            ):
                return candidate
    raise AssertionError("no primitive extension-field element")


def extension_rank(matrix, prime, nonsquare):
    work = [[(entry, 0) if isinstance(entry, int) else entry for entry in row] for row in matrix]
    row_count = len(work)
    column_count = len(work[0]) if work else 0
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column] != (0, 0)),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        scale = extension_inverse(work[pivot_row][column], prime, nonsquare)
        work[pivot_row] = [
            extension_multiply(entry, scale, prime, nonsquare)
            for entry in work[pivot_row]
        ]
        for row in range(row_count):
            if row == pivot_row or work[row][column] == (0, 0):
                continue
            scale = work[row][column]
            multiple = [
                extension_multiply(scale, entry, prime, nonsquare)
                for entry in work[pivot_row]
            ]
            work[row] = [
                ((left[0] - right[0]) % prime, (left[1] - right[1]) % prime)
                for left, right in zip(work[row], multiple)
            ]
        pivot_row += 1
    return pivot_row


def cyclotomic_polynomial(order):
    polynomials = {1: [-1, 1]}

    def divide(dividend, divisor):
        quotient = [0] * (len(dividend) - len(divisor) + 1)
        remainder = list(dividend)
        while len(remainder) >= len(divisor):
            coefficient = remainder[-1] // divisor[-1]
            shift = len(remainder) - len(divisor)
            quotient[shift] = coefficient
            for index, value in enumerate(divisor):
                remainder[index + shift] -= coefficient * value
            while remainder and remainder[-1] == 0:
                remainder.pop()
        assert not remainder
        return quotient

    for number in range(2, order + 1):
        if order % number:
            continue
        polynomial = [-1] + [0] * (number - 1) + [1]
        for divisor in sorted(value for value in polynomials if number % value == 0):
            polynomial = divide(polynomial, polynomials[divisor])
        polynomials[number] = polynomial
    return polynomials[order]


def reduce_cyclotomic(coefficients, cyclotomic):
    work = [Fraction(value) for value in coefficients]
    while len(work) > 1 and work[-1] == 0:
        work.pop()
    degree = len(cyclotomic) - 1
    while len(work) - 1 >= degree:
        coefficient = work[-1]
        shift = len(work) - 1 - degree
        for index, value in enumerate(cyclotomic):
            work[index + shift] -= coefficient * value
        while len(work) > 1 and work[-1] == 0:
            work.pop()
    return work + [Fraction(0)] * (degree - len(work))


def cyclic_product(left, right, order):
    result = [0] * order
    for left_index, left_value in enumerate(left):
        if not left_value:
            continue
        for right_index, right_value in enumerate(right):
            if right_value:
                result[(left_index + right_index) % order] += left_value * right_value
    return result


def scalar_character(value, order):
    result = [0] * order
    result[0] = value
    return result


def add_scaled(target, source, scale):
    for index, value in enumerate(source):
        target[index] += scale * value


def symmetric_cube_map(matrix, prime):
    """Symmetric-cube map for a rectangular output-by-input matrix."""
    output_dimension = len(matrix)
    input_dimension = len(matrix[0])
    output_basis = list(C406.itertools.combinations_with_replacement(range(output_dimension), 3))
    input_basis = list(C406.itertools.combinations_with_replacement(range(input_dimension), 3))
    input_index = {indices: index for index, indices in enumerate(input_basis)}
    action = [[0] * len(input_basis) for _ in output_basis]
    for row, (i, j, k) in enumerate(output_basis):
        for left in range(input_dimension):
            for middle in range(input_dimension):
                for right in range(input_dimension):
                    column = input_index[tuple(sorted((left, middle, right)))]
                    action[row][column] = (
                        action[row][column]
                        + matrix[i][left] * matrix[j][middle] * matrix[k][right]
                    ) % prime
    return action


def build_type(name, scout_record):
    prime = scout_record["field_order"]
    conic, parameters = C406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in scout_record["coxeter_invariant_matching"])
    orbit = sorted({C406.matching_image(element, base_matching) for element in full_group})
    orbit_index = {matching: index for index, matching in enumerate(orbit)}

    base_product = C406.matching_product(base_matching, endpoints, prime)
    quotient_vectors = []
    for matching in orbit:
        product = C406.matching_product(matching, endpoints, prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(
            C406.quotient_by_conic(difference, (prime + 1) // 2 - 2, prime)
        )
    image_matrix = C406.transpose(quotient_vectors)
    _reduced, coordinate_pivots = C406.rref(C406.transpose(image_matrix), prime)
    reduced_vectors = [
        [vector[index] for index in coordinate_pivots] for vector in quotient_vectors
    ]
    image_dimension = len(coordinate_pivots)
    assert image_dimension == prime - 1
    _point_reduced, point_basis_indices = C406.rref(C406.transpose(reduced_vectors), prime)
    point_basis_inverse = C406.matrix_inverse(
        C406.transpose([reduced_vectors[index] for index in point_basis_indices]), prime
    )
    base_index = orbit_index[base_matching]

    def induced_action(element):
        action = C406.action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = C406.transpose(
            [
                [
                    (reduced_vectors[action[index]][coordinate] - reduced_vectors[moved_base][coordinate])
                    % prime
                    for coordinate in range(image_dimension)
                ]
                for index in point_basis_indices
            ]
        )
        return C406.matrix_product(target_basis, point_basis_inverse, prime)

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {C406.matching_image(element, representative) for element in psl_group}
        sheets.append(sheet)
        unseen -= sheet
    assert sorted(map(len, sheets)) == [prime, prime]
    ordinary_sheet = sheets[0]

    psl_generators = C406.permutation_generators(psl_group)
    outer_element = min(full_group - psl_group)
    generator_actions = [induced_action(element) for element in psl_generators]
    invariant_equations = []
    dual_invariant_equations = []
    for action in generator_actions:
        invariant_equations.extend(
            [
                [
                    (action[row][column] - (1 if row == column else 0)) % prime
                    for column in range(image_dimension)
                ]
                for row in range(image_dimension)
            ]
        )
        dual_invariant_equations.extend(
            [
                [
                    (action[column][row] - (1 if row == column else 0)) % prime
                    for column in range(image_dimension)
                ]
                for row in range(image_dimension)
            ]
        )
    invariant_basis = C406.nullspace(invariant_equations, prime)
    dual_invariant_basis = C406.nullspace(dual_invariant_equations, prime)

    cube_actions = [C406.symmetric_cube_action(action, prime) for action in generator_actions]
    cube_actions.append(C406.symmetric_cube_action(induced_action(outer_element), prime))
    cube_dimension = len(cube_actions[0])
    relative_equations = []
    for action_index, action in enumerate(cube_actions):
        eigenvalue = 1 if action_index < len(psl_generators) else prime - 1
        relative_equations.extend(
            [
                [
                    (action[row][column] - (eigenvalue if row == column else 0)) % prime
                    for column in range(cube_dimension)
                ]
                for row in range(cube_dimension)
            ]
        )
    relative_basis = C406.nullspace(relative_equations, prime)
    assert len(relative_basis) == 3

    assert len(invariant_basis) == len(dual_invariant_basis) == 1
    complement_basis = C406.nullspace([dual_invariant_basis[0]], prime)
    split_basis = [invariant_basis[0]] + complement_basis
    split_matrix = C406.transpose(split_basis)
    split_inverse = C406.matrix_inverse(split_matrix, prime)
    split_actions = [
        C406.matrix_product(
            split_inverse,
            C406.matrix_product(induced_action(element), split_matrix, prime),
            prime,
        )
        for element in psl_generators + [outer_element]
    ]
    cube_monomials = list(C406.itertools.combinations_with_replacement(range(image_dimension), 3))
    split_relative_dimensions = {}
    split_component_lines = {}
    split_labels = {
        3: "t^3",
        2: "t^2_tensor_L",
        1: "t_tensor_Sym2_L",
        0: "Sym3_L",
    }
    for trivial_degree in range(4):
        indices = [
            index for index, monomial in enumerate(cube_monomials)
            if monomial.count(0) == trivial_degree
        ]
        equations = []
        for action_index, action in enumerate(split_actions):
            cube_action = C406.symmetric_cube_action(action, prime)
            eigenvalue = 1 if action_index < len(psl_generators) else prime - 1
            equations.extend(
                [
                    [
                        (cube_action[row][column] - (eigenvalue if row == column else 0)) % prime
                        for column in indices
                    ]
                    for row in indices
                ]
            )
        split_relative_dimensions[split_labels[trivial_degree]] = len(
            C406.nullspace(equations, prime)
        )
    assert sum(split_relative_dimensions.values()) == 3
    split_cube_transform = C406.symmetric_cube_action(split_inverse, prime)
    transformed_relative_basis = [
        C406.matrix_vector(split_cube_transform, vector, prime) for vector in relative_basis
    ]
    for trivial_degree in range(4):
        label = split_labels[trivial_degree]
        if split_relative_dimensions[label] == 0:
            split_component_lines[label] = None
            continue
        allowed = {
            index for index, monomial in enumerate(cube_monomials)
            if monomial.count(0) == trivial_degree
        }
        outside_equations = [
            [vector[index] for vector in transformed_relative_basis]
            for index in range(cube_dimension)
            if index not in allowed
        ]
        line_basis = C406.nullspace(outside_equations, prime)
        assert len(line_basis) == 1
        line = line_basis[0]
        first = next(value for value in line if value)
        split_component_lines[label] = [value * pow(first, -1, prime) % prime for value in line]

    parent_component = None
    if name == "H3":
        parent_group = C406.h3_group(prime, conic)
        projector = [[0] * image_dimension for _ in range(image_dimension)]
        character_by_order = {1: 5, 2: 1, 3: -1, 5: 0}
        for element in parent_group:
            coefficient = character_by_order[C406.permutation_order(element)]
            action = induced_action(element)
            for row in range(image_dimension):
                for column in range(image_dimension):
                    projector[row][column] += coefficient * action[row][column]
        scale = 5 * pow(len(parent_group), -1, prime) % prime
        projector = [[scale * value % prime for value in row] for row in projector]
        component_basis = []
        for column in C406.transpose(projector):
            if C406.column_rank(component_basis + [column], prime) > len(component_basis):
                component_basis.append(column)
        assert len(component_basis) == 5
        cube_map = symmetric_cube_map(C406.transpose(component_basis), prime)
        cube_columns = C406.transpose(cube_map)
        intersection_dimension = (
            C406.column_rank(cube_columns, prime)
            + len(relative_basis)
            - C406.column_rank(cube_columns + relative_basis, prime)
        )
        parent_component = {
            "restriction_of_W_to_A5": [1, 4, 5],
            "five_dimensional_projector_rank": len(component_basis),
            "five_dimensional_component_basis": component_basis,
            "symmetric_cube_dimension": C406.column_rank(cube_columns, prime),
            "intersection_with_relative_cubic_space_dimension": intersection_dimension,
        }

    psl_class_records = []
    irreducible_numerator = 0
    for representative, members in conjugacy_classes(psl_group):
        fixed_points = sum(
            C406.matching_image(representative, matching) == matching
            for matching in ordinary_sheet
        )
        character = fixed_points - 1
        irreducible_numerator += len(members) * character * character
        psl_class_records.append(
            {
                "element_order": C406.permutation_order(representative),
                "class_size": len(members),
                "fixed_points_on_sheet": fixed_points,
                "augmentation_character": character,
            }
        )
    assert irreducible_numerator == len(psl_group)

    nonsquare = next(
        value for value in range(2, prime) if pow(value, (prime - 1) // 2, prime) == prime - 1
    )
    extension_order = prime * prime - 1
    primitive = primitive_extension_element(prime, nonsquare)
    extension_elements = []
    value = (1, 0)
    for exponent in range(extension_order):
        extension_elements.append(value)
        value = extension_multiply(value, primitive, prime, nonsquare)
    assert value == (1, 0) and len(set(extension_elements)) == extension_order

    lift_cache = {}

    def ordinary_character(element):
        if element in psl_group:
            return scalar_character(
                sum(
                    C406.matching_image(element, matching) == matching
                    for matching in ordinary_sheet
                )
                - 1,
                extension_order,
            )
        if element in lift_cache:
            return lift_cache[element]
        matrix = induced_action(element)
        character = [0] * extension_order
        for exponent, eigenvalue in enumerate(extension_elements):
            shifted = [
                [
                    (
                        (matrix[row][column] - (eigenvalue[0] if row == column else 0)) % prime,
                        (-eigenvalue[1] if row == column else 0) % prime,
                    )
                    for column in range(image_dimension)
                ]
                for row in range(image_dimension)
            ]
            multiplicity = image_dimension - extension_rank(shifted, prime, nonsquare)
            if multiplicity:
                character[exponent] = multiplicity
        assert sum(character) == image_dimension
        lift_cache[element] = character
        return character

    molien_numerator = [0] * extension_order
    outer_character_records = []
    molien_class_records = []
    for representative, members in conjugacy_classes(full_group):
        character = ordinary_character(representative)
        square_character = ordinary_character(permutation_power(representative, 2))
        cube_character = ordinary_character(permutation_power(representative, 3))
        symmetric_cube = cyclic_product(cyclic_product(character, character, extension_order), character, extension_order)
        add_scaled(symmetric_cube, cyclic_product(character, square_character, extension_order), 3)
        add_scaled(symmetric_cube, cube_character, 2)
        sign = 1 if representative in psl_group else -1
        add_scaled(molien_numerator, symmetric_cube, sign * len(members))
        molien_class_records.append(
            {
                "element_order": C406.permutation_order(representative),
                "class_size": len(members),
                "outer_sign": sign,
                "character_exponents": [
                    [index, multiplicity]
                    for index, multiplicity in enumerate(character)
                    if multiplicity
                ],
                "square_character_exponents": [
                    [index, multiplicity]
                    for index, multiplicity in enumerate(square_character)
                    if multiplicity
                ],
                "cube_character_exponents": [
                    [index, multiplicity]
                    for index, multiplicity in enumerate(cube_character)
                    if multiplicity
                ],
            }
        )
        if representative not in psl_group:
            outer_character_records.append(
                {
                    "element_order": C406.permutation_order(representative),
                    "class_size": len(members),
                    "brauer_lift_exponents": [
                        [index, multiplicity]
                        for index, multiplicity in enumerate(character)
                        if multiplicity
                    ],
                }
            )
    cyclotomic = cyclotomic_polynomial(extension_order)
    reduced_molien = reduce_cyclotomic(molien_numerator, cyclotomic)
    denominator = 6 * len(full_group)
    assert reduced_molien[0] == 3 * denominator
    assert all(value == 0 for value in reduced_molien[1:])

    return {
        "type": name,
        "field": prime,
        "groups": {"psl_order": len(psl_group), "pgl_order": len(full_group)},
        "characteristic_zero": {
            "construction": f"augmentation of the {prime}-point PSL coset action",
            "dimension": image_dimension,
            "psl_character_classes": psl_class_records,
            "character_inner_product": 1,
            "irreducible": True,
            "outer_character_brauer_lifts": outer_character_records,
            "molien_class_records": molien_class_records,
            "outer_sign_multiplicity_in_symmetric_cube": 3,
            "molien_cyclotomic_order": extension_order,
            "molien_reduced_numerator": [str(value) for value in reduced_molien],
            "molien_denominator": denominator,
        },
        "defining_characteristic": {
            "dimension": image_dimension,
            "invariant_basis": invariant_basis,
            "dual_invariant_basis": dual_invariant_basis,
            "composition_factor_dimensions": [prime - 2, 1],
            "heart_highest_weight": prime - 3,
            "invariant_dual_pairing": [
                [sum(left * right for left, right in zip(vector, covector)) % prime
                 for covector in dual_invariant_basis]
                for vector in invariant_basis
            ],
            "split_direct_sum": True,
            "relative_cubic_dimensions_by_split_degree": split_relative_dimensions,
            "split_component_lines_in_relative_basis": split_component_lines,
        },
        "relative_cubics": {
            "ambient_dimension": cube_dimension,
            "dimension": len(relative_basis),
            "basis": relative_basis,
            "basis_sha256": hashlib.sha256(bytes(sum(relative_basis, []))).hexdigest(),
        },
        "parent_five_component": parent_component,
    }


def build_certificate():
    scout = json.loads(C406_SCOUT.read_text())
    types = {
        name: build_type(name, next(record for record in scout["types"] if record["type"] == name))
        for name in ("B3", "H3")
    }
    h3 = types["H3"]
    assert h3["defining_characteristic"]["composition_factor_dimensions"] == [9, 1]
    c412 = json.loads(C412_CERT.read_text())
    c412_lines = {
        "rank_one": c412["source"]["relative_cubic_rank_locus"]["minimal_rank_lines"][0],
        "rank_nine_tate_kernel": c412["source"]["relative_cubic_rank_locus"]["special_lines"]["twisted_coinvariant_kernel"],
        "signed_moment": c412["source"]["signed_moment_projective_line"],
    }
    split_lines = h3["defining_characteristic"]["split_component_lines_in_relative_basis"]
    split_line_matches = {
        split_label: next(
            (name for name, line in c412_lines.items() if line == split_line), None
        )
        for split_label, split_line in split_lines.items()
        if split_line is not None
    }
    split_line_order = ["t^3", "t_tensor_Sym2_L", "Sym3_L"]
    split_line_matrix = C406.transpose([split_lines[label] for label in split_line_order])
    split_line_inverse = C406.matrix_inverse(split_line_matrix, 11)
    c412_line_split_coordinates = {
        name: C406.matrix_vector(split_line_inverse, line, 11)
        for name, line in c412_lines.items()
    }
    return {
        "schema": SCHEMA,
        "inputs": {
            path.name: sha256(path)
            for path in (C406_SCRIPT, C406_SCOUT, C406_CERT, C412_CERT)
        },
        "types": types,
        "h3_klein_adler_verdict": {
            "ordinary_W": "irreducible degree-10 PSL2(11) character",
            "mod_11_W": "split direct sum of L(8) of dimension 9 and the trivial module",
            "ordinary_adler_modules": "the two degree-5 characters over Q(sqrt(-11))",
            "mod_11_adler_module": "L(4) of dimension 5",
            "ordinary_linear_hom_dimension": 0,
            "mod_11_linear_hom_dimension": 0,
            "adler_cubic_pullback_to_W": False,
            "reason": "W has no degree-5 constituent in characteristic zero or 11",
            "a5_local_boundary": "W restricted to the frozen A5 parent is 1+4+5, but its 5-space is not PSL2(11)-stable",
            "verdict": "SHARP_NEGATIVE_NO_FIVE_DIMENSIONAL_COMPONENT_OR_EQUIVARIANT_LINEAR_MAP",
        },
        "h3_split_line_comparison": {
            "c412_lines": c412_lines,
            "split_component_lines": split_lines,
            "exact_matches": split_line_matches,
            "split_coordinate_order": split_line_order,
            "c412_line_split_coordinates": c412_line_split_coordinates,
        },
        "verdict": "CHARACTER_EXPLAINS_THREE_RELATIVE_CUBICS_BUT_KLEIN_ADLER_IDENTIFICATION_FAILS",
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    else:
        if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
            raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
        print("C454 Klein-cubic certificate OK")


if __name__ == "__main__":
    main()
