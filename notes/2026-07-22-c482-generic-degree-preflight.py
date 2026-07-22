#!/usr/bin/env python3
"""Exact differential-rank preflight for coherent projection maps.

The calculation uses first-order dual numbers, never finite differences.  It
normalizes four of the six parent points by PGL(3), records three cross-ratio
coordinates for every projected labelled sextic, and row-reduces the resulting
Jacobian over F_101 and F_256.  The latter is the characteristic-two witness.
"""

from __future__ import annotations

import argparse
import json
import random


class PrimeField:
    def __init__(self, prime: int):
        self.prime = prime
        self.zero = 0
        self.one = 1

    def add(self, left: int, right: int) -> int:
        return (left + right) % self.prime

    def sub(self, left: int, right: int) -> int:
        return (left - right) % self.prime

    def mul(self, left: int, right: int) -> int:
        return left * right % self.prime

    def neg(self, value: int) -> int:
        return (-value) % self.prime

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return pow(value, self.prime - 2, self.prime)

    def random(self, rng: random.Random) -> int:
        return rng.randrange(self.prime)


class BinaryField256:
    """GF(2^8), in the polynomial basis modulo x^8+x^4+x^3+x+1."""

    zero = 0
    one = 1

    def add(self, left: int, right: int) -> int:
        return left ^ right

    sub = add

    def neg(self, value: int) -> int:
        return value

    def mul(self, left: int, right: int) -> int:
        answer = 0
        while right:
            if right & 1:
                answer ^= left
            right >>= 1
            left <<= 1
            if left & 0x100:
                left ^= 0x11B
        return answer

    def power(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return self.power(value, 254)

    def random(self, rng: random.Random) -> int:
        return rng.randrange(256)


class Dual:
    def __init__(self, field, value: int, gradient: list[int]):
        self.field = field
        self.value = value
        self.gradient = gradient

    def _lift(self, other) -> "Dual":
        if isinstance(other, Dual):
            return other
        return Dual(self.field, other, [self.field.zero] * len(self.gradient))

    def __add__(self, other) -> "Dual":
        other = self._lift(other)
        return Dual(
            self.field,
            self.field.add(self.value, other.value),
            [self.field.add(x, y) for x, y in zip(self.gradient, other.gradient)],
        )

    def __neg__(self) -> "Dual":
        return Dual(
            self.field,
            self.field.neg(self.value),
            [self.field.neg(x) for x in self.gradient],
        )

    def __sub__(self, other) -> "Dual":
        return self + (-self._lift(other))

    def __mul__(self, other) -> "Dual":
        other = self._lift(other)
        return Dual(
            self.field,
            self.field.mul(self.value, other.value),
            [
                self.field.add(
                    self.field.mul(x, other.value),
                    self.field.mul(self.value, y),
                )
                for x, y in zip(self.gradient, other.gradient)
            ],
        )

    def __truediv__(self, other) -> "Dual":
        other = self._lift(other)
        inverse = self.field.inv(other.value)
        quotient = self.field.mul(self.value, inverse)
        return Dual(
            self.field,
            quotient,
            [
                self.field.mul(
                    self.field.sub(x, self.field.mul(quotient, y)), inverse
                )
                for x, y in zip(self.gradient, other.gradient)
            ],
        )


def determinant(first, second, third):
    return (
        first[0] * (second[1] * third[2] - second[2] * third[1])
        - first[1] * (second[0] * third[2] - second[2] * third[0])
        + first[2] * (second[0] * third[1] - second[1] * third[0])
    )


def field_determinant(field, first, second, third):
    return field.add(
        field.sub(
            field.mul(
                first[0],
                field.sub(
                    field.mul(second[1], third[2]),
                    field.mul(second[2], third[1]),
                ),
            ),
            field.mul(
                first[1],
                field.sub(
                    field.mul(second[0], third[2]),
                    field.mul(second[2], third[0]),
                ),
            ),
        ),
        field.mul(
            first[2],
            field.sub(
                field.mul(second[0], third[1]),
                field.mul(second[1], third[0]),
            ),
        ),
    )


def matrix_rank(field, matrix: list[list[int]]) -> int:
    matrix = [row[:] for row in matrix]
    row = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (index for index in range(row, len(matrix)) if matrix[index][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inverse = field.inv(matrix[row][column])
        matrix[row] = [field.mul(entry, inverse) for entry in matrix[row]]
        for index in range(len(matrix)):
            if index == row or matrix[index][column] == field.zero:
                continue
            multiplier = matrix[index][column]
            matrix[index] = [
                field.sub(entry, field.mul(multiplier, pivot_entry))
                for entry, pivot_entry in zip(matrix[index], matrix[row])
            ]
        row += 1
        if row == len(matrix):
            break
    return row


def valid_configuration(field, points, centres) -> bool:
    for i in range(6):
        for j in range(i + 1, 6):
            for k in range(j + 1, 6):
                if field_determinant(field, points[i], points[j], points[k]) == field.zero:
                    return False
    for centre in centres:
        for i in range(6):
            for j in range(i + 1, 6):
                if field_determinant(field, centre, points[i], points[j]) == field.zero:
                    return False
    return True


def evaluate(field, centre_count: int, values: list[int]):
    variable_count = 4 + 2 * centre_count
    variables = []
    for index, value in enumerate(values):
        gradient = [field.zero] * variable_count
        gradient[index] = field.one
        variables.append(Dual(field, value, gradient))
    constant = lambda value: Dual(field, value, [field.zero] * variable_count)
    zero, one = constant(field.zero), constant(field.one)
    a, b, c, d = variables[:4]
    points = [
        [one, zero, zero],
        [zero, one, zero],
        [zero, zero, one],
        [one, one, one],
        [one, a, b],
        [one, c, d],
    ]
    centres = [
        [one, variables[4 + 2 * index], variables[5 + 2 * index]]
        for index in range(centre_count)
    ]
    if not valid_configuration(
        field,
        [[entry.value for entry in point] for point in points],
        [[entry.value for entry in centre] for centre in centres],
    ):
        raise ValueError("outside the arc/deep-centre open locus")

    outputs = []
    for centre in centres:
        bracket_31 = determinant(centre, points[2], points[0])
        bracket_32 = determinant(centre, points[2], points[1])
        for index in (3, 4, 5):
            # The unique quotient-line coordinate sending points 1,2,3 to
            # infinity, zero, one, evaluated on point index+1.
            outputs.append(
                determinant(centre, points[index], points[1])
                * bracket_31
                / (
                    determinant(centre, points[index], points[0])
                    * bracket_32
                )
            )
    return matrix_rank(field, [output.gradient for output in outputs])


def find_witness(field, centre_count: int, seed: int) -> dict:
    rng = random.Random(seed)
    expected = min(4 + 2 * centre_count, 3 * centre_count)
    for attempt in range(1, 10001):
        values = [field.random(rng) for _ in range(4 + 2 * centre_count)]
        try:
            rank = evaluate(field, centre_count, values)
        except (ValueError, ZeroDivisionError):
            continue
        if rank == expected:
            return {"attempt": attempt, "coordinates": values, "rank": rank}
    raise RuntimeError("no maximal-rank witness found")


def certificate() -> dict:
    fields = {"F101": PrimeField(101), "F256_char2": BinaryField256()}
    result = {
        "normal_form": [
            "(1,0,0)",
            "(0,1,0)",
            "(0,0,1)",
            "(1,1,1)",
            "(1,a,b)",
            "(1,c,d)",
        ],
        "dimension_formula": {
            "source": "4+2r",
            "target": "3r",
            "generic_fibre_if_maximal_rank": "max(4-r,0)",
        },
        "fields": {},
    }
    for field_index, (name, field) in enumerate(fields.items()):
        result["fields"][name] = {}
        for centre_count in (1, 2, 3, 4):
            result["fields"][name][str(centre_count)] = find_witness(
                field, centre_count, 478000 + 100 * field_index + centre_count
            )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    result = certificate()
    expected_ranks = {"1": 3, "2": 6, "3": 9, "4": 12}
    for field_result in result["fields"].values():
        assert {key: value["rank"] for key, value in field_result.items()} == expected_ranks
    if not arguments.check:
        print(json.dumps(result, indent=2, sort_keys=True))
    else:
        print("C482 generic-degree preflight: PASS")


if __name__ == "__main__":
    main()
