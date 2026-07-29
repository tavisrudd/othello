#!/usr/bin/env python3
"""Independent finite-field replay of the C682 boundary degeneration."""

import importlib.util
import itertools
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-07-29-c682-d5-s3-kernel-incidence-replay.py"


def load_source():
    spec = importlib.util.spec_from_file_location("c682_boundary_replay_source", SOURCE)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def first_nonzero_index(form):
    return next(index for index, coefficient in enumerate(form) if coefficient)


def plucker_minimum_weight(module, kernel, prime):
    weights = []
    for columns in itertools.combinations(range(7), 3):
        minor = module.determinant3(
            [[row[column] for column in columns] for row in kernel], prime
        )
        if minor % prime:
            weights.append(sum(columns))
    assert weights
    return min(weights)


def coordinate_plane(indices):
    return [[int(column == index) for column in range(7)] for index in indices]


def gram_determinant(module, left, right, prime):
    return module.determinant3(
        [
            [module.apolar_pair(x, y, prime) for y in right]
            for x in left
        ],
        prime,
    )


def replay_prime(module, prime):
    root = module.primitive_root_of_order_30(prime)
    zeta5 = pow(root, 6, prime)
    order_five = [[pow(zeta5, 2, prime), 0], [0, 1]]
    u = (zeta5 - pow(zeta5, 4, prime)) % prime
    v = (pow(zeta5, 2, prime) - pow(zeta5, 3, prime)) % prime
    involution = [[v, u], [u, -v % prime]]
    order_three = module.matrix_product(order_five, involution, prime)
    group = module.generate_group([order_five, involution], prime)

    base = [0] * 13
    base[1], base[6], base[11] = 1, 11, -1 % prime
    d5_forms = module.orbit_forms(
        group,
        module.transform_form(base, [[0, 1], [1, 0]], prime),
        prime,
    )
    s3_forms = module.orbit_forms(
        group,
        module.transform_form(
            base,
            module.construct_s3_normalizer(order_three, root, prime),
            prime,
        ),
        prime,
    )
    d5_kernels = [
        module.nullspace(module.third_transvectant(form, prime), prime)
        for form in d5_forms
    ]
    s3_kernels = [
        module.nullspace(module.third_transvectant(form, prime), prime)
        for form in s3_forms
    ]
    d5_minima = [first_nonzero_index(form) for form in d5_forms]
    s3_minima = [first_nonzero_index(form) for form in s3_forms]
    d5_weights = [
        plucker_minimum_weight(module, kernel, prime)
        for kernel in d5_kernels
    ]
    s3_weights = [
        plucker_minimum_weight(module, kernel, prime)
        for kernel in s3_kernels
    ]
    assert sorted(d5_minima) == [0, 0, 0, 0, 0, 1]
    assert s3_minima == [0] * 10
    assert sorted(d5_weights) == [3, 3, 3, 3, 3, 4]
    assert s3_weights == [3] * 10
    divisor_row = d5_minima.index(1)

    closed = coordinate_plane((0, 1, 2))
    divisor = coordinate_plane((0, 1, 3))
    assert not gram_determinant(module, closed, closed, prime)
    assert not gram_determinant(module, divisor, divisor, prime)
    assert not gram_determinant(module, divisor, closed, prime)

    values = [
        [
            module.normalized_cross_gram(left, right, prime)
            for right in s3_kernels
        ]
        for left in d5_kernels
    ]
    sqrt_five = (
        2 * (pow(root, 2, prime) + pow(root, 3, prime) - pow(root, 7, prime))
        - 1
    ) % prime
    denominator = module.inverse(820125, prime)
    lambda_plus = (54781 + 24288 * sqrt_five) * denominator % prime
    lambda_minus = (54781 - 24288 * sqrt_five) * denominator % prime
    assert values[divisor_row].count(lambda_plus) == 5
    assert values[divisor_row].count(lambda_minus) == 5

    a, b = d5_weights[divisor_row], s3_weights[0]
    orders = (18 - 2 * a, 18 - 2 * b, 18 - a - b)
    assert orders == (10, 12, 11)
    assert 2 * orders[2] - orders[0] - orders[1] == 0
    return prime, divisor_row


def main():
    module = load_source()
    results = [replay_prime(module, prime) for prime in (61, 151)]
    print(
        "PASS boundary cross-Gram replay "
        + " ".join(f"p={prime}:divisor_row={row}" for prime, row in results)
    )


if __name__ == "__main__":
    main()
