#!/usr/bin/env python3
"""Exhaustive small-q uniqueness check for conic-filling uncovered loci.

For every prime power q <= 14, this standalone standard-library checker
enumerates every frame-normalized embedded six-arc containing

    e1, e2, e3, (1,1,1).

Every six-arc contains an ordered projective frame, and PGL(3,q) is sharply
transitive on ordered frames, so this normalization meets every PGL class.
The final two points are enumerated as an unordered pair, avoiding duplicate
representatives inside the normalized census.

For each arc A the checker computes U(A), the points off all secants, and asks
whether U(A) is *equal* to the full rational point set of a nonsingular conic.
The nonsingularity test uses the radical of the formal-gradient matrix and is
valid in characteristic two as well as odd characteristic.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, product


EXPECTED_EXTENSION_TABLES = {
    4: {
        "add": [
            [0, 1, 2, 3],
            [1, 0, 3, 2],
            [2, 3, 0, 1],
            [3, 2, 1, 0],
        ],
        "mul": [
            [0, 0, 0, 0],
            [0, 1, 2, 3],
            [0, 2, 3, 1],
            [0, 3, 1, 2],
        ],
        "inv": [None, 1, 3, 2],
    },
    8: {
        "add": [
            [0, 1, 2, 3, 4, 5, 6, 7],
            [1, 0, 3, 2, 5, 4, 7, 6],
            [2, 3, 0, 1, 6, 7, 4, 5],
            [3, 2, 1, 0, 7, 6, 5, 4],
            [4, 5, 6, 7, 0, 1, 2, 3],
            [5, 4, 7, 6, 1, 0, 3, 2],
            [6, 7, 4, 5, 2, 3, 0, 1],
            [7, 6, 5, 4, 3, 2, 1, 0],
        ],
        "mul": [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 1, 2, 3, 4, 5, 6, 7],
            [0, 2, 4, 6, 3, 1, 7, 5],
            [0, 3, 6, 5, 7, 4, 1, 2],
            [0, 4, 3, 7, 6, 2, 5, 1],
            [0, 5, 1, 4, 2, 7, 3, 6],
            [0, 6, 7, 1, 5, 3, 2, 4],
            [0, 7, 5, 2, 1, 6, 4, 3],
        ],
        "inv": [None, 1, 5, 6, 7, 2, 3, 4],
    },
    9: {
        "add": [
            [0, 1, 2, 3, 4, 5, 6, 7, 8],
            [1, 2, 0, 4, 5, 3, 7, 8, 6],
            [2, 0, 1, 5, 3, 4, 8, 6, 7],
            [3, 4, 5, 6, 7, 8, 0, 1, 2],
            [4, 5, 3, 7, 8, 6, 1, 2, 0],
            [5, 3, 4, 8, 6, 7, 2, 0, 1],
            [6, 7, 8, 0, 1, 2, 3, 4, 5],
            [7, 8, 6, 1, 2, 0, 4, 5, 3],
            [8, 6, 7, 2, 0, 1, 5, 3, 4],
        ],
        "mul": [
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 1, 2, 3, 4, 5, 6, 7, 8],
            [0, 2, 1, 6, 8, 7, 3, 5, 4],
            [0, 3, 6, 2, 5, 8, 1, 4, 7],
            [0, 4, 8, 5, 6, 1, 7, 2, 3],
            [0, 5, 7, 8, 1, 3, 4, 6, 2],
            [0, 6, 3, 1, 7, 4, 2, 8, 5],
            [0, 7, 5, 4, 2, 6, 8, 3, 1],
            [0, 8, 4, 7, 3, 2, 5, 1, 6],
        ],
        "inv": [None, 1, 2, 6, 5, 4, 3, 8, 7],
    },
}


FIELD_SPECS = {
    2: (2, 1, (0, 1)),
    3: (3, 1, (0, 1)),
    4: (2, 2, (1, 1, 1)),       # x^2 + x + 1
    5: (5, 1, (0, 1)),
    7: (7, 1, (0, 1)),
    8: (2, 3, (1, 1, 0, 1)),    # x^3 + x + 1
    9: (3, 2, (1, 0, 1)),       # x^2 + 1
    11: (11, 1, (0, 1)),
    13: (13, 1, (0, 1)),
}


EXPECTED_CENSUS = {
    2: (0, {}),
    3: (0, {}),
    # q=4 and q=5 are asserted after the same exhaustive enumeration below;
    # their literal values are part of the final output contract.
    4: (1, {0: 1}),
    5: (3, {0: 3}),
    7: (70, {0: 40, 2: 30}),
    8: (195, {0: 45, 4: 150}),
    9: (441, {0: 6, 4: 15, 6: 120, 7: 120, 8: 180}),
    11: (1548, {12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72}),
    13: (4015, {36: 85, 38: 210, 39: 480, 40: 1080, 41: 1800, 42: 360}),
}


class Field:
    def __init__(self, p: int, degree: int, modulus: tuple[int, ...]):
        self.p = p
        self.degree = degree
        self.q = p**degree
        assert len(modulus) == degree + 1 and modulus[-1] % p == 1
        self.modulus = tuple(x % p for x in modulus)
        self.add_table = [
            [self._add_raw(a, b) for b in range(self.q)] for a in range(self.q)
        ]
        self.mul_table = [
            [self._mul_raw(a, b) for b in range(self.q)] for a in range(self.q)
        ]
        self.neg_table = [
            next(b for b in range(self.q) if self.add_table[a][b] == 0)
            for a in range(self.q)
        ]
        self.inv_table: list[int | None] = [None] + [
            next(b for b in range(1, self.q) if self.mul_table[a][b] == 1)
            for a in range(1, self.q)
        ]
        self._assert_field_tables()

    def _digits(self, value: int) -> list[int]:
        digits = []
        for _ in range(self.degree):
            digits.append(value % self.p)
            value //= self.p
        return digits

    def _encode(self, digits: list[int]) -> int:
        return sum((digit % self.p) * self.p**i for i, digit in enumerate(digits))

    def _add_raw(self, a: int, b: int) -> int:
        return self._encode(
            [(x + y) % self.p for x, y in zip(self._digits(a), self._digits(b))]
        )

    def _mul_raw(self, a: int, b: int) -> int:
        left = self._digits(a)
        right = self._digits(b)
        coefficients = [0] * (2 * self.degree - 1)
        for i, x in enumerate(left):
            for j, y in enumerate(right):
                coefficients[i + j] = (coefficients[i + j] + x * y) % self.p
        for power in range(2 * self.degree - 2, self.degree - 1, -1):
            coefficient = coefficients[power] % self.p
            for i in range(self.degree):
                coefficients[power - self.degree + i] = (
                    coefficients[power - self.degree + i]
                    - coefficient * self.modulus[i]
                ) % self.p
        return self._encode(coefficients[: self.degree])

    def _assert_field_tables(self) -> None:
        elements = range(self.q)
        assert all(self.add(a, 0) == a and self.mul(a, 1) == a for a in elements)
        assert all(self.mul(a, 0) == 0 for a in elements)
        assert all(
            self.add(a, b) == self.add(b, a) and self.mul(a, b) == self.mul(b, a)
            for a in elements
            for b in elements
        )
        assert all(self.add(a, self.neg(a)) == 0 for a in elements)
        assert all(
            self.add(self.add(a, b), c) == self.add(a, self.add(b, c))
            for a in elements
            for b in elements
            for c in elements
        )
        assert all(
            self.mul(a, self.add(b, c))
            == self.add(self.mul(a, b), self.mul(a, c))
            for a in elements
            for b in elements
            for c in elements
        )
        assert all(
            self.mul(self.mul(a, b), c) == self.mul(a, self.mul(b, c))
            for a in elements
            for b in elements
            for c in elements
        )
        assert all(
            self.mul(a, int(self.inv_table[a])) == 1 for a in range(1, self.q)
        )
        if self.q in EXPECTED_EXTENSION_TABLES:
            expected = EXPECTED_EXTENSION_TABLES[self.q]
            assert self.add_table == expected["add"]
            assert self.mul_table == expected["mul"]
            assert self.inv_table == expected["inv"]

    def add(self, a: int, b: int) -> int:
        return self.add_table[a][b]

    def neg(self, a: int) -> int:
        return self.neg_table[a]

    def sub(self, a: int, b: int) -> int:
        return self.add(a, self.neg(b))

    def mul(self, a: int, b: int) -> int:
        return self.mul_table[a][b]

    def inv(self, a: int) -> int:
        result = self.inv_table[a]
        assert result is not None
        return result

    def div(self, a: int, b: int) -> int:
        return self.mul(a, self.inv(b))


Point = tuple[int, int, int]


def projective_points(field: Field) -> list[Point]:
    points = (
        [(1, y, z) for y, z in product(range(field.q), repeat=2)]
        + [(0, 1, z) for z in range(field.q)]
        + [(0, 0, 1)]
    )
    assert len(points) == field.q * field.q + field.q + 1
    assert len(set(points)) == len(points)
    return points


def determinant(field: Field, a: Point, b: Point, c: Point) -> int:
    positive = field.add(
        field.add(
            field.mul(a[0], field.mul(b[1], c[2])),
            field.mul(a[1], field.mul(b[2], c[0])),
        ),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(
            field.mul(a[2], field.mul(b[1], c[0])),
            field.mul(a[1], field.mul(b[0], c[2])),
        ),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def rref(
    field: Field, rows: list[list[int]], column_count: int
) -> tuple[list[list[int]], list[int]]:
    matrix = [[entry for entry in row] for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column] != 0),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(scale, x) for x in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            coefficient = matrix[row][column]
            matrix[row] = [
                field.sub(x, field.mul(coefficient, y))
                for x, y in zip(matrix[row], matrix[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix, pivots


def nullspace(field: Field, rows: list[list[int]], column_count: int) -> list[tuple[int, ...]]:
    reduced, pivots = rref(field, rows, column_count)
    free_columns = [column for column in range(column_count) if column not in pivots]
    basis = []
    for free in free_columns:
        vector = [0] * column_count
        vector[free] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(reduced[row][free])
        basis.append(tuple(vector))
    return basis


def quadratic_features(field: Field, point: Point) -> tuple[int, ...]:
    x, y, z = point
    return (
        field.mul(x, x),
        field.mul(x, y),
        field.mul(x, z),
        field.mul(y, y),
        field.mul(y, z),
        field.mul(z, z),
    )


def quadratic_value(field: Field, form: tuple[int, ...], point: Point) -> int:
    value = 0
    for coefficient, feature in zip(form, quadratic_features(field, point)):
        value = field.add(value, field.mul(coefficient, feature))
    return value


def nonsingular_quadratic(field: Field, form: tuple[int, ...]) -> bool:
    """Geometric nonsingularity, including the characteristic-two radical case."""
    a, b, c, d, e, f = form
    two = field.add(1, 1)
    gradient_matrix = [
        [field.mul(two, a), b, c],
        [b, field.mul(two, d), e],
        [c, e, field.mul(two, f)],
    ]
    radical = nullspace(field, gradient_matrix, 3)
    if not radical:
        return True
    if len(radical) >= 2:
        # A nonzero homogeneous quadratic in at least two radical variables
        # has a geometric zero, even if that zero is not F_q-rational.
        return False
    # In characteristic two a ternary nonsingular conic has a one-dimensional
    # polar radical on which the quadratic value is nonzero.
    return quadratic_value(field, form, radical[0]) != 0


def canonical_vector(field: Field, vector: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(entry for entry in vector if entry != 0)
    scale = field.inv(pivot)
    return tuple(field.mul(scale, entry) for entry in vector)


def forms_vanishing_on(
    field: Field, point_indices: set[int], points: list[Point]
) -> set[tuple[int, ...]]:
    rows = [list(quadratic_features(field, points[index])) for index in sorted(point_indices)]
    basis = nullspace(field, rows, 6)
    result = set()
    for coefficients in product(range(field.q), repeat=len(basis)):
        if not any(coefficients):
            continue
        vector = [0] * 6
        for scalar, basis_vector in zip(coefficients, basis):
            for i in range(6):
                vector[i] = field.add(vector[i], field.mul(scalar, basis_vector[i]))
        result.add(canonical_vector(field, tuple(vector)))
    return result


def equals_nonsingular_conic(
    field: Field, uncovered: set[int], points: list[Point]
) -> bool:
    if len(uncovered) != field.q + 1:
        return False
    for form in forms_vanishing_on(field, uncovered, points):
        if not nonsingular_quadratic(field, form):
            continue
        zero_locus = {
            index
            for index, point in enumerate(points)
            if quadratic_value(field, form, point) == 0
        }
        if zero_locus == uncovered:
            return True
    return False


def assert_conic_nonsingularity_sanity(field: Field) -> None:
    """Exercise the characteristic-safe classifier on standard exact forms."""
    points = projective_points(field)
    # XZ - Y^2 is nonsingular in every characteristic.  In characteristic
    # two its polar matrix has a one-dimensional radical generated by Y, and
    # the nonzero quadratic value on that radical is the essential test.
    standard_conic = (0, 0, 1, field.neg(1), 0, 0)
    standard_zeros = {
        point for point in points if quadratic_value(field, standard_conic, point) == 0
    }
    assert len(standard_zeros) == field.q + 1
    assert nonsingular_quadratic(field, standard_conic)

    # XY is a pair of distinct lines, while X^2 is a double line.  Both must
    # remain singular under the same classifier, including over F_4 and F_8.
    line_pair = (0, 1, 0, 0, 0, 0)
    double_line = (1, 0, 0, 0, 0, 0)
    assert not nonsingular_quadratic(field, line_pair)
    assert not nonsingular_quadratic(field, double_line)


def line_masks(field: Field, points: list[Point]) -> dict[tuple[int, int], int]:
    masks = {}
    for left, right in combinations(range(len(points)), 2):
        mask = 0
        for index, point in enumerate(points):
            if determinant(field, points[left], points[right], point) == 0:
                mask |= 1 << index
        assert mask.bit_count() == field.q + 1
        masks[(left, right)] = mask
    return masks


def pair_key(left: int, right: int) -> tuple[int, int]:
    return (left, right) if left < right else (right, left)


def enumerate_normalized_arcs(
    field: Field, points: list[Point], lines: dict[tuple[int, int], int]
) -> list[tuple[int, ...]]:
    point_index = {point: index for index, point in enumerate(points)}
    frame = tuple(
        point_index[point]
        for point in ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
    )
    assert len(set(frame)) == 4
    assert all(
        determinant(field, points[a], points[b], points[c]) != 0
        for a, b, c in combinations(frame, 3)
    )

    frame_pair_lines = [lines[pair_key(a, b)] for a, b in combinations(frame, 2)]
    admissible = [
        candidate
        for candidate in range(len(points))
        if candidate not in frame
        and all((line >> candidate) & 1 == 0 for line in frame_pair_lines)
    ]
    arcs = []
    for left, right in combinations(admissible, 2):
        if all(
            (lines[pair_key(frame_point, left)] >> right) & 1 == 0
            for frame_point in frame
        ):
            arc = tuple(sorted(frame + (left, right)))
            assert len(arc) == 6
            assert all(
                determinant(field, points[a], points[b], points[c]) != 0
                for a, b, c in combinations(arc, 3)
            )
            arcs.append(arc)
    assert len(arcs) == len(set(arcs))
    return arcs


def census(field: Field) -> tuple[int, Counter[int], int]:
    points = projective_points(field)
    lines = line_masks(field, points)
    arcs = enumerate_normalized_arcs(field, points, lines)
    full_mask = (1 << len(points)) - 1
    histogram: Counter[int] = Counter()
    conic_matches = 0
    for arc in arcs:
        covered = 0
        for left, right in combinations(arc, 2):
            covered |= lines[pair_key(left, right)]
        uncovered_mask = full_mask ^ covered
        uncovered = {
            index for index in range(len(points)) if (uncovered_mask >> index) & 1
        }
        histogram[len(uncovered)] += 1
        conic_matches += int(equals_nonsingular_conic(field, uncovered, points))
    return len(arcs), histogram, conic_matches


def main() -> None:
    results = {}
    total_matches = 0
    for q in sorted(FIELD_SPECS):
        field = Field(*FIELD_SPECS[q])
        assert_conic_nonsingularity_sanity(field)
        representatives, histogram, conic_matches = census(field)
        expected_representatives, expected_histogram = EXPECTED_CENSUS[q]
        assert representatives == expected_representatives
        assert histogram == Counter(expected_histogram)
        if q == 11:
            assert conic_matches == 6
        else:
            assert conic_matches == 0
        results[q] = (representatives, histogram, conic_matches)
        total_matches += conic_matches
        print(
            f"q={q} normalized_representatives={representatives} "
            f"U_histogram={dict(sorted(histogram.items()))} "
            f"nonsingular_conic_matches={conic_matches}"
        )

    assert total_matches == 6
    assert {q for q, (_, _, matches) in results.items() if matches} == {11}
    print("prime_powers_checked=[2, 3, 4, 5, 7, 8, 9, 11, 13]")
    print("extension_field_tables_asserted=[4, 8, 9]")
    print("conic_nonsingularity_sanity_fields=[2, 3, 4, 5, 7, 8, 9, 11, 13]")
    print("characteristic_two_conic_sanity_fields=[2, 4, 8]")
    print("unique_matching_field=11")
    print("total_normalized_conic_matches=6")
    print("all assertions passed")


if __name__ == "__main__":
    main()
