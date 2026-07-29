#!/usr/bin/env python3
"""Independent two-prime replay of the C682 golden kernel incidence."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


CERTIFICATE = Path(__file__).with_name(
    "2026-07-29-c682-d5-s3-kernel-incidence.json"
)


def inverse(value, prime):
    return pow(value % prime, -1, prime)


def normalize_vector(vector, prime):
    first = next(value % prime for value in vector if value % prime)
    scale = inverse(first, prime)
    return tuple(value * scale % prime for value in vector)


def rref(matrix, prime):
    if not matrix:
        return [], []
    work = [[value % prime for value in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = inverse(work[row][column], prime)
        work[row] = [value * scale % prime for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            if scale:
                work[index] = [
                    (left - scale * right) % prime
                    for left, right in zip(work[index], work[row], strict=True)
                ]
        pivots.append(column)
        row += 1
    return work[:row], pivots


def rank(matrix, prime):
    return len(rref(matrix, prime)[1]) if matrix else 0


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    width = len(matrix[0])
    free = [column for column in range(width) if column not in pivots]
    answer = []
    for column in free:
        vector = [0] * width
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column] % prime
        answer.append(vector)
    return answer


def matrix_product(left, right, prime):
    return [
        [
            sum(
                left[row][middle] * right[middle][column]
                for middle in range(2)
            )
            % prime
            for column in range(2)
        ]
        for row in range(2)
    ]


def matrix_inverse(matrix, prime):
    determinant = (
        matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    ) % prime
    scale = inverse(determinant, prime)
    return [
        [matrix[1][1] * scale % prime, -matrix[0][1] * scale % prime],
        [-matrix[1][0] * scale % prime, matrix[0][0] * scale % prime],
    ]


def normalize_matrix(matrix, prime):
    flat = normalize_vector([entry for row in matrix for entry in row], prime)
    return (flat[:2], flat[2:])


def matrix_power(matrix, exponent, prime):
    answer = [[1, 0], [0, 1]]
    for _ in range(exponent):
        answer = matrix_product(answer, matrix, prime)
    return answer


def polynomial_product(left, right, prime):
    answer = [0] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            answer[left_index + right_index] = (
                answer[left_index + right_index] + left_value * right_value
            ) % prime
    return answer


def polynomial_power(value, exponent, prime):
    answer = [1]
    for _ in range(exponent):
        answer = polynomial_product(answer, value, prime)
    return answer


def transform_form(form, matrix, prime):
    x_linear = [matrix[0][0], matrix[0][1]]
    y_linear = [matrix[1][0], matrix[1][1]]
    x_powers = [
        polynomial_power(x_linear, exponent, prime)
        for exponent in range(13)
    ]
    y_powers = [
        polynomial_power(y_linear, exponent, prime)
        for exponent in range(13)
    ]
    answer = [0] * 13
    for y_degree, coefficient in enumerate(form):
        monomial = polynomial_product(
            x_powers[12 - y_degree], y_powers[y_degree], prime
        )
        for index, value in enumerate(monomial):
            answer[index] = (answer[index] + coefficient * value) % prime
    return answer


def falling(value, order):
    if value < order:
        return 0
    return math.factorial(value) // math.factorial(value - order)


def third_transvectant(form, prime):
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
            for fy, coefficient in enumerate(form):
                fx = 12 - fy
                right = coefficient * falling(fx, index) * falling(
                    fy, 3 - index
                )
                output_y = py - index + fy - (3 - index)
                if left and right and 0 <= output_y <= 12:
                    matrix[output_y][column] = (
                        matrix[output_y][column] + left * right
                    ) % prime
    return matrix


def apolar_pair(left, right, prime):
    return (
        sum(
            (-1) ** index
            * math.factorial(index)
            * math.factorial(6 - index)
            * left[index]
            * right[6 - index]
            for index in range(7)
        )
        % prime
    )


def determinant3(matrix, prime):
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % prime


def normalized_cross_gram(left, right, prime):
    left_gram = [
        [apolar_pair(x, y, prime) for y in left] for x in left
    ]
    right_gram = [
        [apolar_pair(x, y, prime) for y in right] for x in right
    ]
    cross = [[apolar_pair(x, y, prime) for y in right] for x in left]
    denominator = determinant3(left_gram, prime) * determinant3(
        right_gram, prime
    )
    assert denominator % prime
    return (
        determinant3(cross, prime) ** 2 * inverse(denominator, prime)
    ) % prime


def generate_group(generators, prime):
    identity = normalize_matrix([[1, 0], [0, 1]], prime)
    seen = {identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in generators:
            product = normalize_matrix(
                matrix_product(current, generator, prime), prime
            )
            if product not in seen:
                seen.add(product)
                queue.append(product)
        assert len(seen) <= 60
    assert len(seen) == 60
    return list(seen)


def orbit_forms(group, form, prime):
    answer = {}
    for matrix in group:
        transformed = transform_form(form, matrix, prime)
        answer.setdefault(normalize_vector(transformed, prime), transformed)
    return list(answer.values())


def construct_s3_normalizer(cubic, root, prime):
    omega = pow(root, 10, prime)
    eta = pow(root, 5, prime)
    trace = (cubic[0][0] + cubic[1][1]) % prime
    determinant = (
        cubic[0][0] * cubic[1][1] - cubic[0][1] * cubic[1][0]
    ) % prime
    mu = trace * inverse(1 + omega, prime) % prime
    if determinant != mu * mu * omega % prime:
        omega = omega**2 % prime
        eta = pow(root, 25, prime)
        mu = trace * inverse(1 + omega, prime) % prime
    assert determinant == mu * mu * omega % prime
    high = nullspace(
        [
            [(cubic[0][0] - mu * omega) % prime, cubic[0][1]],
            [cubic[1][0], (cubic[1][1] - mu * omega) % prime],
        ],
        prime,
    )[0]
    low = nullspace(
        [
            [(cubic[0][0] - mu) % prime, cubic[0][1]],
            [cubic[1][0], (cubic[1][1] - mu) % prime],
        ],
        prime,
    )[0]
    change = [[high[0], low[0]], [high[1], low[1]]]
    answer = matrix_product(
        matrix_product(change, [[eta, 0], [0, 1]], prime),
        matrix_inverse(change, prime),
        prime,
    )
    assert normalize_matrix(matrix_power(answer, 2, prime), prime) == (
        normalize_matrix(cubic, prime)
    )
    return answer


def primitive_root_of_order_30(prime):
    return next(
        value
        for value in range(2, prime)
        if pow(value, 30, prime) == 1
        and all(pow(value, 30 // divisor, prime) != 1 for divisor in (2, 3, 5))
    )


def replay_prime(prime):
    root = primitive_root_of_order_30(prime)
    zeta5 = pow(root, 6, prime)
    order_five = [[pow(zeta5, 2, prime), 0], [0, 1]]
    u = (zeta5 - pow(zeta5, 4, prime)) % prime
    v = (pow(zeta5, 2, prime) - pow(zeta5, 3, prime)) % prime
    involution = [[v, u], [u, -v % prime]]
    order_three = matrix_product(order_five, involution, prime)
    group = generate_group([order_five, involution], prime)

    base = [0] * 13
    base[1], base[6], base[11] = 1, 11, -1 % prime
    assert all(
        normalize_vector(transform_form(base, matrix, prime), prime)
        == normalize_vector(base, prime)
        for matrix in group
    )
    d5_outer = [[0, 1], [1, 0]]
    s3_outer = construct_s3_normalizer(order_three, root, prime)
    d5_forms = orbit_forms(
        group, transform_form(base, d5_outer, prime), prime
    )
    s3_forms = orbit_forms(
        group, transform_form(base, s3_outer, prime), prime
    )
    assert len(d5_forms) == 6
    assert len(s3_forms) == 10
    d5_kernels = [
        nullspace(third_transvectant(form, prime), prime)
        for form in d5_forms
    ]
    s3_kernels = [
        nullspace(third_transvectant(form, prime), prime)
        for form in s3_forms
    ]
    assert all(len(kernel) == 3 for kernel in d5_kernels + s3_kernels)
    assert all(
        rank(left + right, prime) == 6
        for left in d5_kernels
        for right in s3_kernels
    )

    values = [
        [
            normalized_cross_gram(left, right, prime)
            for right in s3_kernels
        ]
        for left in d5_kernels
    ]
    sqrt_five = (
        2 * (pow(root, 2, prime) + pow(root, 3, prime) - pow(root, 7, prime))
        - 1
    ) % prime
    assert sqrt_five * sqrt_five % prime == 5
    denominator = inverse(820125, prime)
    lambda_plus = (54781 + 24288 * sqrt_five) * denominator % prime
    lambda_minus = (54781 - 24288 * sqrt_five) * denominator % prime
    assert lambda_plus != lambda_minus
    assert {value for row in values for value in row} == {
        lambda_plus,
        lambda_minus,
    }
    plus = [[int(value == lambda_plus) for value in row] for row in values]
    assert [sum(row) for row in plus] == [5] * 6
    assert [
        sum(plus[row][column] for row in range(6))
        for column in range(10)
    ] == [3] * 10
    return {
        "prime": prime,
        "primitive_30th_root": root,
        "sqrt5": sqrt_five,
        "lambda_plus": lambda_plus,
        "lambda_minus": lambda_minus,
        "direct_kernel_intersections": 0,
        "golden_incidence_edges": 30,
    }


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    assert certificate["schema"] == (
        "c682-characteristic-zero-d5-s3-kernel-incidence-v1"
    )
    assert certificate["incidence"]["edge_count"] == 0
    assert certificate["incidence"]["lambda_plus_row_degrees"] == [5] * 6
    assert certificate["incidence"]["lambda_plus_column_degrees"] == [3] * 10
    rows = [replay_prime(prime) for prime in (31, 61)]
    print(
        "PASS c682 D5-S3 golden kernel incidence replay "
        f"{sha256(CERTIFICATE)} "
        + " ".join(f"p={row['prime']}" for row in rows)
    )


if __name__ == "__main__":
    main()
