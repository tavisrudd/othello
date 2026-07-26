#!/usr/bin/env python3
"""Exact extension-field local-Clifford census for the admitted AME pencil.

The computation is deliberately self-contained and uses only the Python
standard library.  It works over F_p[x]/(modulus), expands the CSS stabilizer
over F_p, and exhausts all party permutations.  Shortened four-party planes
reduce each local equivalence problem to a homogeneous linear system for one
2e by 2e block.  One accepted solution for every solution permutation is
independently checked on the full stabilizer Lagrangian; the rest lie in the
same exact shortened-plane intertwiner system.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import sys
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Iterator, Sequence

HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-25-c623-ame-lu-extension-field-clifford.json"
N = 6

Element = tuple[int, ...]
FqVector = tuple[Element, ...]
FqMatrix = tuple[FqVector, ...]
FpMatrix = tuple[tuple[int, ...], ...]
Support = tuple[int, ...]
Permutation = tuple[int, ...]


@dataclass(frozen=True)
class FiniteField:
    p: int
    modulus: tuple[int, ...]

    def __post_init__(self) -> None:
        if self.modulus[-1] % self.p != 1:
            raise ValueError("modulus must be monic")
        if len(self.modulus) < 2:
            raise ValueError("extension degree must be positive")

    @property
    def degree(self) -> int:
        return len(self.modulus) - 1

    @property
    def order(self) -> int:
        return self.p**self.degree

    @property
    def zero(self) -> Element:
        return (0,) * self.degree

    @property
    def one(self) -> Element:
        return (1,) + (0,) * (self.degree - 1)

    @property
    def basis(self) -> tuple[Element, ...]:
        return tuple(
            tuple(1 if i == j else 0 for i in range(self.degree))
            for j in range(self.degree)
        )

    def element(self, value: int) -> Element:
        return (value % self.p,) + (0,) * (self.degree - 1)

    def elements(self) -> Iterator[Element]:
        return itertools.product(range(self.p), repeat=self.degree)

    def add(self, left: Sequence[int], right: Sequence[int]) -> Element:
        return tuple((x + y) % self.p for x, y in zip(left, right))

    def neg(self, value: Sequence[int]) -> Element:
        return tuple(-x % self.p for x in value)

    def sub(self, left: Sequence[int], right: Sequence[int]) -> Element:
        return self.add(left, self.neg(right))

    def mul(self, left: Sequence[int], right: Sequence[int]) -> Element:
        out = [0] * (2 * self.degree - 1)
        for i, x in enumerate(left):
            for j, y in enumerate(right):
                out[i + j] = (out[i + j] + x * y) % self.p
        for k in range(len(out) - 1, self.degree - 1, -1):
            coefficient = out[k]
            for j in range(self.degree):
                out[k - self.degree + j] = (
                    out[k - self.degree + j]
                    - coefficient * self.modulus[j]
                ) % self.p
        return tuple(out[: self.degree])

    def pow(self, value: Sequence[int], exponent: int) -> Element:
        if exponent < 0:
            return self.pow(self.inv(value), -exponent)
        result = self.one
        base = tuple(value)
        while exponent:
            if exponent & 1:
                result = self.mul(result, base)
            base = self.mul(base, base)
            exponent //= 2
        return result

    def inv(self, value: Sequence[int]) -> Element:
        if tuple(value) == self.zero:
            raise ZeroDivisionError("zero has no inverse")
        return self.pow(value, self.order - 2)

    def div(self, numerator: Sequence[int], denominator: Sequence[int]) -> Element:
        return self.mul(numerator, self.inv(denominator))

    def eval(self, coefficients: Sequence[int], value: Sequence[int]) -> Element:
        result = self.zero
        for coefficient in reversed(coefficients):
            result = self.add(self.mul(result, value), self.element(coefficient))
        return result

    def frobenius(self, value: Sequence[int], exponent: int = 1) -> Element:
        return self.pow(value, self.p**exponent)

    def trace(self, value: Sequence[int]) -> int:
        total = self.zero
        term = tuple(value)
        for _ in range(self.degree):
            total = self.add(total, term)
            term = self.frobenius(term)
        if any(total[index] for index in range(1, self.degree)):
            raise AssertionError("field trace did not land in the prime field")
        return total[0]


FIELDS = (
    FiniteField(3, (1, 0, 1)),
    FiniteField(5, (2, 0, 1)),
    FiniteField(3, (1, 2, 0, 1)),
)


def fq_rref(field: FiniteField, rows: Iterable[Sequence[Element]]) -> tuple[FqMatrix, tuple[int, ...]]:
    matrix = [list(map(tuple, row)) for row in rows]
    if not matrix:
        return (), ()
    width = len(matrix[0])
    pivot_row = 0
    pivots: list[int] = []
    for column in range(width):
        found = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column] != field.zero),
            None,
        )
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(inverse, value) for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row:
                continue
            factor = matrix[row][column]
            if factor != field.zero:
                matrix[row] = [
                    field.sub(value, field.mul(factor, pivot))
                    for value, pivot in zip(matrix[row], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    nonzero = [
        tuple(row) for row in matrix if any(value != field.zero for value in row)
    ]
    return tuple(nonzero), tuple(pivots)


def fq_nullspace(field: FiniteField, rows: Iterable[Sequence[Element]], width: int) -> FqMatrix:
    reduced, pivots = fq_rref(field, rows)
    free = [column for column in range(width) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [field.zero] * width
        vector[free_column] = field.one
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(reduced[row][free_column])
        basis.append(tuple(vector))
    return tuple(basis)


def fq_rowspace(field: FiniteField, rows: Iterable[Sequence[Element]]) -> FqMatrix:
    return fq_rref(field, rows)[0]


def fq_inverse(field: FiniteField, matrix: FqMatrix) -> FqMatrix:
    size = len(matrix)
    augmented = tuple(
        tuple(matrix[row])
        + tuple(
            field.one if row == column else field.zero
            for column in range(size)
        )
        for row in range(size)
    )
    reduced, pivots = fq_rref(field, augmented)
    if pivots[:size] != tuple(range(size)) or len(reduced) != size:
        raise ZeroDivisionError("singular finite-field matrix")
    return tuple(tuple(row[size:]) for row in reduced)


def fq_matvec(
    field: FiniteField, matrix: FqMatrix, vector: Sequence[Element]
) -> FqVector:
    return tuple(
        sum_elements(
            field,
            (
                field.mul(matrix[row][column], vector[column])
                for column in range(len(vector))
            ),
        )
        for row in range(len(matrix))
    )


def fq_matmul_row(field: FiniteField, coefficients: Sequence[Element], rows: FqMatrix) -> FqVector:
    return tuple(
        sum_elements(
            field,
            (field.mul(coefficient, rows[index][column]) for index, coefficient in enumerate(coefficients)),
        )
        for column in range(len(rows[0]))
    )


def sum_elements(field: FiniteField, values: Iterable[Element]) -> Element:
    result = field.zero
    for value in values:
        result = field.add(result, value)
    return result


def determinant3(field: FiniteField, columns: Sequence[Sequence[Element]]) -> Element:
    total = field.zero
    for permutation in itertools.permutations(range(3)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(3)
            for j in range(i + 1, 3)
        )
        term = field.one
        for row in range(3):
            term = field.mul(term, columns[permutation[row]][row])
        total = field.add(total, term if inversions % 2 == 0 else field.neg(term))
    return total


def pencil_points(field: FiniteField, parameter: Element) -> tuple[FqVector, ...]:
    zero, one = field.zero, field.one
    return (
        (zero, one, field.sub(one, parameter)),
        (zero, one, field.sub(parameter, one)),
        (one, field.sub(one, parameter), zero),
        (one, field.sub(parameter, one), zero),
        (one, zero, field.neg(parameter)),
        (one, zero, parameter),
    )


def parity_check(points: Sequence[FqVector]) -> FqMatrix:
    return tuple(
        tuple(points[column][row] for column in range(N))
        for row in range(3)
    )


def code_from_points(field: FiniteField, points: Sequence[FqVector]) -> FqMatrix:
    return fq_nullspace(field, parity_check(points), N)


def dual(field: FiniteField, code: FqMatrix) -> FqMatrix:
    return fq_nullspace(field, code, N)


def canonical_projective(
    field: FiniteField, vector: Sequence[Element]
) -> FqVector:
    pivot = next(value for value in vector if value != field.zero)
    inverse = field.inv(pivot)
    return tuple(field.mul(inverse, value) for value in vector)


def normalize_frame(
    field: FiniteField,
    points: Sequence[FqVector],
    frame: tuple[int, int, int, int],
) -> tuple[FqVector, ...]:
    first, second, third, fourth = (
        points[index] for index in frame
    )
    basis = tuple(
        tuple(
            (first, second, third)[column][row]
            for column in range(3)
        )
        for row in range(3)
    )
    coordinates = fq_matvec(field, fq_inverse(field, basis), fourth)
    if any(value == field.zero for value in coordinates):
        raise AssertionError("arc frame has a zero coordinate")
    scaled_basis = tuple(
        tuple(
            field.mul(
                (first, second, third)[column][row],
                coordinates[column],
            )
            for column in range(3)
        )
        for row in range(3)
    )
    transform = fq_inverse(field, scaled_basis)
    return tuple(
        sorted(
            canonical_projective(
                field, fq_matvec(field, transform, point)
            )
            for point in points
        )
    )


def canonical_arc(
    field: FiniteField, points: Sequence[FqVector]
) -> tuple[FqVector, ...]:
    return min(
        normalize_frame(field, points, frame)
        for frame in itertools.permutations(range(N), 4)
    )


def shortened_word(field: FiniteField, code: FqMatrix, omitted: tuple[int, int]) -> FqVector:
    equations = tuple(
        tuple(code[row][party] for row in range(len(code)))
        for party in omitted
    )
    coefficients = fq_nullspace(field, equations, len(code))
    if len(coefficients) != 1:
        raise AssertionError("shortening is not one-dimensional")
    word = fq_matmul_row(field, coefficients[0], code)
    first = next(value for value in word if value != field.zero)
    word = tuple(field.mul(field.inv(first), value) for value in word)
    expected = tuple(index for index in range(N) if index not in omitted)
    if tuple(index for index, value in enumerate(word) if value != field.zero) != expected:
        raise AssertionError("shortened word has the wrong support")
    return word


def shortened_data(
    field: FiniteField, code: FqMatrix
) -> dict[Support, tuple[FqVector, FqVector]]:
    code_dual = dual(field, code)
    return {
        tuple(index for index in range(N) if index not in omitted): (
            shortened_word(field, code, omitted),
            shortened_word(field, code_dual, omitted),
        )
        for omitted in itertools.combinations(range(N), 2)
    }


def fp_identity(size: int) -> FpMatrix:
    return tuple(
        tuple(1 if row == column else 0 for column in range(size))
        for row in range(size)
    )


def fp_zero(rows: int, columns: int) -> FpMatrix:
    return tuple((0,) * columns for _ in range(rows))


def fp_mul(p: int, left: FpMatrix, right: FpMatrix) -> FpMatrix:
    return tuple(
        tuple(
            sum(left[row][index] * right[index][column] for index in range(len(right))) % p
            for column in range(len(right[0]))
        )
        for row in range(len(left))
    )


def fp_pow(p: int, matrix: FpMatrix, exponent: int) -> FpMatrix:
    result = fp_identity(len(matrix))
    base = matrix
    while exponent:
        if exponent & 1:
            result = fp_mul(p, result, base)
        base = fp_mul(p, base, base)
        exponent //= 2
    return result


def fp_trace(p: int, matrix: FpMatrix) -> int:
    return sum(matrix[index][index] for index in range(len(matrix))) % p


def fp_rref(p: int, rows: Iterable[Sequence[int]], width: int | None = None) -> tuple[FpMatrix, tuple[int, ...]]:
    matrix = [[value % p for value in row] for row in rows]
    if not matrix:
        return (), ()
    if width is None:
        width = len(matrix[0])
    pivot_row = 0
    pivots: list[int] = []
    for column in range(width):
        found = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column] % p),
            None,
        )
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], -1, p)
        matrix[pivot_row] = [(inverse * value) % p for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row:
                continue
            factor = matrix[row][column]
            if factor:
                matrix[row] = [
                    (value - factor * pivot) % p
                    for value, pivot in zip(matrix[row], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return (
        tuple(tuple(row) for row in matrix if any(value % p for value in row)),
        tuple(pivots),
    )


def fp_nullspace(p: int, rows: Iterable[Sequence[int]], width: int) -> tuple[tuple[int, ...], ...]:
    reduced, pivots = fp_rref(p, rows, width)
    free = [column for column in range(width) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * width
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % p
        basis.append(tuple(vector))
    return tuple(basis)


def fp_inverse(p: int, matrix: FpMatrix) -> FpMatrix:
    size = len(matrix)
    augmented = tuple(
        tuple(matrix[row]) + tuple(1 if row == column else 0 for column in range(size))
        for row in range(size)
    )
    reduced, pivots = fp_rref(p, augmented, size)
    if pivots != tuple(range(size)) or len(reduced) != size:
        raise ZeroDivisionError("singular matrix")
    return tuple(tuple(row[size:]) for row in reduced)


def multiplication_matrix(field: FiniteField, scalar: Element) -> FpMatrix:
    return tuple(
        tuple(field.mul(scalar, field.basis[column])[row] for column in range(field.degree))
        for row in range(field.degree)
    )


def block_diagonal(left: FpMatrix, right: FpMatrix) -> FpMatrix:
    nleft, nright = len(left), len(right)
    return tuple(
        tuple(
            left[row][column]
            if row < nleft and column < nleft
            else right[row - nleft][column - nleft]
            if row >= nleft and column >= nleft
            else 0
            for column in range(nleft + nright)
        )
        for row in range(nleft + nright)
    )


def relation_matrix(
    field: FiniteField,
    data: dict[Support, tuple[FqVector, FqVector]],
    support: Support,
    source: int,
    target: int,
) -> FpMatrix:
    xword, zword = data[support]
    xratio = field.div(xword[target], xword[source])
    zratio = field.div(zword[target], zword[source])
    return block_diagonal(
        multiplication_matrix(field, xratio),
        multiplication_matrix(field, zratio),
    )


def symplectic_form(field: FiniteField) -> FpMatrix:
    trace_pairing = tuple(
        tuple(field.trace(field.mul(left, right)) for right in field.basis)
        for left in field.basis
    )
    e = field.degree
    return tuple(
        tuple(
            trace_pairing[row][column - e]
            if row < e and column >= e
            else -trace_pairing[row - e][column] % field.p
            if row >= e and column < e
            else 0
            for column in range(2 * e)
        )
        for row in range(2 * e)
    )


def is_symplectic(field: FiniteField, matrix: FpMatrix) -> bool:
    form = symplectic_form(field)
    size = len(matrix)
    for left in range(size):
        for right in range(size):
            pairing = sum(
                matrix[row][left]
                * form[row][column]
                * matrix[column][right]
                for row in range(size)
                for column in range(size)
            ) % field.p
            if pairing != form[left][right]:
                return False
    return True


def loop_color(field: FiniteField, matrix: FpMatrix) -> tuple[int, ...]:
    inverse = fp_inverse(field.p, matrix)

    def traces(value: FpMatrix) -> tuple[int, ...]:
        return tuple(
            fp_trace(field.p, fp_pow(field.p, value, exponent))
            for exponent in range(1, 2 * field.degree + 1)
        )

    return min(traces(matrix), traces(inverse))


def edge_colors(
    field: FiniteField, data: dict[Support, tuple[FqVector, FqVector]]
) -> dict[tuple[int, int, Support, Support], tuple[int, ...]]:
    colors: dict[tuple[int, int, Support, Support], tuple[int, ...]] = {}
    for source, target in itertools.combinations(range(N), 2):
        supports = tuple(
            support for support in sorted(data)
            if source in support and target in support
        )
        for first, second in itertools.combinations(supports, 2):
            loop = fp_mul(
                field.p,
                relation_matrix(field, data, second, target, source),
                relation_matrix(field, data, first, source, target),
            )
            colors[(source, target, first, second)] = loop_color(field, loop)
    return colors


def permute_support(support: Support, permutation: Permutation) -> Support:
    return tuple(sorted(permutation[index] for index in support))


def candidate_permutations(
    source_colors: dict[tuple[int, int, Support, Support], tuple[int, ...]],
    target_colors: dict[tuple[int, int, Support, Support], tuple[int, ...]],
) -> Iterator[Permutation]:
    for permutation in itertools.permutations(range(N)):
        if all(
            color
            == target_colors[
                (
                    *tuple(sorted((permutation[left], permutation[right]))),
                    *tuple(
                        sorted(
                            (
                                permute_support(first, permutation),
                                permute_support(second, permutation),
                            )
                        )
                    ),
                )
            ]
            for (left, right, first, second), color in source_colors.items()
        ):
            yield permutation


def matrix_linear_term(
    p: int,
    left: FpMatrix,
    right: FpMatrix,
    output_row: int,
    output_column: int,
) -> list[int]:
    size = len(left)
    coefficients = [0] * (size * size)
    for row in range(size):
        for column in range(size):
            coefficients[row * size + column] = (
                left[output_row][row] * right[column][output_column]
            ) % p
    return coefficients


def add_constraint(
    p: int,
    rows: list[tuple[int, ...]],
    left1: FpMatrix,
    right1: FpMatrix,
    left2: FpMatrix,
    right2: FpMatrix,
) -> None:
    size = len(left1)
    for output_row in range(size):
        for output_column in range(size):
            first = matrix_linear_term(
                p, left1, right1, output_row, output_column
            )
            second = matrix_linear_term(
                p, left2, right2, output_row, output_column
            )
            row = tuple((x - y) % p for x, y in zip(first, second))
            if any(row):
                rows.append(row)


def matrix_from_vector(vector: Sequence[int], size: int) -> FpMatrix:
    return tuple(
        tuple(vector[row * size + column] for column in range(size))
        for row in range(size)
    )


def vector_combinations(p: int, basis: Sequence[Sequence[int]]) -> Iterator[tuple[int, ...]]:
    if not basis:
        return
    width = len(basis[0])
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        if not any(coefficients):
            continue
        yield tuple(
            sum(
                coefficients[index] * basis[index][column]
                for index in range(len(basis))
            ) % p
            for column in range(width)
        )


def propagation_data(
    field: FiniteField,
    source: dict[Support, tuple[FqVector, FqVector]],
    target: dict[Support, tuple[FqVector, FqVector]],
    permutation: Permutation,
) -> tuple[dict[int, FpMatrix], dict[int, FpMatrix], list[tuple[int, ...]]]:
    size = 2 * field.degree
    identity = fp_identity(size)
    left = {0: identity}
    right = {0: identity}
    for party in range(1, N):
        support = next(
            item for item in sorted(source) if 0 in item and party in item
        )
        target_support = permute_support(support, permutation)
        left[party] = relation_matrix(
            field,
            target,
            target_support,
            permutation[0],
            permutation[party],
        )
        right[party] = fp_inverse(
            field.p,
            relation_matrix(field, source, support, 0, party),
        )

    constraints: list[tuple[int, ...]] = []
    for support in sorted(source):
        anchor = min(support)
        target_support = permute_support(support, permutation)
        for party in support:
            if party == anchor:
                continue
            source_relation = relation_matrix(
                field, source, support, anchor, party
            )
            target_relation = relation_matrix(
                field,
                target,
                target_support,
                permutation[anchor],
                permutation[party],
            )
            add_constraint(
                field.p,
                constraints,
                left[party],
                fp_mul(field.p, right[party], source_relation),
                fp_mul(field.p, target_relation, left[anchor]),
                right[anchor],
            )
    return left, right, constraints


def local_blocks(
    p: int,
    root: FpMatrix,
    left: dict[int, FpMatrix],
    right: dict[int, FpMatrix],
    permutation: Permutation,
) -> tuple[FpMatrix, ...]:
    blocks: list[FpMatrix | None] = [None] * N
    for source_party in range(N):
        blocks[permutation[source_party]] = fp_mul(
            p,
            fp_mul(p, left[source_party], root),
            right[source_party],
        )
    if any(block is None for block in blocks):
        raise AssertionError("party propagation was incomplete")
    return tuple(block for block in blocks if block is not None)


def fq_code_fp_basis(field: FiniteField, code: FqMatrix) -> tuple[tuple[int, ...], ...]:
    rows = []
    for codeword in code:
        for scalar in field.basis:
            expanded = []
            for coordinate in codeword:
                expanded.extend(field.mul(scalar, coordinate))
            rows.append(tuple(expanded))
    return tuple(rows)


def stabilizer_fp_basis(field: FiniteField, code: FqMatrix) -> FpMatrix:
    e = field.degree
    xrows = fq_code_fp_basis(field, code)
    zrows = fq_code_fp_basis(field, dual(field, code))
    rows = []
    for row in xrows:
        out = []
        for party in range(N):
            out.extend(row[party * e : (party + 1) * e])
            out.extend((0,) * e)
        rows.append(tuple(out))
    for row in zrows:
        out = []
        for party in range(N):
            out.extend((0,) * e)
            out.extend(row[party * e : (party + 1) * e])
        rows.append(tuple(out))
    return fp_rref(field.p, rows)[0]


def apply_local_map(
    field: FiniteField,
    rows: FpMatrix,
    blocks: tuple[FpMatrix, ...],
    permutation: Permutation,
) -> FpMatrix:
    size = 2 * field.degree
    mapped_rows = []
    for row in rows:
        out = [0] * (N * size)
        for source_party in range(N):
            vector = tuple(
                row[source_party * size + index] for index in range(size)
            )
            target_party = permutation[source_party]
            block = blocks[target_party]
            image = tuple(
                sum(block[i][j] * vector[j] for j in range(size)) % field.p
                for i in range(size)
            )
            out[target_party * size : (target_party + 1) * size] = image
        mapped_rows.append(tuple(out))
    return fp_rref(field.p, mapped_rows)[0]


def element_from_basis_image(vector: Sequence[int], offset: int, degree: int) -> Element:
    return tuple(vector[offset + index] for index in range(degree))


def semilinear_exponents(
    field: FiniteField, matrix: FpMatrix
) -> tuple[int, ...]:
    e = field.degree
    exponents = []
    for exponent in range(e):
        coefficients: list[tuple[Element, Element]] = []
        valid = True
        for input_coordinate in range(2):
            basis_vector = [0] * (2 * e)
            basis_vector[input_coordinate * e] = 1
            image = tuple(
                sum(matrix[row][column] * basis_vector[column] for column in range(2 * e))
                % field.p
                for row in range(2 * e)
            )
            coefficients.append(
                (
                    element_from_basis_image(image, 0, e),
                    element_from_basis_image(image, e, e),
                )
            )
        for input_coordinate in range(2):
            for basis_index, basis_element in enumerate(field.basis):
                basis_vector = [0] * (2 * e)
                basis_vector[input_coordinate * e + basis_index] = 1
                image = tuple(
                    sum(matrix[row][column] * basis_vector[column] for column in range(2 * e))
                    % field.p
                    for row in range(2 * e)
                )
                twisted = field.frobenius(basis_element, exponent)
                expected = (
                    field.mul(coefficients[input_coordinate][0], twisted),
                    field.mul(coefficients[input_coordinate][1], twisted),
                )
                if (
                    element_from_basis_image(image, 0, e),
                    element_from_basis_image(image, e, e),
                ) != expected:
                    valid = False
                    break
            if not valid:
                break
        if valid:
            exponents.append(exponent)
    return tuple(exponents)


def witness_semilinear_exponents(
    field: FiniteField, blocks: tuple[FpMatrix, ...]
) -> tuple[int, ...]:
    common = set(range(field.degree))
    for block in blocks:
        common.intersection_update(semilinear_exponents(field, block))
    return tuple(sorted(common))


@dataclass(frozen=True)
class PencilMember:
    parameter: Element
    z: Element
    grs: bool
    code: FqMatrix
    shortened: dict[Support, tuple[FqVector, FqVector]]
    colors: dict[tuple[int, int, Support, Support], tuple[int, ...]]
    stabilizer: FpMatrix
    projective_canonical: tuple[FqVector, ...]


@dataclass
class CensusCaches:
    symplectic_roots: dict[
        tuple[tuple[int, ...], ...], tuple[FpMatrix, ...]
    ]
    symplectic_test: dict[FpMatrix, bool]
    semilinear_test: dict[FpMatrix, tuple[int, ...]]


def cached_is_symplectic(
    field: FiniteField, matrix: FpMatrix, caches: CensusCaches
) -> bool:
    if matrix not in caches.symplectic_test:
        caches.symplectic_test[matrix] = is_symplectic(field, matrix)
    return caches.symplectic_test[matrix]


def symplectic_roots(
    field: FiniteField,
    basis: tuple[tuple[int, ...], ...],
    caches: CensusCaches,
) -> tuple[FpMatrix, ...]:
    if basis not in caches.symplectic_roots:
        size = 2 * field.degree
        caches.symplectic_roots[basis] = tuple(
            matrix
            for vector in vector_combinations(field.p, basis)
            if is_symplectic(
                field, (matrix := matrix_from_vector(vector, size))
            )
        )
    return caches.symplectic_roots[basis]


def cached_block_semilinear_exponents(
    field: FiniteField,
    blocks: tuple[FpMatrix, ...],
    caches: CensusCaches,
) -> tuple[tuple[int, ...], ...]:
    result = []
    for block in blocks:
        if block not in caches.semilinear_test:
            caches.semilinear_test[block] = semilinear_exponents(field, block)
        result.append(caches.semilinear_test[block])
    return tuple(result)


def fp_commutator(p: int, left: FpMatrix, right: FpMatrix) -> FpMatrix:
    return fp_mul(
        p,
        fp_mul(
            p,
            fp_mul(p, fp_inverse(p, left), fp_inverse(p, right)),
            left,
        ),
        right,
    )


def generated_matrix_group(
    p: int, generators: Iterable[FpMatrix], size: int
) -> set[FpMatrix]:
    identity = fp_identity(size)
    generator_set = set(generators)
    generator_set.update(fp_inverse(p, value) for value in tuple(generator_set))
    group = {identity}
    frontier = [identity]
    while frontier:
        value = frontier.pop()
        for generator in generator_set:
            product = fp_mul(p, value, generator)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def matrix_group_invariants(
    p: int, elements: Sequence[FpMatrix]
) -> dict[str, object]:
    group = set(elements)
    if not group:
        raise AssertionError("empty matrix group")
    size = len(elements[0])
    identity = fp_identity(size)
    if identity not in group:
        raise AssertionError("matrix group lacks the identity")
    for left in group:
        if fp_inverse(p, left) not in group:
            raise AssertionError("matrix set is not inverse closed")
        for right in group:
            if fp_mul(p, left, right) not in group:
                raise AssertionError("matrix set is not multiplication closed")

    def element_order(value: FpMatrix, bound: int) -> int:
        power = identity
        for order in range(1, bound + 1):
            power = fp_mul(p, power, value)
            if power == identity:
                return order
        raise AssertionError("element order exceeds group order")

    order_histogram = Counter(
        element_order(value, len(group)) for value in group
    )
    center = {
        value
        for value in group
        if all(
            fp_mul(p, value, other) == fp_mul(p, other, value)
            for other in group
        )
    }
    commutators = {
        fp_commutator(p, left, right)
        for left in group
        for right in group
    }
    derived = generated_matrix_group(p, commutators, size)
    if not derived.issubset(group):
        raise AssertionError("derived subgroup escaped the kernel")
    derived_center = {
        value
        for value in derived
        if all(
            fp_mul(p, value, other) == fp_mul(p, other, value)
            for other in derived
        )
    }
    derived_histogram = Counter(
        element_order(value, len(derived)) for value in derived
    )
    quotient_cosets: set[frozenset[FpMatrix]] = set()
    quotient_histogram: Counter[int] = Counter()
    quotient_representatives: dict[frozenset[FpMatrix], FpMatrix] = {}
    for value in group:
        coset = frozenset(fp_mul(p, value, central) for central in center)
        if coset in quotient_cosets:
            continue
        quotient_cosets.add(coset)
        quotient_representatives[coset] = value
        power = identity
        for order in range(1, len(group) // len(center) + 1):
            power = fp_mul(p, power, value)
            if power in center:
                quotient_histogram[order] += 1
                break
        else:
            raise AssertionError("center-quotient element order is too large")

    center_coset = frozenset(center)

    def quotient_coset(value: FpMatrix) -> frozenset[FpMatrix]:
        return frozenset(
            fp_mul(p, value, central) for central in center
        )

    order_three_subgroups: set[
        frozenset[frozenset[FpMatrix]]
    ] = set()
    for coset, representative in quotient_representatives.items():
        if coset == center_coset:
            continue
        square_coset = quotient_coset(
            fp_mul(p, representative, representative)
        )
        cube_coset = quotient_coset(
            fp_mul(
                p,
                fp_mul(p, representative, representative),
                representative,
            )
        )
        if cube_coset == center_coset:
            order_three_subgroups.add(
                frozenset((center_coset, coset, square_coset))
            )
    conjugation_kernel = 0
    for value in group:
        inverse = fp_inverse(p, value)
        fixes_all = True
        for subgroup in order_three_subgroups:
            image = frozenset(
                quotient_coset(
                    fp_mul(
                        p,
                        fp_mul(
                            p,
                            value,
                            quotient_representatives[coset],
                        ),
                        inverse,
                    )
                )
                for coset in subgroup
            )
            if image != subgroup:
                fixes_all = False
                break
        if fixes_all:
            conjugation_kernel += 1

    recognition = None
    if (
        len(group) == 96
        and len(center) == 4
        and Counter(element_order(value, 4) for value in center)
        == Counter({4: 2, 1: 1, 2: 1})
        and len(derived) == 24
        and len(derived_center) == 2
        and derived_histogram
        == Counter({3: 8, 6: 8, 4: 6, 1: 1, 2: 1})
        and quotient_histogram
        == Counter({2: 9, 3: 8, 4: 6, 1: 1})
        and len(order_three_subgroups) == 4
        and conjugation_kernel == len(center)
    ):
        recognition = (
            "central C4-extension of S4 with commutator subgroup SL2(3)"
        )

    return {
        "verified_group_order": len(group),
        "center_order": len(center),
        "derived_subgroup_order": len(derived),
        "element_order_histogram": {
            str(key): value for key, value in sorted(order_histogram.items())
        },
        "derived_center_order": len(derived_center),
        "derived_element_order_histogram": {
            str(key): value
            for key, value in sorted(derived_histogram.items())
        },
        "center_quotient_order": len(quotient_cosets),
        "center_quotient_element_order_histogram": {
            str(key): value
            for key, value in sorted(quotient_histogram.items())
        },
        "center_quotient_order_three_subgroups": len(
            order_three_subgroups
        ),
        "order_three_conjugation_kernel_order": conjugation_kernel,
        "recognized_structure": recognition,
    }


def symplectic_group_order(p: int, half_dimension: int) -> int:
    return p ** (half_dimension * half_dimension) * (
        __import__("math").prod(
            p ** (2 * index) - 1
            for index in range(1, half_dimension + 1)
        )
    )


def first_nonsemilinear_transvection(field: FiniteField) -> FpMatrix:
    size = 2 * field.degree
    identity = fp_identity(size)
    form = symplectic_form(field)
    for vector in itertools.product(range(field.p), repeat=size):
        if not any(vector):
            continue
        covector = tuple(
            sum(vector[row] * form[row][column] for row in range(size))
            % field.p
            for column in range(size)
        )
        for scalar in range(1, field.p):
            matrix = tuple(
                tuple(
                    (
                        identity[row][column]
                        + scalar * vector[row] * covector[column]
                    )
                    % field.p
                    for column in range(size)
                )
                for row in range(size)
            )
            if (
                is_symplectic(field, matrix)
                and not semilinear_exponents(field, matrix)
            ):
                return matrix
    raise AssertionError("no nonsemilinear symplectic transvection found")


def frobenius_matrix(
    field: FiniteField, exponent: int
) -> FpMatrix:
    return tuple(
        tuple(
            field.frobenius(field.basis[column], exponent)[row]
            for column in range(field.degree)
        )
        for row in range(field.degree)
    )


def frobenius_sector_basis(
    field: FiniteField, exponent: int
) -> tuple[tuple[int, ...], ...]:
    e = field.degree
    size = 2 * e
    twist = frobenius_matrix(field, exponent)
    basis_vectors = []
    for output_coordinate in range(2):
        for input_coordinate in range(2):
            for scalar in field.basis:
                coefficient = multiplication_matrix(field, scalar)
                block = fp_mul(field.p, coefficient, twist)
                matrix = [
                    [0] * size for _ in range(size)
                ]
                for row in range(e):
                    for column in range(e):
                        matrix[
                            output_coordinate * e + row
                        ][input_coordinate * e + column] = block[row][column]
                basis_vectors.append(
                    tuple(
                        matrix[row][column]
                        for row in range(size)
                        for column in range(size)
                    )
                )
    return tuple(basis_vectors)


def frobenius_sector_profile(
    field: FiniteField, constraints: Sequence[Sequence[int]]
) -> list[dict[str, object]]:
    profiles = []
    labels = ("xx", "xz", "zx", "zz")
    for exponent in range(field.degree):
        sector_basis = frobenius_sector_basis(field, exponent)
        restricted_rows = tuple(
            tuple(
                sum(
                    row[column] * basis_vector[column]
                    for column in range(len(row))
                )
                % field.p
                for basis_vector in sector_basis
            )
            for row in constraints
        )
        solutions = fp_nullspace(
            field.p, restricted_rows, len(sector_basis)
        )
        active = []
        for coefficient_index, label in enumerate(labels):
            start = coefficient_index * field.degree
            stop = start + field.degree
            if any(
                any(vector[index] for index in range(start, stop))
                for vector in solutions
            ):
                active.append(label)
        profiles.append(
            {
                "frobenius_exponent": exponent,
                "dimension_over_prime_field": len(solutions),
                "active_matrix_coefficients": active,
            }
        )
    return profiles


def twisted_gale_divisor(
    field: FiniteField, parameter: Element, exponent: int
) -> Element:
    conjugate = field.frobenius(parameter, exponent)
    product = field.mul(
        field.sub(field.one, conjugate),
        field.sub(field.one, parameter),
    )
    return field.add(
        field.mul(product, product),
        field.mul(conjugate, parameter),
    )


def twisted_diagonal_divisor(
    field: FiniteField, parameter: Element, exponent: int
) -> Element:
    conjugate = field.frobenius(parameter, exponent)
    return field.mul(
        field.sub(conjugate, parameter),
        field.sub(
            field.one, field.mul(conjugate, parameter)
        ),
    )


def parameter_y(field: FiniteField, parameter: Element) -> Element:
    numerator = field.mul(
        field.sub(parameter, field.one),
        field.sub(parameter, field.one),
    )
    return field.div(numerator, parameter)


def parameter_z(field: FiniteField, parameter: Element) -> Element:
    y = parameter_y(field, parameter)
    difference = field.sub(y, field.inv(y))
    return field.div(
        field.mul(difference, difference),
        field.element(16),
    )


def pencil_members(field: FiniteField) -> tuple[PencilMember, ...]:
    members = []
    quartic = (1, -4, 7, -4, 1)
    for parameter in field.elements():
        arc_and_coordinate_factors = (
            parameter,
            field.sub(parameter, field.one),
            field.add(
                field.sub(field.mul(parameter, parameter), parameter),
                field.one,
            ),
            field.add(
                field.sub(field.mul(parameter, parameter), field.mul(field.element(3), parameter)),
                field.one,
            ),
        )
        if any(
            factor == field.zero
            for factor in arc_and_coordinate_factors
        ):
            continue
        grs = field.eval(quartic, parameter) == field.zero
        points = pencil_points(field, parameter)
        if not all(
            determinant3(field, tuple(points[index] for index in triple))
            != field.zero
            for triple in itertools.combinations(range(N), 3)
        ):
            raise AssertionError("admitted formula produced a non-arc")
        code = code_from_points(field, points)
        data = shortened_data(field, code)
        members.append(
            PencilMember(
                parameter=parameter,
                z=parameter_z(field, parameter),
                grs=grs,
                code=code,
                shortened=data,
                colors=edge_colors(field, data),
                stabilizer=stabilizer_fp_basis(field, code),
                projective_canonical=canonical_arc(field, points),
            )
        )
    return tuple(members)


def encode_element(value: Element) -> int | list[int]:
    return value[0] if len(value) == 1 else list(value)


def encode_matrix(matrix: FpMatrix) -> list[list[int]]:
    return [list(row) for row in matrix]


def equivalence_data(
    field: FiniteField,
    source: PencilMember,
    target: PencilMember,
    caches: CensusCaches,
) -> dict[str, object]:
    size = 2 * field.degree
    candidate_count = 0
    solution_permutations = 0
    witness_count = 0
    semilinear_count = 0
    individually_semilinear_count = 0
    genuinely_nonsemilinear_count = 0
    exponent_histogram: Counter[int] = Counter()
    first_witness = None
    first_nonsemilinear = None
    maximum_linear_dimension = 0
    for permutation in candidate_permutations(source.colors, target.colors):
        candidate_count += 1
        left, right, constraints = propagation_data(
            field, source.shortened, target.shortened, permutation
        )
        basis = fp_nullspace(field.p, constraints, size * size)
        maximum_linear_dimension = max(maximum_linear_dimension, len(basis))
        permutation_witnesses = 0
        for root in symplectic_roots(field, basis, caches):
            blocks = local_blocks(field.p, root, left, right, permutation)
            if not all(
                cached_is_symplectic(field, blocks[party], caches)
                for party in range(N)
                if party != permutation[0]
            ):
                continue
            if permutation_witnesses == 0:
                if (
                    apply_local_map(
                        field, source.stabilizer, blocks, permutation
                    )
                    != target.stabilizer
                ):
                    raise AssertionError(
                        "shortened-plane solution failed full Lagrangian replay"
                    )
            permutation_witnesses += 1
            witness_count += 1
            block_exponents = cached_block_semilinear_exponents(
                field, blocks, caches
            )
            exponents = tuple(
                sorted(set.intersection(*(set(item) for item in block_exponents)))
            )
            if exponents:
                semilinear_count += 1
                for exponent in exponents:
                    exponent_histogram[exponent] += 1
            if all(block_exponents):
                individually_semilinear_count += 1
            else:
                genuinely_nonsemilinear_count += 1
            if not exponents and first_nonsemilinear is None:
                first_nonsemilinear = {
                    "permutation": list(permutation),
                    "root_block": encode_matrix(root),
                    "block_frobenius_exponents": [
                        list(item) for item in block_exponents
                    ],
                    "has_genuinely_nonsemilinear_block": not all(
                        block_exponents
                    ),
                }
            if first_witness is None:
                first_witness = {
                    "permutation": list(permutation),
                    "root_block": encode_matrix(root),
                    "common_frobenius_exponents": list(exponents),
                }
        if permutation_witnesses:
            solution_permutations += 1
    return {
        "candidate_permutations_after_edge_filter": candidate_count,
        "solution_permutations": solution_permutations,
        "symplectic_witnesses": witness_count,
        "semilinear_witnesses": semilinear_count,
        "individually_semilinear_witnesses": individually_semilinear_count,
        "genuinely_nonsemilinear_witnesses": genuinely_nonsemilinear_count,
        "common_frobenius_exponent_histogram": {
            str(key): value for key, value in sorted(exponent_histogram.items())
        },
        "maximum_intertwiner_space_dimension_over_prime_field": maximum_linear_dimension,
        "first_witness": first_witness,
        "first_nonsemilinear_witness": first_nonsemilinear,
    }


class DisjointSet:
    def __init__(self, size: int) -> None:
        self.parent = list(range(size))

    def find(self, value: int) -> int:
        while self.parent[value] != value:
            self.parent[value] = self.parent[self.parent[value]]
            value = self.parent[value]
        return value

    def union(self, left: int, right: int) -> None:
        left_root, right_root = self.find(left), self.find(right)
        if left_root != right_root:
            self.parent[right_root] = left_root

    def classes(self) -> list[list[int]]:
        buckets: dict[int, list[int]] = {}
        for value in range(len(self.parent)):
            buckets.setdefault(self.find(value), []).append(value)
        return sorted(buckets.values())


def geometric_galois_classes(
    field: FiniteField, members: Sequence[PencilMember]
) -> list[list[int]]:
    classes = DisjointSet(len(members))
    for left, source in enumerate(members):
        if source.grs:
            for right, target in enumerate(members):
                if target.grs:
                    classes.union(left, right)
            continue
        orbit = {
            field.frobenius(source.z, exponent)
            for exponent in range(field.degree)
        }
        for right, target in enumerate(members):
            if not target.grs and target.z in orbit:
                classes.union(left, right)
    return classes.classes()


def field_census(field: FiniteField) -> dict[str, object]:
    members = pencil_members(field)
    caches = CensusCaches({}, {}, {})
    equivalences: dict[tuple[int, int], dict[str, object]] = {}
    local_classes = DisjointSet(len(members))
    grs_indices = [
        index for index, member in enumerate(members) if member.grs
    ]
    for index in grs_indices[1:]:
        local_classes.union(grs_indices[0], index)
    nonsemilinear_edges = []
    total_candidate_permutations = 0
    total_witnesses = 0
    for left in range(len(members)):
        for right in range(left, len(members)):
            if members[left].grs or members[right].grs:
                continue
            data = equivalence_data(
                field, members[left], members[right], caches
            )
            equivalences[(left, right)] = data
            total_candidate_permutations += int(
                data["candidate_permutations_after_edge_filter"]
            )
            total_witnesses += int(data["symplectic_witnesses"])
            if data["symplectic_witnesses"]:
                local_classes.union(left, right)
            if data["first_nonsemilinear_witness"] is not None:
                nonsemilinear_edges.append(
                    {
                        "source_index": left,
                        "target_index": right,
                        "witness": data["first_nonsemilinear_witness"],
                    }
                )

    lc_classes = local_classes.classes()
    predicted = geometric_galois_classes(field, members)
    projective_partition = DisjointSet(len(members))
    for left, source in enumerate(members):
        for right, target in enumerate(members):
            if (
                source.projective_canonical
                == target.projective_canonical
            ):
                projective_partition.union(left, right)
    projective_classes = projective_partition.classes()
    predicted_class_of = {
        index: class_index
        for class_index, values in enumerate(predicted)
        for index in values
    }
    if any(
        len({predicted_class_of[index] for index in values}) != 1
        for values in projective_classes
    ):
        raise AssertionError(
            "projective classes do not refine the geometric/Galois partition"
        )
    if lc_classes != predicted:
        comparison = "different"
    else:
        comparison = "equal"

    fixed_party_kernels = []
    identity_permutation = tuple(range(N))
    for index, member in enumerate(members):
        left, right, constraints = propagation_data(
            field,
            member.shortened,
            member.shortened,
            identity_permutation,
        )
        basis = fp_nullspace(
            field.p, constraints, (2 * field.degree) ** 2
        )
        sector_profile = frobenius_sector_profile(
            field, constraints
        )
        for profile in sector_profile:
            exponent = int(profile["frobenius_exponent"])
            divisor = twisted_gale_divisor(
                field, member.parameter, exponent
            )
            profile["twisted_gale_divisor"] = encode_element(divisor)
            diagonal_divisor = twisted_diagonal_divisor(
                field, member.parameter, exponent
            )
            profile["twisted_diagonal_divisor"] = encode_element(
                diagonal_divisor
            )
            off_diagonal_active = any(
                coefficient in profile["active_matrix_coefficients"]
                for coefficient in ("xz", "zx")
            )
            diagonal_active = any(
                coefficient in profile["active_matrix_coefficients"]
                for coefficient in ("xx", "zz")
            )
            if off_diagonal_active != (divisor == field.zero):
                raise AssertionError(
                    "twisted Gale divisor and off-diagonal sector disagree"
                )
            if diagonal_active != (diagonal_divisor == field.zero):
                raise AssertionError(
                    "twisted diagonal divisor and diagonal sector disagree"
                )
        if sum(
            int(profile["dimension_over_prime_field"])
            for profile in sector_profile
        ) != len(basis):
            raise AssertionError(
                "Frobenius sectors do not sum to the intertwiner dimension"
            )
        count = 0
        semilinear = 0
        individually_semilinear = 0
        genuinely_nonsemilinear = 0
        exponent_histogram: Counter[int] = Counter()
        kernel_roots = []
        first_genuine_root = None
        if len(basis) == (2 * field.degree) ** 2:
            root = first_nonsemilinear_transvection(field)
            blocks = local_blocks(
                field.p, root, left, right, identity_permutation
            )
            if (
                not all(is_symplectic(field, block) for block in blocks)
                or apply_local_map(
                    field,
                    member.stabilizer,
                    blocks,
                    identity_permutation,
                )
                != member.stabilizer
            ):
                raise AssertionError(
                    "full symplectic-kernel shortcut failed direct replay"
                )
            order = symplectic_group_order(field.p, field.degree)
            semilinear_order = (
                field.degree * field.order * (field.order**2 - 1)
            )
            fixed_party_kernels.append(
                {
                    "parameter_index": index,
                    "intertwiner_space_dimension_over_prime_field": len(basis),
                    "frobenius_sector_profile": sector_profile,
                    "structure": f"Sp_{2 * field.degree}({field.p})",
                    "order": order,
                    "semilinear_elements": semilinear_order,
                    "individually_semilinear_elements": semilinear_order,
                    "genuinely_nonsemilinear_elements": order
                    - semilinear_order,
                    "common_frobenius_exponent_histogram": {
                        str(exponent): field.order
                        * (field.order**2 - 1)
                        for exponent in range(field.degree)
                    },
                    "first_genuinely_nonsemilinear_root_block": encode_matrix(
                        root
                    ),
                    "group_invariants": {
                        "verified_group_order": order,
                        "center_order": 2 if field.p % 2 else 1,
                        "derived_subgroup_order": order,
                        "identification_basis": (
                            "the intertwiner nullspace is the full endomorphism "
                            "algebra; its symplectic units are the full group"
                        ),
                    },
                }
            )
            continue
        for root in symplectic_roots(field, basis, caches):
            blocks = local_blocks(
                field.p, root, left, right, identity_permutation
            )
            if not all(
                cached_is_symplectic(field, blocks[party], caches)
                for party in range(1, N)
            ):
                continue
            if count == 0:
                if (
                    apply_local_map(
                        field,
                        member.stabilizer,
                        blocks,
                        identity_permutation,
                    )
                    != member.stabilizer
                ):
                    raise AssertionError("fixed kernel failed full replay")
            count += 1
            kernel_roots.append(root)
            block_exponents = cached_block_semilinear_exponents(
                field, blocks, caches
            )
            exponents = tuple(
                sorted(set.intersection(*(set(item) for item in block_exponents)))
            )
            if exponents:
                semilinear += 1
                for exponent in exponents:
                    exponent_histogram[exponent] += 1
            if all(block_exponents):
                individually_semilinear += 1
            else:
                genuinely_nonsemilinear += 1
                if first_genuine_root is None:
                    first_genuine_root = root
        fixed_party_kernels.append(
            {
                "parameter_index": index,
                "intertwiner_space_dimension_over_prime_field": len(basis),
                "frobenius_sector_profile": sector_profile,
                "order": count,
                "semilinear_elements": semilinear,
                "individually_semilinear_elements": individually_semilinear,
                "genuinely_nonsemilinear_elements": genuinely_nonsemilinear,
                "first_genuinely_nonsemilinear_root_block": (
                    encode_matrix(first_genuine_root)
                    if first_genuine_root is not None
                    else None
                ),
                "common_frobenius_exponent_histogram": {
                    str(key): value
                    for key, value in sorted(exponent_histogram.items())
                },
                "group_invariants": matrix_group_invariants(
                    field.p, kernel_roots
                ),
            }
        )

    grs_kernel_orders = {
        fixed_party_kernels[index]["order"] for index in grs_indices
    }
    nongrs_kernel_orders = {
        fixed_party_kernels[index]["order"]
        for index, member in enumerate(members)
        if not member.grs
    }
    if grs_kernel_orders.intersection(nongrs_kernel_orders):
        raise AssertionError(
            "kernel-order gate does not separate GRS and non-GRS loci"
        )

    pair_rows = []
    for (left, right), data in equivalences.items():
        if data["symplectic_witnesses"] or left == right:
            pair_rows.append(
                {
                    "source_index": left,
                    "target_index": right,
                    **data,
                }
            )

    return {
        "field": {
            "p": field.p,
            "degree": field.degree,
            "order": field.order,
            "modulus_low_to_high": list(field.modulus),
        },
        "pencil_parameter_count": len(members),
        "admitted_non_grs_parameter_count": sum(
            not member.grs for member in members
        ),
        "grs_parameter_count": sum(member.grs for member in members),
        "parameters": [
            {
                "index": index,
                "t": encode_element(member.parameter),
                "z": encode_element(member.z),
                "locus": "grs" if member.grs else "non-grs",
            }
            for index, member in enumerate(members)
        ],
        "local_clifford_orbits": lc_classes,
        "projective_orbits": projective_classes,
        "geometric_galois_orbits": predicted,
        "lc_vs_geometric_galois": comparison,
        "fixed_party_kernels": fixed_party_kernels,
        "equivalent_pairs": pair_rows,
        "nonsemilinear_edge_witnesses": nonsemilinear_edges,
        "totals": {
            "all_unordered_parameter_pairs": len(members)
            * (len(members) + 1)
            // 2,
            "non_grs_unordered_parameter_pairs_exhaustively_checked": sum(
                not member.grs for member in members
            )
            * (
                sum(not member.grs for member in members)
                + 1
            )
            // 2,
            "candidate_permutations_after_edge_filter": total_candidate_permutations,
            "symplectic_witnesses": total_witnesses,
        },
    }


def build_certificate() -> dict[str, object]:
    results = [field_census(field) for field in FIELDS]
    return {
        "schema": "c623-extension-field-clifford-v2",
        "scope": {
            "fields": [9, 25, 27],
            "family": (
                "full six-arc pencil with nondegenerate quotient coordinates, "
                "including the GRS boundary when present"
            ),
            "equivalence": (
                "party permutations and sitewise Sp(2e,p), checked on the "
                "full additive CSS stabilizer Lagrangian"
            ),
            "fixed_party_kernel": (
                "identity party permutation; image on party zero, uniquely "
                "propagated through shortened planes"
            ),
        },
        "method": {
            "candidate_filter": (
                "prime-field conjugacy traces of pair-support holonomies"
            ),
            "complete_gate": (
                "all 720 party permutations surviving only a necessary filter "
                "are exhausted coefficientwise on the non-GRS locus; the GRS "
                "class is certified by independent projective normalization "
                "and separated from non-GRS classes by exact kernel order"
            ),
            "independent_replay": (
                "the first accepted witness for every solution permutation "
                "maps the full prime-field-expanded stabilizer rowspace exactly"
            ),
            "frobenius_sector_gate": (
                "the fixed-party intertwiner nullspace is independently "
                "decomposed into linearized-polynomial Frobenius sectors"
            ),
            "exact_sector_divisors": (
                "diagonal coefficients are checked against "
                "(t^(p^k)-t)(1-t^(p^k+1)); off-diagonal coefficients are "
                "checked against ((1-t^(p^k))(1-t))^2+t^(p^k+1)"
            ),
        },
        "results": results,
        "conclusion": {
            "all_lc_orbits_equal_geometric_galois_orbits": all(
                result["lc_vs_geometric_galois"] == "equal"
                for result in results
            ),
            "any_nonsemilinear_identification": any(
                result["nonsemilinear_edge_witnesses"]
                or any(
                    kernel["genuinely_nonsemilinear_elements"]
                    for kernel in result["fixed_party_kernels"]
                )
                for result in results
            ),
        },
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="recompute and compare with the tracked certificate",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=CERTIFICATE,
        help="certificate path for generation",
    )
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.check:
        expected = CERTIFICATE.read_bytes()
        if payload != expected:
            raise SystemExit(
                "certificate mismatch: "
                f"computed={hashlib.sha256(payload).hexdigest()} "
                f"tracked={hashlib.sha256(expected).hexdigest()}"
            )
        print(
            "C623 certificate verified: "
            f"{len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}"
        )
        return
    args.output.write_bytes(payload)
    print(
        f"wrote {args.output}: {len(payload)} bytes "
        f"sha256={hashlib.sha256(payload).hexdigest()}"
    )


if __name__ == "__main__":
    main()
