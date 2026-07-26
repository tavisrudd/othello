#!/usr/bin/env python3
"""Independent modular replay of the C654 rational certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, deque
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("klein_relative_position.json")
DEGREE = 12


def compose(left: bytes, right: bytes) -> bytes:
    return bytes(left[right[i]] for i in range(DEGREE))


def inverse(permutation: bytes) -> bytes:
    result = bytearray(DEGREE)
    for old, new in enumerate(permutation):
        result[new] = old
    return bytes(result)


def conjugate(element: bytes, by: bytes) -> bytes:
    return compose(by, compose(element, inverse(by)))


def order(element: bytes) -> int:
    identity = bytes(range(DEGREE))
    power = identity
    for value in range(1, 13):
        power = compose(element, power)
        if power == identity:
            return value
    raise AssertionError("unexpected order")


def parse(value: str, prime: int) -> int:
    if "/" not in value:
        return int(value) % prime
    numerator, denominator = map(int, value.split("/"))
    return numerator * pow(denominator, -1, prime) % prime


def matrix(data: list[list[str]], prime: int) -> list[list[int]]:
    return [[parse(value, prime) for value in row] for row in data]


def multiply(
    left: list[list[int]], right: list[list[int]], prime: int
) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % prime
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def add(
    left: list[list[int]], right: list[list[int]], prime: int
) -> list[list[int]]:
    return [
        [(left[i][j] + right[i][j]) % prime for j in range(len(left[0]))]
        for i in range(len(left))
    ]


def scale(value: int, target: list[list[int]], prime: int) -> list[list[int]]:
    return [[value * entry % prime for entry in row] for row in target]


def transpose(target: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*target)]


def identity(size: int) -> list[list[int]]:
    return [[int(i == j) for j in range(size)] for i in range(size)]


def rref(
    target: list[list[int]], prime: int
) -> tuple[list[list[int]], list[int]]:
    result = [[value % prime for value in row] for row in target]
    pivots: list[int] = []
    pivot_row = 0
    for column in range(len(result[0])):
        witness = next(
            (row for row in range(pivot_row, len(result)) if result[row][column]),
            None,
        )
        if witness is None:
            continue
        result[pivot_row], result[witness] = result[witness], result[pivot_row]
        factor = pow(result[pivot_row][column], -1, prime)
        result[pivot_row] = [factor * value % prime for value in result[pivot_row]]
        for row in range(len(result)):
            if row != pivot_row and result[row][column]:
                factor = result[row][column]
                result[row] = [
                    (result[row][j] - factor * result[pivot_row][j]) % prime
                    for j in range(len(result[0]))
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(result):
            break
    return result, pivots


def nullspace(target: list[list[int]], prime: int) -> list[list[int]]:
    reduced, pivots = rref(target, prime)
    free = [column for column in range(len(target[0])) if column not in pivots]
    result = []
    for free_column in free:
        vector = [0] * len(target[0])
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % prime
        result.append(vector)
    return result


def flatten(target: list[list[int]]) -> list[int]:
    return [value for row in target for value in row]


def unflatten(vector: list[int]) -> list[list[int]]:
    return [[vector[10 * i + j] for j in range(10)] for i in range(10)]


def generate_paired_group(
    permutation_generators: tuple[bytes, ...],
    matrix_generators: tuple[list[list[int]], ...],
    prime: int,
) -> dict[bytes, list[list[int]]]:
    identity_permutation = bytes(range(DEGREE))
    result = {identity_permutation: identity(10)}
    queue = deque((identity_permutation,))
    while queue:
        current = queue.popleft()
        for permutation_generator, matrix_generator in zip(
            permutation_generators, matrix_generators
        ):
            target = compose(permutation_generator, current)
            target_matrix = multiply(matrix_generator, result[current], prime)
            if target not in result:
                result[target] = target_matrix
                queue.append(target)
            else:
                assert result[target] == target_matrix
    return result


def generated_subgroup(generators: tuple[bytes, ...]) -> frozenset[bytes]:
    identity_permutation = bytes(range(DEGREE))
    result = {identity_permutation}
    queue = deque((identity_permutation,))
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in result:
                result.add(target)
                queue.append(target)
    return frozenset(result)


def commutant_basis(
    generators: tuple[bytes, ...],
    representation: dict[bytes, list[list[int]]],
    prime: int,
) -> list[list[list[int]]]:
    equations = []
    for generator in generators:
        action = representation[generator]
        for row in range(10):
            for column in range(10):
                equation = [0] * 100
                for middle in range(10):
                    equation[10 * row + middle] += action[middle][column]
                    equation[10 * middle + column] -= action[row][middle]
                equations.append([value % prime for value in equation])
    return [unflatten(vector) for vector in nullspace(equations, prime)]


def reynolds(
    subgroup: frozenset[bytes],
    target: list[list[int]],
    representation: dict[bytes, list[list[int]]],
    prime: int,
) -> list[list[int]]:
    result = [[0] * 10 for _ in range(10)]
    for element in subgroup:
        result = add(
            result,
            multiply(
                multiply(representation[element], target, prime),
                representation[inverse(element)],
                prime,
            ),
            prime,
        )
    return scale(pow(len(subgroup), -1, prime), result, prime)


def coordinates(
    target: list[list[int]], basis: list[list[list[int]]], prime: int
) -> list[int]:
    columns = [flatten(element) for element in basis]
    vector = flatten(target)
    augmented = [
        [columns[column][row] for column in range(len(columns))] + [vector[row]]
        for row in range(100)
    ]
    reduced, pivots = rref(augmented, prime)
    result = [0] * len(columns)
    for row, pivot in enumerate(pivots):
        if pivot < len(columns):
            result[pivot] = reduced[row][-1]
    assert all(
        sum(columns[column][row] * result[column] for column in range(len(columns)))
        % prime
        == vector[row]
        for row in range(100)
    )
    return result


def determinant_4(target: list[list[int]], prime: int) -> int:
    result = 0
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4)
            for j in range(i + 1, 4)
        )
        term = -1 if inversions % 2 else 1
        for row, column in enumerate(permutation):
            term *= target[row][column]
        result += term
    return result % prime


def replay(prime: int, data: dict[str, object]) -> None:
    payload = data["matrix_payload"]
    permutation_generators = tuple(bytes(row) for row in payload["group_generators"])
    matrix_generators = tuple(matrix(row, prime) for row in payload["representation_generators"])
    representation = generate_paired_group(
        permutation_generators, matrix_generators, prime
    )
    assert len(representation) == 660

    group = sorted(representation)
    involutions = [element for element in group if order(element) == 2]
    adjacency = [
        [
            int(i != j and order(compose(left, right)) == 2)
            for j, right in enumerate(involutions)
        ]
        for i, left in enumerate(involutions)
    ]
    carrier_matrix = [
        [
            (adjacency[i][j] + (3 if i == j else 0)) % prime
            for j in range(55)
        ]
        for i in range(55)
    ]
    assert len(nullspace(carrier_matrix, prime)) == 10

    gram = matrix(payload["gram"], prime)
    cm = matrix(payload["cm_operator"], prime)
    polarization = matrix(payload["polarization"], prime)
    assert multiply(cm, cm, prime) == scale(-11, identity(10), prime)
    assert multiply(gram, cm, prime) == polarization
    assert add(polarization, transpose(polarization), prime) == [
        [0] * 10 for _ in range(10)
    ]
    assert all(
        multiply(
            transpose(matrix_generator),
            multiply(gram, matrix_generator, prime),
            prime,
        )
        == gram
        for matrix_generator in matrix_generators
    )

    plus_generators = tuple(bytes(row) for row in payload["A5_plus_generators"])
    minus_generators = tuple(bytes(row) for row in payload["A5_minus_generators"])
    plus = generated_subgroup(plus_generators)
    minus = generated_subgroup(minus_generators)
    assert len(plus) == len(minus) == 60
    assert len(plus & minus) == 10
    assert len(generated_subgroup(tuple(plus | minus))) == 660

    unseen = set(group)
    fingerprint = []
    while unseen:
        representative = min(unseen)
        conjugacy_class = {
            conjugate(representative, element) for element in group
        }
        unseen -= conjugacy_class
        fingerprint.append(
            (
                order(representative),
                len(conjugacy_class),
                sum(representation[representative][i][i] for i in range(10))
                % prime,
            )
        )
    expected_fingerprint = [
        (1, 1, 10),
        (2, 55, 2),
        (3, 110, -2),
        (5, 132, 0),
        (5, 132, 0),
        (6, 110, 2),
        (11, 60, -1),
        (11, 60, -1),
    ]
    assert sorted(fingerprint) == sorted(
        (element_order, size, trace % prime)
        for element_order, size, trace in expected_fingerprint
    )
    product_orders = Counter(
        order(compose(left, right)) for left in plus for right in minus
    )
    assert product_orders == {1: 10, 2: 350, 3: 650, 5: 1440, 6: 550, 11: 600}
    character = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}
    projection_trace = (
        sum(count * character[key] ** 2 for key, count in product_orders.items())
        * pow(3600, -1, prime)
        % prime
    )
    assert projection_trace == 13 * pow(6, -1, prime) % prime

    commutant_plus = commutant_basis(plus_generators, representation, prime)
    commutant_minus = commutant_basis(minus_generators, representation, prime)
    common = commutant_basis(permutation_generators, representation, prime)
    assert [len(commutant_plus), len(commutant_minus), len(common)] == [4, 4, 2]
    for key, generators in (
        ("A5_plus_rank_five_idempotent", plus_generators),
        ("A5_minus_rank_five_idempotent", minus_generators),
    ):
        idempotent = matrix(payload[key], prime)
        assert multiply(idempotent, idempotent, prime) == idempotent
        assert len(rref(idempotent, prime)[1]) == 5
        assert all(
            multiply(idempotent, representation[generator], prime)
            == multiply(representation[generator], idempotent, prime)
            for generator in generators
        )

    mixed_columns = [
        coordinates(
            reynolds(
                plus,
                reynolds(minus, element, representation, prime),
                representation,
                prime,
            ),
            commutant_plus,
            prime,
        )
        for element in commutant_plus
    ]
    mixed = transpose(mixed_columns)
    one = identity(4)
    at_one = add(mixed, scale(-1, one, prime), prime)
    at_twelfth = add(mixed, scale(-pow(12, -1, prime), one, prime), prime)
    assert determinant_4(at_one, prime) == 0
    assert determinant_4(at_twelfth, prime) == 0
    assert len(nullspace(at_one, prime)) == 2
    assert len(nullspace(at_twelfth, prime)) == 2
    assert add(
        multiply(at_one, at_twelfth, prime),
        [[0] * 4 for _ in range(4)],
        prime,
    ) == [[0] * 4 for _ in range(4)]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert args.check
    raw = CERTIFICATE.read_bytes()
    data = json.loads(raw)
    for prime in (1009, 1013):
        replay(prime, data)
    print(f"OK modular replay primes=1009,1013 certificate_sha256={hashlib.sha256(raw).hexdigest()}")


if __name__ == "__main__":
    main()
