#!/usr/bin/env python3
"""Exact Gate-2 restricted matching-module calculation for C406."""

from __future__ import annotations

import argparse
import functools
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


SCHEMA = "c406-matching-module-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
C399_PATH = HERE / "2026-07-20-c399-coxeter-number-conic-phase.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C399 = load_module("c406_gate2_c399", C399_PATH)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(permutation):
    result = [0] * len(permutation)
    for index, image in enumerate(permutation):
        result[image] = index
    return tuple(result)


def matching_image(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def normalize_matrix(entries, prime):
    pivot = next(value for value in entries if value % prime)
    scale = pow(pivot, -1, prime)
    return tuple(value * scale % prime for value in entries)


def full_pgl(prime, parameters):
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    actions = {}
    for entries in itertools.product(range(prime), repeat=4):
        a, b, c, d = entries
        if (a * d - b * c) % prime == 0:
            continue
        normalized = normalize_matrix(entries, prime)
        if normalized != entries:
            continue
        permutation = tuple(
            parameter_index[
                C399.normalize_pair((a * left + b * right, c * left + d * right), prime)
            ]
            for left, right in parameters
        )
        actions[permutation] = (a * d - b * c) % prime
    squares = {value * value % prime for value in range(1, prime)}
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    return set(actions), psl


def coxeter_group(name, prime, conic):
    point_index = {point: index for index, point in enumerate(conic)}
    matrices = [C399.reflection_matrix(root, prime) for root in C399.arrangements()[name]]
    generators = [
        tuple(
            point_index[C399.normalize_mod(C399.matrix_vector(matrix, point, prime), prime)]
            for point in conic
        )
        for matrix in matrices
    ]
    return C399.generated_permutation_group(generators)


def h3_group(prime, conic):
    replay_path = HERE / "2026-07-19-c379-clebsch-deep-hole-extension-replay.py"
    c379 = load_module("c406_gate2_c379", replay_path)
    point_index = {point: index for index, point in enumerate(conic)}
    return {
        tuple(point_index[C399.normalize_mod(c379.mv(matrix, point), prime)] for point in conic)
        for matrix in c379.a5(8)
    }


def homogeneous_basis(degree):
    return tuple(
        (x_degree, y_degree, degree - x_degree - y_degree)
        for x_degree in range(degree + 1)
        for y_degree in range(degree - x_degree + 1)
    )


def multiply_polynomials(left, right, prime):
    result = {}
    for left_exp, left_coefficient in left.items():
        for right_exp, right_coefficient in right.items():
            exponent = tuple(left_exp[index] + right_exp[index] for index in range(3))
            result[exponent] = (
                result.get(exponent, 0) + left_coefficient * right_coefficient
            ) % prime
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def matching_product(matching, endpoints, prime):
    result = {(0, 0, 0): 1}
    for left, right in matching:
        s_i, t_i = endpoints[left]
        s_j, t_j = endpoints[right]
        line = {
            (1, 0, 0): t_i * t_j % prime,
            (0, 1, 0): -(s_i * t_j + t_i * s_j) % prime,
            (0, 0, 1): s_i * s_j % prime,
        }
        result = multiply_polynomials(result, line, prime)
    return result


def rref(matrix, prime):
    data = [[value % prime for value in row] for row in matrix]
    rows = len(data)
    columns = len(data[0]) if rows else 0
    pivots = []
    pivot_row = 0
    for column in range(columns):
        candidate = next((row for row in range(pivot_row, rows) if data[row][column]), None)
        if candidate is None:
            continue
        data[pivot_row], data[candidate] = data[candidate], data[pivot_row]
        scale = pow(data[pivot_row][column], -1, prime)
        data[pivot_row] = [value * scale % prime for value in data[pivot_row]]
        for row in range(rows):
            if row == pivot_row or not data[row][column]:
                continue
            factor = data[row][column]
            data[row] = [
                (data[row][index] - factor * data[pivot_row][index]) % prime
                for index in range(columns)
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return data, pivots


def rank(matrix, prime):
    if not matrix:
        return 0
    return len(rref(matrix, prime)[1])


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    columns = len(matrix[0]) if matrix else 0
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % prime
        basis.append(vector)
    return basis


def quotient_by_conic(difference, quotient_degree, prime):
    source_basis = homogeneous_basis(quotient_degree)
    target_basis = homogeneous_basis(quotient_degree + 2)
    target_index = {exponent: index for index, exponent in enumerate(target_basis)}
    matrix = [[0] * len(source_basis) for _ in target_basis]
    conic = {(1, 0, 1): 1, (0, 2, 0): -1 % prime}
    for column, monomial in enumerate(source_basis):
        product = multiply_polynomials({monomial: 1}, conic, prime)
        for exponent, coefficient in product.items():
            matrix[target_index[exponent]][column] = coefficient
    rhs = [difference.get(exponent, 0) for exponent in target_basis]
    augmented = [row + [rhs[index]] for index, row in enumerate(matrix)]
    reduced, pivots = rref(augmented, prime)
    assert len([pivot for pivot in pivots if pivot < len(source_basis)]) == len(source_basis)
    assert len(source_basis) not in pivots
    solution = [0] * len(source_basis)
    for row, pivot in enumerate(pivots):
        if pivot < len(source_basis):
            solution[pivot] = reduced[row][-1]
    return solution


def laplacian_matrix(degree, prime):
    """Matrix of 4*d_X*d_Z-d_Y^2 for Q=XZ-Y^2."""
    source = homogeneous_basis(degree)
    target = homogeneous_basis(degree - 2)
    target_index = {exponent: index for index, exponent in enumerate(target)}
    matrix = [[0] * len(source) for _ in target]
    for column, (x_degree, y_degree, z_degree) in enumerate(source):
        if x_degree and z_degree:
            exponent = (x_degree - 1, y_degree, z_degree - 1)
            matrix[target_index[exponent]][column] += 4 * x_degree * z_degree
        if y_degree >= 2:
            exponent = (x_degree, y_degree - 2, z_degree)
            matrix[target_index[exponent]][column] -= y_degree * (y_degree - 1)
    return [[value % prime for value in row] for row in matrix]


def radial_power_vector(degree, prime):
    assert degree % 2 == 0
    polynomial = {(0, 0, 0): 1}
    conic = {(1, 0, 1): 1, (0, 2, 0): -1 % prime}
    for _ in range(degree // 2):
        polynomial = multiply_polynomials(polynomial, conic, prime)
    return [polynomial.get(exponent, 0) for exponent in homogeneous_basis(degree)]


def column_rank(columns, prime):
    return rank(transpose(columns), prime)


def symmetric_power(vector, degree, prime):
    return [
        product % prime
        for indices in itertools.combinations_with_replacement(range(len(vector)), degree)
        for product in [
            functools.reduce(lambda left, index: left * vector[index], indices, 1)
        ]
    ]


def subset_feature_sums(features, prime):
    result = []
    for mask in range(1 << len(features)):
        total = [0] * len(features[0])
        count = 0
        for index, feature in enumerate(features):
            if mask & (1 << index):
                count += 1
                total = [(left + right) % prime for left, right in zip(total, feature)]
        result.append((count, tuple(total), mask))
    return result


def balanced_zero_moment_subsets(features, subset_size, prime):
    split = len(features) // 2
    left_features = features[:split]
    right_features = features[split:]
    total = [sum(feature[index] for feature in features) % prime for index in range(len(features[0]))]
    half_total = [value * pow(2, -1, prime) % prime for value in total]
    right_lookup = {}
    for count, feature_sum, mask in subset_feature_sums(right_features, prime):
        right_lookup.setdefault((count, feature_sum), []).append(mask)
    solutions = []
    for left_count, left_sum, left_mask in subset_feature_sums(left_features, prime):
        right_count = subset_size - left_count
        target = tuple((half_total[index] - left_sum[index]) % prime for index in range(len(half_total)))
        for right_mask in right_lookup.get((right_count, target), ()):
            indices = [index for index in range(split) if left_mask & (1 << index)]
            indices.extend(
                split + index for index in range(len(right_features)) if right_mask & (1 << index)
            )
            solutions.append(indices)
    return solutions


def conjugacy_classes(group):
    unseen = set(group)
    classes = []
    while unseen:
        representative = min(unseen)
        conjugates = {
            compose(compose(element, representative), inverse(element)) for element in group
        }
        unseen -= conjugates
        classes.append((representative, conjugates))
    return classes


def permutation_order(permutation):
    value = tuple(range(len(permutation)))
    for order in range(1, 61):
        value = compose(permutation, value)
        if value == tuple(range(len(permutation))):
            return order
    raise AssertionError("element order exceeded parent bound")


def labelled_classes(name, group):
    raw = conjugacy_classes(group)
    records = []
    order_five = []
    for representative, elements in raw:
        order = permutation_order(representative)
        centralizer = len(group) // len(elements)
        if name in ("A3", "B3"):
            label = {
                (1, 24): "1",
                (2, 4): "2",
                (2, 8): "22",
                (3, 3): "3",
                (4, 4): "4",
            }[(order, centralizer)]
            records.append((label, representative, elements))
        elif order == 5:
            order_five.append((representative, elements))
        else:
            label = {(1, 60): "1", (2, 4): "2", (3, 3): "3"}[(order, centralizer)]
            records.append((label, representative, elements))
    if name == "H3":
        order_five.sort(key=lambda item: min(item[1]))
        records.extend(
            (label, representative, elements)
            for label, (representative, elements) in zip(("5A", "5B"), order_five)
        )
    ordering = {label: index for index, label in enumerate(("1", "2", "22", "3", "4", "5A", "5B"))}
    return sorted(records, key=lambda item: ordering[item[0]])


def character_table(name, prime):
    if name in ("A3", "B3"):
        labels = ("1", "2", "22", "3", "4")
        return labels, {
            "1": (1, 1, 1, 1, 1),
            "sgn": (1, -1, 1, 1, -1),
            "2": (2, 0, 2, -1, 0),
            "3": (3, 1, -1, 0, -1),
            "3sgn": (3, -1, -1, 0, 1),
        }
    sqrt_five = min(value for value in range(prime) if value * value % prime == 5 % prime)
    phi = (1 + sqrt_five) * pow(2, -1, prime) % prime
    phi_bar = (1 - sqrt_five) * pow(2, -1, prime) % prime
    labels = ("1", "2", "3", "5A", "5B")
    return labels, {
        "1": (1, 1, 1, 1, 1),
        "3a": (3, -1, 0, phi, phi_bar),
        "3b": (3, -1, 0, phi_bar, phi),
        "4": (4, 0, 1, -1, -1),
        "5": (5, 1, -1, 0, 0),
    }


def action_permutation(element, orbit, orbit_index):
    return tuple(orbit_index[matching_image(element, matching)] for matching in orbit)


def central_idempotent(character, dimension, group_actions, prime):
    size = len(group_actions[0][1])
    matrix = [[0] * size for _ in range(size)]
    scale = dimension * pow(len(group_actions), -1, prime) % prime
    for class_label, action in group_actions:
        coefficient = scale * character[class_label] % prime
        for source, image in enumerate(action):
            matrix[image][source] = (matrix[image][source] + coefficient) % prime
    return matrix


def matrix_times_columns(matrix, columns, prime):
    return [
        [sum(matrix[row][index] * column[index] for index in range(len(matrix))) % prime for column in columns]
        for row in range(len(matrix))
    ]


def transpose(columns):
    return [list(row) for row in zip(*columns)] if columns else []


def constituent_multiplicities(subspace_columns, tables, group_actions, prime):
    result = {}
    for character_name, values in tables.items():
        dimension = values[0]
        value_by_class = dict(zip(group_actions[1], (value % prime for value in values)))
        idempotent = central_idempotent(
            value_by_class, dimension, group_actions[0], prime
        )
        projected = matrix_times_columns(idempotent, subspace_columns, prime)
        multiplicity, remainder = divmod(rank(projected, prime), dimension)
        assert remainder == 0
        result[character_name] = multiplicity
    return {name: value for name, value in result.items() if value}


def type_certificate(record):
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = full_pgl(prime, parameters)
    parent_group = h3_group(prime, conic) if name == "H3" else coxeter_group(name, prime, conic)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({matching_image(element, base_matching) for element in full_group})
    assert len(orbit) == record["target_orbit_size"]
    orbit_index = {matching: index for index, matching in enumerate(orbit)}

    base_product = matching_product(base_matching, endpoints, prime)
    degree = (prime + 1) // 2
    quotient_vectors = []
    for matching in orbit:
        product = matching_product(matching, endpoints, prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(quotient_by_conic(difference, degree - 2, prime))
    image_matrix = transpose(quotient_vectors)
    image_rank = rank(image_matrix, prime)

    quotient_degree = degree - 2
    if quotient_degree < 2:
        harmonic_basis = [
            [1 if row == column else 0 for row in range(len(homogeneous_basis(quotient_degree)))]
            for column in range(len(homogeneous_basis(quotient_degree)))
        ]
    else:
        harmonic_basis = nullspace(laplacian_matrix(quotient_degree, prime), prime)
    harmonic_radial_basis = list(harmonic_basis)
    if quotient_degree % 2 == 0:
        harmonic_radial_basis.append(radial_power_vector(quotient_degree, prime))
    harmonic_radial_rank = column_rank(harmonic_radial_basis, prime)
    combined_rank = column_rank(harmonic_radial_basis + quotient_vectors, prime)
    assert harmonic_radial_rank == image_rank, (name, harmonic_radial_rank, image_rank)
    assert combined_rank == image_rank, (name, combined_rank, image_rank)

    augmented_map = [[1] * len(orbit)] + image_matrix
    kernel_columns = nullspace(augmented_map, prime)
    kernel_columns = transpose(kernel_columns)
    kernel_basis = transpose(kernel_columns)
    assert len(kernel_basis) == len(orbit) - 1 - image_rank

    classes = labelled_classes(name, parent_group)
    class_by_element = {
        element: label for label, _representative, elements in classes for element in elements
    }
    group_actions = [
        (class_by_element[element], action_permutation(element, orbit, orbit_index))
        for element in sorted(parent_group)
    ]
    class_labels, tables = character_table(name, prime)
    class_records = []
    for label in class_labels:
        elements = next(elements for item_label, _representative, elements in classes if item_label == label)
        representative = min(elements)
        action = action_permutation(representative, orbit, orbit_index)
        class_records.append(
            {
                "label": label,
                "size": len(elements),
                "element_order": permutation_order(representative),
                "fixed_matchings": sum(index == image for index, image in enumerate(action)),
            }
        )

    domain_columns = [[1 if row == column else 0 for row in range(len(orbit))] for column in range(len(orbit))]
    augmentation_columns = [
        [(-1 if row == 0 else 1 if row == column else 0) % prime for row in range(len(orbit))]
        for column in range(1, len(orbit))
    ]
    action_bundle = (group_actions, class_labels)
    domain_decomposition = constituent_multiplicities(domain_columns, tables, action_bundle, prime)
    augmentation_decomposition = constituent_multiplicities(
        augmentation_columns, tables, action_bundle, prime
    )
    kernel_decomposition = constituent_multiplicities(kernel_basis, tables, action_bundle, prime)
    image_decomposition = {
        character: augmentation_decomposition.get(character, 0) - kernel_decomposition.get(character, 0)
        for character in augmentation_decomposition
        if augmentation_decomposition.get(character, 0) - kernel_decomposition.get(character, 0)
    }
    assert all(value > 0 for value in image_decomposition.values())

    sheet_sign = None
    if name in ("B3", "H3"):
        unseen = set(orbit)
        sheets = []
        while unseen:
            representative = min(unseen)
            sheet = {matching_image(element, representative) for element in psl_group}
            unseen -= sheet
            sheets.append(sheet)
        assert len(sheets) == 2 and len(sheets[0]) == len(sheets[1]) == prime
        sign_vector = [1 if matching in sheets[0] else -1 % prime for matching in orbit]
        sign_image = [
            sum(image_matrix[row][column] * sign_vector[column] for column in range(len(orbit))) % prime
            for row in range(len(image_matrix))
        ]
        for element in psl_group:
            action = action_permutation(element, orbit, orbit_index)
            assert all(sign_vector[action[index]] == sign_vector[index] for index in range(len(orbit)))
        for element in full_group - psl_group:
            action = action_permutation(element, orbit, orbit_index)
            assert all(sign_vector[action[index]] == -sign_vector[index] % prime for index in range(len(orbit)))
        _reduced, coordinate_pivots = rref(transpose(image_matrix), prime)
        assert len(coordinate_pivots) == image_rank
        reduced_vectors = [
            [vector[index] for index in coordinate_pivots] for vector in quotient_vectors
        ]
        degree_two_features = [
            vector + symmetric_power(vector, 2, prime) for vector in reduced_vectors
        ]
        balanced_solutions = balanced_zero_moment_subsets(degree_two_features, prime, prime)
        certified_sheets = {frozenset(orbit_index[matching] for matching in sheet) for sheet in sheets}
        recovered_sheets = {frozenset(solution) for solution in balanced_solutions}
        assert recovered_sheets == certified_sheets
        signed_moments = []
        first_nonzero_moment_degree = None
        for moment_degree in range(1, 9):
            moment = None
            for coefficient, vector in zip(sign_vector, reduced_vectors):
                power = symmetric_power(vector, moment_degree, prime)
                if moment is None:
                    moment = [0] * len(power)
                moment = [
                    (left + coefficient * right) % prime
                    for left, right in zip(moment, power)
                ]
            assert moment is not None
            nonzero = any(moment)
            signed_moments.append(
                {
                    "degree": moment_degree,
                    "dimension": len(moment),
                    "nonzero": nonzero,
                    "support": sum(value != 0 for value in moment),
                    "sha256": hashlib.sha256(bytes(moment)).hexdigest(),
                }
            )
            if nonzero:
                first_nonzero_moment_degree = moment_degree
                break
        sheet_sign = {
            "image_is_zero": not any(sign_image),
            "image_vector": sign_image,
            "psl_fixed_and_outer_negated": True,
            "signed_moments_on_image_coordinates": signed_moments,
            "first_nonzero_moment_degree": first_nonzero_moment_degree,
            "first_nonzero_moment_is_reference_independent": first_nonzero_moment_degree is not None
            and all(not record["nonzero"] for record in signed_moments[:-1]),
            "equal_halves_with_vanishing_moments_through_degree_2": len(balanced_solutions),
            "vanishing_moment_halves_are_exactly_the_psl_sheets": True,
        }

    orbit_rank_census = []
    for orbit_record in record["all_orbits"]:
        representative = tuple(tuple(pair) for pair in orbit_record["representative"])
        matching_orbit = sorted({matching_image(element, representative) for element in full_group})
        representative_product = matching_product(representative, endpoints, prime)
        vectors = []
        for matching in matching_orbit:
            product = matching_product(matching, endpoints, prime)
            difference = {
                exponent: (product.get(exponent, 0) - representative_product.get(exponent, 0)) % prime
                for exponent in set(product) | set(representative_product)
            }
            vectors.append(quotient_by_conic(difference, quotient_degree, prime))
        orbit_rank_census.append(
            {
                "orbit_size": len(matching_orbit),
                "stabilizer_order": orbit_record["stabilizer_order"],
                "difference_rank": column_rank(vectors, prime),
                "is_target_orbit": representative in orbit_index,
            }
        )

    # The relation kernel must be parent-stable before constituent claims are trusted.
    for _class_label, action in group_actions:
        for vector in kernel_basis:
            moved = [0] * len(orbit)
            for source, image in enumerate(action):
                moved[image] = vector[source]
            assert all(
                sum(augmented_map[row][column] * moved[column] for column in range(len(orbit))) % prime == 0
                for row in range(len(augmented_map))
            )

    return {
        "type": name,
        "field_order": prime,
        "parent_group_order": len(parent_group),
        "matching_orbit_size": len(orbit),
        "augmentation_dimension": len(orbit) - 1,
        "quotient_polynomial_degree": quotient_degree,
        "full_conic_ideal_layer_dimension": len(homogeneous_basis(quotient_degree)),
        "factorization_difference_image_rank": image_rank,
        "factorization_difference_kernel_dimension": len(kernel_basis),
        "classes": class_records,
        "character_table_mod_p": {
            character: dict(zip(class_labels, (value % prime for value in values)))
            for character, values in tables.items()
        },
        "permutation_module": domain_decomposition,
        "augmentation_module": augmentation_decomposition,
        "difference_kernel": kernel_decomposition,
        "difference_image": image_decomposition,
        "image_is_full_conic_ideal_layer": image_rank == len(homogeneous_basis(quotient_degree)),
        "harmonic_dimension": len(harmonic_basis),
        "image_equals_top_harmonic_plus_radial_line": True,
        "outer_sheet_sign": sheet_sign,
        "all_frozen_matching_orbit_ranks": sorted(
            orbit_rank_census,
            key=lambda item: (item["orbit_size"], item["stabilizer_order"], item["difference_rank"]),
        ),
    }


def build_certificate():
    scout = json.loads(SCOUT_PATH.read_text())
    types = [type_certificate(record) for record in scout["types"]]
    return {
        "schema": SCHEMA,
        "verdict": "GATE_2_PASS_HARMONIC_IMAGE_GATE_3_PASS_CUBIC_SHEET_MEMORY",
        "types": types,
        "summary": {
            "uniform_harmonic_image": True,
            "linear_and_quadratic_sheet_signs_vanish": True,
            "first_nonzero_sheet_moment_degree": 3,
            "vanishing_moments_recover_b3_h3_sheets": True,
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in (SCOUT_PATH, C399_PATH)
        },
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
        print("C406 Gate 2 certificate OK")


if __name__ == "__main__":
    main()
