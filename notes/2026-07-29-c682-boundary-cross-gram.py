#!/usr/bin/env python3
"""Exact boundary extension certificate for the C682 cross-Gram separator."""

import argparse
import hashlib
import importlib.util
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-07-29-c682-d5-s3-kernel-incidence.py"
SOURCE_CERTIFICATE = HERE / "2026-07-29-c682-d5-s3-kernel-incidence.json"
OUTPUT = HERE / "2026-07-29-c682-boundary-cross-gram.json"


def load_source():
    spec = importlib.util.spec_from_file_location("c682_cross_gram_source", SOURCE)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def field_element(module, serialized):
    return module.Qzeta30(*(Fraction(value) for value in serialized))


def first_nonzero_index(form):
    return next(index for index, coefficient in enumerate(form) if coefficient)


def plucker_minimum_weight(module, kernel):
    weights = []
    for columns in itertools.combinations(range(7), 3):
        minor = module.determinant3(
            [[row[column] for column in columns] for row in kernel]
        )
        if minor:
            weights.append(sum(columns))
    assert weights
    return min(weights)


def coordinate_plane(module, indices):
    return [
        [module.ONE if column == index else module.ZERO for column in range(7)]
        for index in indices
    ]


def gram_determinant(module, left, right):
    return module.determinant3(
        [[module.apolar_pair(x, y) for y in right] for x in left]
    )


def certificate():
    module = load_source()
    old = json.loads(SOURCE_CERTIFICATE.read_text(encoding="utf-8"))
    lambda_plus = field_element(
        module, old["incidence"]["golden_values"]["lambda_plus"]
    )
    lambda_minus = field_element(
        module, old["incidence"]["golden_values"]["lambda_minus"]
    )

    zeta5 = module.ZETA**6
    order_five = [[zeta5**2, module.ZERO], [module.ZERO, module.ONE]]
    u = zeta5 - zeta5**4
    v = zeta5**2 - zeta5**3
    involution = [[v, u], [u, -v]]
    order_three = module.matrix_product(order_five, involution)
    group = module.generate_group([order_five, involution])

    base = [module.ZERO] * 13
    base[1], base[6], base[11] = (
        module.ONE,
        module.Qzeta30(11),
        module.Qzeta30(-1),
    )
    d5_forms = module.orbit_forms(
        group,
        module.transform_form(
            base, [[module.ZERO, module.ONE], [module.ONE, module.ZERO]]
        ),
    )
    s3_forms = module.orbit_forms(
        group,
        module.transform_form(
            base, module.construct_s3_normalizer(order_three)
        ),
    )
    d5_kernels = [
        module.nullspace(module.third_transvectant_matrix(form))
        for form, _ in d5_forms
    ]
    s3_kernels = [
        module.nullspace(module.third_transvectant_matrix(form))
        for form, _ in s3_forms
    ]

    d5_minima = [first_nonzero_index(form) for form, _ in d5_forms]
    s3_minima = [first_nonzero_index(form) for form, _ in s3_forms]
    d5_weights = [
        plucker_minimum_weight(module, kernel) for kernel in d5_kernels
    ]
    s3_weights = [
        plucker_minimum_weight(module, kernel) for kernel in s3_kernels
    ]
    assert sorted(d5_minima) == [0, 0, 0, 0, 0, 1]
    assert s3_minima == [0] * 10
    assert sorted(d5_weights) == [3, 3, 3, 3, 3, 4]
    assert s3_weights == [3] * 10
    divisor_row = d5_minima.index(1)
    assert d5_weights[divisor_row] == 4

    closed = coordinate_plane(module, (0, 1, 2))
    divisor = coordinate_plane(module, (0, 1, 3))
    for monomial_index, expected in ((0, closed), (1, divisor)):
        monomial = [module.ZERO] * 13
        monomial[monomial_index] = module.ONE
        actual = module.nullspace(module.third_transvectant_matrix(monomial))
        assert module.canonical_space(actual) == module.canonical_space(expected)
    assert not gram_determinant(module, closed, closed)
    assert not gram_determinant(module, divisor, divisor)
    assert not gram_determinant(module, divisor, closed)

    values = [
        [
            module.normalized_cross_gram(d5_kernel, s3_kernel)
            for s3_kernel in s3_kernels
        ]
        for d5_kernel in d5_kernels
    ]
    assert {
        value for row in values for value in row
    } == {lambda_plus, lambda_minus}
    assert all(row.count(lambda_plus) == row.count(lambda_minus) == 5 for row in values)

    for value in (lambda_plus, lambda_minus):
        centered = module.Qzeta30(820125) * value - module.Qzeta30(54781)
        assert centered**2 == module.Qzeta30(5 * 24288**2)

    plus_columns = [
        index
        for index, value in enumerate(values[divisor_row])
        if value == lambda_plus
    ]
    minus_columns = [
        index
        for index, value in enumerate(values[divisor_row])
        if value == lambda_minus
    ]
    assert len(plus_columns) == len(minus_columns) == 5

    # For g(t)=diag(1,t), apolar Gram entries scale by det(g)^6=t^6.
    # If a kernel Pluecker frame vanishes to order a, its normalized
    # self-Gram and cross-Gram determinants have orders 18-2a and 18-a-b.
    divisor_order = d5_weights[divisor_row]
    closed_order = s3_weights[0]
    divisor_closed_orders = {
        "D5_self_gram": 18 - 2 * divisor_order,
        "S3_self_gram": 18 - 2 * closed_order,
        "cross_gram": 18 - divisor_order - closed_order,
    }
    closed_closed_orders = {
        "D5_self_gram": 18 - 2 * closed_order,
        "S3_self_gram": 18 - 2 * closed_order,
        "cross_gram": 18 - 2 * closed_order,
    }
    assert divisor_closed_orders == {
        "D5_self_gram": 10,
        "S3_self_gram": 12,
        "cross_gram": 11,
    }
    assert closed_closed_orders == {
        "D5_self_gram": 12,
        "S3_self_gram": 12,
        "cross_gram": 12,
    }

    return {
        "schema": "c682-boundary-cross-gram-v1",
        "inputs": {
            SOURCE.name: sha256(SOURCE),
            SOURCE_CERTIFICATE.name: sha256(SOURCE_CERTIFICATE),
        },
        "one_parameter_degeneration": {
            "matrix": "diag(1,t)",
            "form_weight": "the coefficient of X^(12-i)Y^i has t-order i",
            "D5_form_minimum_indices": d5_minima,
            "S3_form_minimum_indices": s3_minima,
            "D5_kernel_plucker_orders": d5_weights,
            "S3_kernel_plucker_orders": s3_weights,
            "unique_divisor_D5_row": divisor_row,
        },
        "boundary_planes": {
            "closed_orbit": ["X^6", "X^5Y", "X^4Y^2"],
            "divisor_orbit": ["X^6", "X^5Y", "X^3Y^3"],
            "all_three_boundary_gram_determinants_vanish": True,
        },
        "orders_after_projective_kernel_normalization": {
            "divisor_closed": divisor_closed_orders,
            "closed_closed": closed_closed_orders,
            "ratio_order_divisor_closed": 2
            * divisor_closed_orders["cross_gram"]
            - divisor_closed_orders["D5_self_gram"]
            - divisor_closed_orders["S3_self_gram"],
            "ratio_order_closed_closed": 2
            * closed_closed_orders["cross_gram"]
            - closed_closed_orders["D5_self_gram"]
            - closed_closed_orders["S3_self_gram"],
        },
        "no_coarse_descent_witness": {
            "boundary_pair": ["divisor_orbit", "closed_orbit"],
            "lambda_plus_columns": plus_columns,
            "lambda_minus_columns": minus_columns,
            "explanation": (
                "All ten S3 kernels have the same closed-orbit limit, while "
                "the unique divisor D5 row contains five pairs of each "
                "golden value."
            ),
        },
        "extension": {
            "homogeneous_relation": (
                "(820125*c^2-54781*g_D*g_S)^2="
                "5*24288^2*(g_D*g_S)^2"
            ),
            "graph_coordinate": "[c^2:g_D*g_S]",
            "component_values": (
                "(54781 +/- 24288*sqrt(5))/820125"
            ),
            "conclusion": (
                "The ratio extends regularly on the normalization (or "
                "saturated graph) of each mate-correspondence component, "
                "but it does not descend to a regular scalar on the coarse "
                "boundary pair of kernel planes."
            ),
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    text = serialized()
    if arguments.check:
        assert OUTPUT.read_text(encoding="utf-8") == text
        print(f"PASS {OUTPUT.name} {sha256(OUTPUT)}")
    else:
        OUTPUT.write_text(text, encoding="utf-8")
        print(f"WROTE {OUTPUT.name} {sha256(OUTPUT)}")


if __name__ == "__main__":
    main()
