#!/usr/bin/env python3
"""Exact replay for the C689 shared alternating-cycle radial mechanism."""

import argparse
import hashlib
import itertools
import json
import math
import runpy
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c689-shared-radial.json"
BALANCED_PATH = HERE / "2026-07-26-c665-balanced-matching-completeness.py"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
H3_PATH = HERE / "2026-07-25-c616-h3-equivariant-rank.json"
INPUT_HASHES = {
    BALANCED_PATH.name: "30428d78291930c00a1dc9ed7146f7714eaa86b438110535dd4dbc985b782b04",
    C406_PATH.name: "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51",
    H3_PATH.name: "cd1ecd1e5f467269d2b05bd109800aa8f48c11b7a178668a5555e951c049baa0",
}
REPRESENTATIVES = {
    7: ((0, 1), (2, 4), (3, 6), (5, 7)),
    11: ((0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, 11)),
}
OLD_WITNESSES = {
    7: {
        "base": ((0, 2), (1, 4), (3, 7), (5, 6)),
        "outer": ((0, 2), (1, 5), (3, 4), (6, 7)),
        "radial_scalar": 4,
    },
    11: {
        "base": ((0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, 11)),
        "outer": ((0, 1), (2, 11), (3, 8), (4, 6), (5, 9), (7, 10)),
        "radial_scalar": 10,
    },
}


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_inputs():
    for name, expected in INPUT_HASHES.items():
        assert sha256(HERE / name) == expected


def cycle_lengths(edges):
    adjacency = {}
    for left, right in edges:
        adjacency.setdefault(left, []).append(right)
        adjacency.setdefault(right, []).append(left)
    assert all(len(neighbors) == 2 for neighbors in adjacency.values())
    unseen = set(adjacency)
    lengths = []
    while unseen:
        start = next(iter(unseen))
        previous = None
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            length += 1
            following = next(
                neighbor
                for neighbor in adjacency[current]
                if neighbor != previous
            )
            previous, current = current, following
        assert current == start
        lengths.append(length)
    return sorted(lengths)


def radial_scalar(balanced, c406, left, right, q):
    degree = (q - 3) // 2
    left_product = balanced["matching_product"](left, q)
    right_product = balanced["matching_product"](right, q)
    difference = {
        exponent: (
            right_product.get(exponent, 0)
            - left_product.get(exponent, 0)
        )
        % q
        for exponent in set(left_product) | set(right_product)
    }
    value = balanced["quotient_by_conic"](difference, degree, q)
    for current_degree in range(degree, 1, -2):
        value = c406["matrix_vector"](
            c406["laplacian_matrix"](current_degree, q), value, q
        )
    assert len(value) == 1
    return value[0]


def torus_product(balanced, parameter, q):
    squares = sorted({value * value % q for value in range(1, q)})
    answer = {(0, 0, 0): 1}
    for value in squares:
        factor = {
            (1, 0, 0): parameter * value * value % q,
            (0, 1, 0): -(1 + parameter) * value % q,
            (0, 0, 1): 1,
        }
        answer = balanced["multiply"](answer, factor, q)
    return answer


def dickson_weight_coefficients(parameter, q):
    n = (q - 1) // 2
    coefficients = []
    for index in range((n - 1) // 2 + 1):
        lucas = n * math.comb(n - index, index) // (n - index)
        coefficient = (
            -(-1) ** index
            * lucas
            * pow(parameter, index, q)
            * pow(1 + parameter, n - 2 * index, q)
        ) % q
        coefficients.append(coefficient)
    return coefficients


def torus_record(balanced, c406, q):
    n = (q - 1) // 2
    squares = {value * value % q for value in range(1, q)}
    parameter = next(
        value
        for value in range(1, q)
        if 4 * value * value % q == 1 and value not in squares
    )
    inverse_parameter = pow(parameter, -1, q)
    assert inverse_parameter * pow(parameter, -1, q) % q == 4
    order_four = next(
        exponent for exponent in range(1, q) if pow(4, exponent, q) == 1
    )
    assert order_four == n
    assert pow(parameter, n, q) == q - 1

    products = {
        parameter: torus_product(balanced, parameter, q),
        inverse_parameter: torus_product(balanced, inverse_parameter, q),
    }
    actual_coefficients = {}
    for value, product in products.items():
        actual = [
            product.get((index, n - 2 * index, index), 0)
            for index in range((n - 1) // 2 + 1)
        ]
        formula = dickson_weight_coefficients(value, q)
        assert actual == formula
        assert product.get((n, 0, 0), 0) == q - 1
        assert product.get((0, 0, n), 0) == 1
        actual_coefficients[value] = actual

    difference = {
        exponent: (
            products[inverse_parameter].get(exponent, 0)
            - products[parameter].get(exponent, 0)
        )
        % q
        for exponent in set(products[parameter]) | set(products[inverse_parameter])
    }
    cofactor_degree = n - 2
    cofactor = balanced["quotient_by_conic"](
        difference, cofactor_degree, q
    )
    traced = cofactor
    for degree in range(cofactor_degree, 1, -2):
        traced = c406["matrix_vector"](
            c406["laplacian_matrix"](degree, q), traced, q
        )
    assert len(traced) == 3
    assert traced[0] == traced[2] == 0 and traced[1]

    difference_formula = []
    for index in range((n - 1) // 2 + 1):
        lucas = n * math.comb(n - index, index) // (n - index)
        difference_formula.append(
            (
                2
                * (-1) ** index
                * lucas
                * pow(parameter, index, q)
                * pow(1 + parameter, n - 2 * index, q)
            )
            % q
        )
    actual_difference = [
        (
            actual_coefficients[inverse_parameter][index]
            - actual_coefficients[parameter][index]
        )
        % q
        for index in range(len(difference_formula))
    ]
    assert actual_difference == difference_formula

    return {
        "n": n,
        "parameter": parameter,
        "inverse_parameter": inverse_parameter,
        "parameter_squared": parameter * parameter % q,
        "inverse_ratio": inverse_parameter * pow(parameter, -1, q) % q,
        "order_of_4": order_four,
        "alternating_cycle_length": 2 * order_four,
        "dickson_weight_coefficients": {
            str(parameter): actual_coefficients[parameter],
            str(inverse_parameter): actual_coefficients[inverse_parameter],
        },
        "difference_coefficients": actual_difference,
        "deepest_cofactor_trace": traced,
        "deepest_cofactor_trace_nonzero": True,
    }


def field_record(balanced, c406, q):
    pgl, psl = balanced["projective_groups"](q)
    full_orbit = sorted(balanced["orbit"](pgl, REPRESENTATIVES[q]))
    sheets = sorted(
        (
            sorted(part)
            for part in balanced["subgroup_orbits"](psl, full_orbit)
        ),
        key=lambda part: part[0],
    )
    assert [len(sheet) for sheet in sheets] == [q, q]

    all_edges = list(itertools.combinations(range(q + 1), 2))
    for sheet in sheets:
        counts = {
            edge: sum(edge in matching for matching in sheet)
            for edge in all_edges
        }
        assert set(counts.values()) == {1}

    incidence = [
        [len(set(left) & set(right)) for right in sheets[1]]
        for left in sheets[0]
    ]
    assert {value for row in incidence for value in row} == {0, 1}
    block_size = (q + 1) // 2
    design_lambda = (q + 1) // 4
    assert {sum(row) for row in incidence} == {block_size}
    gram = [
        [
            sum(incidence[i][column] * incidence[j][column] for column in range(q))
            for j in range(q)
        ]
        for i in range(q)
    ]
    assert all(
        gram[i][j] == (block_size if i == j else design_lambda)
        for i in range(q)
        for j in range(q)
    )
    # Since J^2=qJ=0 in characteristic q and
    # lambda=(q+1)/4=1/4, the inverse is 4 A^T (I-J).
    inverse = [
        [
            4
            * (
                incidence[column][row]
                - sum(incidence[index][row] for index in range(q))
            )
            % q
            for column in range(q)
        ]
        for row in range(q)
    ]
    assert all(
        sum(incidence[i][k] * inverse[k][j] for k in range(q)) % q
        == int(i == j)
        for i in range(q)
        for j in range(q)
    )

    translation = tuple(list(range(1, q)) + [0, q])

    def translation_labels(sheet):
        labels = []
        current = sheet[0]
        for _ in range(q):
            labels.append(current)
            current = balanced["image"](translation, current)
        assert current == sheet[0] and set(labels) == set(sheet)
        return labels

    labeled_sheets = [translation_labels(sheet) for sheet in sheets]
    paley_incidence = [
        [
            int(bool(set(left) & set(right)))
            for right in labeled_sheets[1]
        ]
        for left in labeled_sheets[0]
    ]
    support = {
        column for column, value in enumerate(paley_incidence[0]) if value
    }
    assert all(
        paley_incidence[row][column]
        == int((column - row) % q in support)
        for row in range(q)
        for column in range(q)
    )
    squares = {value * value % q for value in range(1, q)}
    paley_support = squares | {0}
    affine_normalizations = [
        (multiplier, shift)
        for multiplier in range(1, q)
        for shift in range(q)
        if {(multiplier * value + shift) % q for value in support}
        == paley_support
    ]
    assert affine_normalizations
    multiplier, shift = affine_normalizations[0]
    difference_counts = {
        difference: sum(
            (left - right) % q == difference
            for left in paley_support
            for right in paley_support
        )
        for difference in range(q)
    }
    assert difference_counts[0] == block_size
    assert set(difference_counts.values()) == {block_size, design_lambda}
    normalized_paley = [
        [
            int((column - row) % q in paley_support)
            for column in range(q)
        ]
        for row in range(q)
    ]
    normalized_signed = [
        [2 * value - 1 for value in row] for row in normalized_paley
    ]
    skew_core = [
        [
            normalized_signed[row][column] - int(row == column)
            for column in range(q)
        ]
        for row in range(q)
    ]
    assert all(
        skew_core[row][column] == -skew_core[column][row]
        for row in range(q)
        for column in range(q)
    )
    assert all(
        sum(
            skew_core[row][index] * skew_core[index][column]
            for index in range(q)
        )
        == (-q * int(row == column) + 1)
        for row in range(q)
        for column in range(q)
    )
    augmentation_basis = [
        [int(column == index) - int(column == q - 1) for column in range(q)]
        for index in range(q - 1)
    ]
    augmentation_images = [
        [
            sum(
                skew_core[row][column] * vector[column]
                for column in range(q)
            )
            % q
            for row in range(q)
        ]
        for vector in augmentation_basis
    ]
    full_rank = balanced["rank"](
        [[entry % q for entry in row] for row in skew_core], q
    )
    augmentation_rank = balanced["rank"](augmentation_images, q)
    assert full_rank == (q + 1) // 2
    assert augmentation_rank == (q - 1) // 2
    assert all(sum(row) == 0 for row in skew_core)
    assert all(
        sum(skew_core[row][column] for row in range(q)) == 0
        for column in range(q)
    )
    half = (q - 1) // 2
    character_taylor_coefficients = [
        sum(
            skew_core[0][value] * math.comb(value, degree)
            for value in range(q)
        )
        % q
        for degree in range(q)
    ]
    character_leading_coefficient = (
        -pow(math.factorial(half), -1, q)
    ) % q
    assert character_taylor_coefficients[:half] == [0] * half
    assert (
        character_taylor_coefficients[half]
        == character_leading_coefficient
    )
    assert character_leading_coefficient
    assert all(
        skew_core[
            (multiplier * row) % q
        ][
            (multiplier * column) % q
        ]
        == (
            (1 if multiplier in squares else -1)
            * skew_core[row][column]
        )
        for multiplier in range(1, q)
        for row in range(q)
        for column in range(q)
    )
    assert all(sum(vector) % q == 0 for vector in augmentation_images)
    assert all(
        sum(
            skew_core[row][column] * vector[column]
            for column in range(q)
        )
        % q
        == 0
        for vector in augmentation_images
        for row in range(q)
    )
    signed_incidence = [
        [2 * value - 1 for value in row] for row in paley_incidence
    ]
    assert {sum(row) for row in signed_incidence} == {1}
    bordered_hadamard = [[-1] + [1] * q]
    bordered_hadamard.extend(
        [1] + row for row in signed_incidence
    )
    assert all(
        sum(
            bordered_hadamard[i][column]
            * bordered_hadamard[j][column]
            for column in range(q + 1)
        )
        == ((q + 1) if i == j else 0)
        for i in range(q + 1)
        for j in range(q + 1)
    )

    incident_cycle_lengths = set()
    incident_radial_scalars = set()
    for edge in all_edges:
        left = next(matching for matching in sheets[0] if edge in matching)
        right = next(matching for matching in sheets[1] if edge in matching)
        assert set(left) & set(right) == {edge}
        remaining = (set(left) | set(right)) - {edge}
        incident_cycle_lengths.add(tuple(cycle_lengths(remaining)))
        incident_radial_scalars.add(
            radial_scalar(balanced, c406, left, right, q)
        )
    assert incident_cycle_lengths == {(q - 1,)}
    assert len(incident_radial_scalars) == 1
    assert next(iter(incident_radial_scalars))

    old = OLD_WITNESSES[q]
    assert old["base"] in full_orbit and old["outer"] in full_orbit
    assert set(old["base"]) & set(old["outer"]) == {
        next(iter(set(old["base"]) & set(old["outer"])))
    }
    old_scalar = radial_scalar(
        balanced, c406, old["base"], old["outer"], q
    )
    assert old_scalar == old["radial_scalar"]

    return {
        "q": q,
        "sheet_sizes": [q, q],
        "one_factorizations": True,
        "cross_incidence_design": {
            "v": q,
            "k": block_size,
            "lambda": design_lambda,
            "intersection_values": [0, 1],
            "gram_diagonal": block_size,
            "gram_off_diagonal": design_lambda,
            "invertible_in_characteristic_q": True,
            "inverse_formula": "4*A^T*(I-J)",
            "translation_circulant_support": sorted(support),
            "paley_affine_normalization": {
                "multiplier": multiplier,
                "shift": shift,
                "normalized_support": sorted(paley_support),
            },
            "paley_complement": True,
            "nonzero_paley_multiplier": 4,
            "bordered_paley_hadamard_order": q + 1,
            "bordered_paley_hadamard": True,
            "skew_paley_core": True,
            "skew_core_square": "-q*I+J",
            "characteristic_zero_augmentation_polynomial": "x^2+q",
            "nontrivial_incidence_eigenvalues": (
                "(1+sqrt(-q))/2 and (1-sqrt(-q))/2"
            ),
            "defining_characteristic_full_rank": full_rank,
            "defining_characteristic_augmentation_dimension": q - 1,
            "defining_characteristic_augmentation_rank": augmentation_rank,
            "defining_characteristic_square_zero": True,
            "defining_characteristic_image_equals_kernel": True,
            "defining_characteristic_full_nilpotency_index": 3,
            "defining_characteristic_full_jordan_blocks": (
                [3] + [2] * ((q - 3) // 2)
            ),
            "translation_group_algebra": "F_q[t]/(t^q), t=T-1",
            "quadratic_character_t_adic_order": half,
            "quadratic_character_leading_coefficient": (
                character_leading_coefficient
            ),
            "quadratic_character_leading_formula": "-1/(((q-1)/2)!)",
            "full_image_augmentation_ideal_power": half,
            "full_kernel_augmentation_ideal_power": half + 1,
            "augmentation_image_kernel_ideal_power": half + 1,
            "middle_quotient_isomorphism": (
                "I/I^((q+1)/2) ~= I^((q+1)/2)"
            ),
            "dilation_conjugation_character": "quadratic",
            "middle_quotient_twist": "quadratic orientation character",
        },
        "incident_edge_count": len(all_edges),
        "incident_pair_common_edges": 1,
        "incident_pair_cycle_lengths": [q - 1],
        "incident_radial_scalars": sorted(incident_radial_scalars),
        "torus_normal_form": torus_record(balanced, c406, q),
        "old_witness": {
            "base": [list(edge) for edge in old["base"]],
            "outer": [list(edge) for edge in old["outer"]],
            "common_edge": list(next(iter(set(old["base"]) & set(old["outer"])))),
            "radial_scalar": old_scalar,
        },
    }


def calculate():
    verify_inputs()
    balanced = runpy.run_path(str(BALANCED_PATH))
    c406 = runpy.run_path(str(C406_PATH))
    h3 = json.loads(H3_PATH.read_text())
    fields = [field_record(balanced, c406, q) for q in (7, 11)]
    assert fields[1]["old_witness"]["base"] == h3["witnesses"]["base_matching"]
    assert fields[1]["old_witness"]["outer"] == h3["witnesses"]["outer_sheet_matching"]
    assert (
        fields[1]["old_witness"]["radial_scalar"]
        == h3["witnesses"]["outer_sheet_delta_squared"]
    )
    return {
        "schema": 1,
        "construction": (
            "the unique opposite-sheet matchings through an edge; after "
            "edge normalization their complements are the c versus c^-1 "
            "alternating Hamilton-cycle exchange"
        ),
        "human_formula": (
            "the square-root resultant gives the Dickson weight coefficients; "
            "c^2=1/4 and c^n=-1 give one closed difference recurrence"
        ),
        "fields": fields,
        "inputs": {
            name: {"sha256": digest, "bytes": (HERE / name).stat().st_size}
            for name, digest in INPUT_HASHES.items()
        },
        "evidence_boundary": (
            "exact corroboration of the shared alternating-cycle/Dickson "
            "proof; the human proof supplies the invariant quotient and "
            "resultant identity"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(calculate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(rendered)
        print(f"wrote {CERTIFICATE.name}")
    else:
        assert CERTIFICATE.read_text() == rendered
        print("C689 shared radial certificate OK")


if __name__ == "__main__":
    main()
