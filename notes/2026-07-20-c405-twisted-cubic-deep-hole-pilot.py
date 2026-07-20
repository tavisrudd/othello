#!/usr/bin/env python3
"""Exact bounded census for C405's twisted-cubic deepest-syndrome pilot."""

from __future__ import annotations

import argparse
import hashlib
import json
import tempfile
from collections import Counter
from itertools import combinations, permutations, product
from pathlib import Path


STEM = "2026-07-20-c405-twisted-cubic-deep-hole-pilot"
SCHEMA = "c405-twisted-cubic-deep-hole-pilot-v2"
FIELDS = (5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32)
Point2 = tuple[int, int]
Point3 = tuple[int, int, int]
Point4 = tuple[int, int, int, int]
Arc = tuple[Point4, ...]


class FiniteField:
    """Deterministic polynomial-basis models for every prime power in FIELDS."""

    DATA = {
        5: (5, 1, ()),
        7: (7, 1, ()),
        8: (2, 3, (1, 1, 0)),       # x^3+x+1
        9: (3, 2, (1, 0)),          # x^2+1
        11: (11, 1, ()),
        13: (13, 1, ()),
        16: (2, 4, (1, 1, 0, 0)),  # x^4+x+1
        17: (17, 1, ()),
        19: (19, 1, ()),
        23: (23, 1, ()),
        25: (5, 2, (2, 0)),         # x^2+2
        27: (3, 3, (1, 2, 0)),      # x^3+2x+1
        29: (29, 1, ()),
        31: (31, 1, ()),
        32: (2, 5, (1, 0, 1, 0, 0)),  # x^5+x^2+1
    }

    def __init__(self, q: int) -> None:
        self.q = q
        self.p, self.degree, self.modulus = self.DATA[q]
        assert self.p**self.degree == q
        self._add = tuple(tuple(self._add_raw(a, b) for b in range(q)) for a in range(q))
        self._mul = tuple(tuple(self._mul_raw(a, b) for b in range(q)) for a in range(q))
        self._neg = tuple(self._neg_raw(a) for a in range(q))
        self._inv = (0,) + tuple(self.pow(a, q - 2) for a in range(1, q))
        assert all(self.mul(a, self._inv[a]) == 1 for a in range(1, q))

    def coefficients(self, value: int) -> tuple[int, ...]:
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return tuple(answer)

    def encode(self, coefficients: list[int] | tuple[int, ...]) -> int:
        answer = 0
        place = 1
        for coefficient in coefficients[: self.degree]:
            answer += (coefficient % self.p) * place
            place *= self.p
        return answer

    def _add_raw(self, left: int, right: int) -> int:
        return self.encode([a + b for a, b in zip(self.coefficients(left), self.coefficients(right))])

    def add(self, left: int, right: int) -> int:
        return self._add[left][right]

    def _neg_raw(self, value: int) -> int:
        return self.encode([-a for a in self.coefficients(value)])

    def neg(self, value: int) -> int:
        return self._neg[value]

    def sub(self, left: int, right: int) -> int:
        return self._add[left][self._neg[right]]

    def _mul_raw(self, left: int, right: int) -> int:
        if self.degree == 1:
            return left * right % self.p
        a = self.coefficients(left)
        b = self.coefficients(right)
        coefficients = [0] * (2 * self.degree - 1)
        for i, x in enumerate(a):
            for j, y in enumerate(b):
                coefficients[i + j] = (coefficients[i + j] + x * y) % self.p
        for exponent in range(2 * self.degree - 2, self.degree - 1, -1):
            leading = coefficients[exponent] % self.p
            if not leading:
                continue
            shift = exponent - self.degree
            for i, coefficient in enumerate(self.modulus):
                coefficients[shift + i] -= leading * coefficient
        return self.encode(coefficients)

    def mul(self, left: int, right: int) -> int:
        return self._mul[left][right]

    def pow(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self._mul[answer][value]
            value = self._mul[value][value]
            exponent >>= 1
        return answer

    def inverse(self, value: int) -> int:
        assert value
        return self._inv[value]

    def div(self, left: int, right: int) -> int:
        return self._mul[left][self._inv[right]]

    def frobenius(self, value: int, power: int = 1) -> int:
        return self.pow(value, self.p**power)


def normalize(field: FiniteField, vector: tuple[int, ...]) -> tuple[int, ...]:
    scale = field.inverse(next(entry for entry in vector if entry))
    return tuple(field.mul(scale, entry) for entry in vector)


def p1_points(field: FiniteField) -> tuple[Point2, ...]:
    return tuple((x, 1) for x in range(field.q)) + ((1, 0),)


def bracket(field: FiniteField, left: Point2, right: Point2) -> int:
    return field.sub(field.mul(left[0], right[1]), field.mul(left[1], right[0]))


def p1_normalize(field: FiniteField, point: Point2) -> Point2:
    return normalize(field, point)  # type: ignore[return-value]


def mobius_frame(
    field: FiniteField, point: Point2, infinity: Point2, zero: Point2, one: Point2
) -> Point2:
    numerator = field.mul(bracket(field, point, zero), bracket(field, one, infinity))
    denominator = field.mul(bracket(field, point, infinity), bracket(field, one, zero))
    return p1_normalize(field, (numerator, denominator))


def canonical_p1_set(field: FiniteField, points: tuple[Point2, ...]) -> tuple[Point2, ...]:
    images = []
    for power in range(field.degree):
        twisted = tuple((field.frobenius(x, power), field.frobenius(z, power)) for x, z in points)
        for infinity, zero, one in permutations(twisted, 3):
            images.append(tuple(sorted(mobius_frame(field, point, infinity, zero, one) for point in twisted)))
    return min(images)


def six_set_representatives(field: FiniteField) -> tuple[tuple[Point2, ...], ...]:
    zero = (0, 1)
    one = (1, 1)
    infinity = (1, 0)
    remaining = tuple(point for point in p1_points(field) if point not in (zero, one, infinity))
    return tuple(sorted({canonical_p1_set(field, (zero, one, infinity) + extra) for extra in combinations(remaining, 3)}))


def six_set_presentation_count(field: FiniteField) -> int:
    return sum(1 for _ in combinations(range(field.q - 2), 3))


def twisted_cubic_point(field: FiniteField, point: Point2) -> Point4:
    x, z = point
    x2 = field.mul(x, x)
    z2 = field.mul(z, z)
    return normalize(field, (field.mul(x2, x), field.mul(x2, z), field.mul(x, z2), field.mul(z2, z)))  # type: ignore[return-value]


def projective_points4(field: FiniteField) -> tuple[Point4, ...]:
    q = range(field.q)
    answer = [(1, a, b, c) for a, b, c in product(q, repeat=3)]
    answer += [(0, 1, a, b) for a, b in product(q, repeat=2)]
    answer += [(0, 0, 1, a) for a in q]
    answer.append((0, 0, 0, 1))
    return tuple(answer)


def det3(field: FiniteField, rows: tuple[tuple[int, int, int], ...]) -> int:
    a, b, c = rows
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def plane_form(field: FiniteField, a: Point4, b: Point4, c: Point4) -> Point4:
    rows = (a, b, c)
    coefficients = []
    for omitted in range(4):
        minor = tuple(tuple(row[column] for column in range(4) if column != omitted) for row in rows)
        value = det3(field, minor)  # type: ignore[arg-type]
        coefficients.append(field.neg(value) if omitted % 2 else value)
    return normalize(field, tuple(coefficients))  # type: ignore[return-value]


def dot(field: FiniteField, left: tuple[int, ...], right: tuple[int, ...]) -> int:
    answer = 0
    for a, b in zip(left, right):
        answer = field.add(answer, field.mul(a, b))
    return answer


def matrix_rref(field: FiniteField, matrix: list[list[int]]) -> tuple[list[list[int]], tuple[int, ...]]:
    answer = [row[:] for row in matrix]
    pivots = []
    row = 0
    columns = len(answer[0]) if answer else 0
    for column in range(columns):
        pivot = next((candidate for candidate in range(row, len(answer)) if answer[candidate][column]), None)
        if pivot is None:
            continue
        answer[row], answer[pivot] = answer[pivot], answer[row]
        scale = field.inverse(answer[row][column])
        answer[row] = [field.mul(scale, entry) for entry in answer[row]]
        for other in range(len(answer)):
            if other == row or not answer[other][column]:
                continue
            multiple = answer[other][column]
            answer[other] = [field.sub(x, field.mul(multiple, y)) for x, y in zip(answer[other], answer[row])]
        pivots.append(column)
        row += 1
        if row == len(answer):
            break
    return answer, tuple(pivots)


def matrix_rank(field: FiniteField, matrix: list[list[int]]) -> int:
    return len(matrix_rref(field, matrix)[1])


def nullspace(field: FiniteField, matrix: list[list[int]]) -> tuple[tuple[int, ...], ...]:
    rref, pivots = matrix_rref(field, matrix)
    free = tuple(column for column in range(len(matrix[0])) if column not in pivots)
    basis = []
    for free_column in free:
        vector = [0] * len(matrix[0])
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(rref[row][free_column])
        basis.append(tuple(vector))
    return tuple(basis)


def is_arc4(field: FiniteField, points: tuple[Point4, ...]) -> bool:
    return len(set(points)) == len(points) and all(matrix_rank(field, [list(point) for point in four]) == 4 for four in combinations(points, 4))


def is_linearly_general4(field: FiniteField, points: tuple[Point4, ...]) -> bool:
    if len(set(points)) != len(points):
        return False
    for size in range(2, min(4, len(points)) + 1):
        if any(matrix_rank(field, [list(point) for point in subset]) != size for subset in combinations(points, size)):
            return False
    return True


def seven_on_twisted_cubic(field: FiniteField, points: tuple[Point4, ...]) -> bool:
    """Gale-dual conic criterion for a seven-arc in PG(3,q)."""
    assert len(points) == 7 and is_arc4(field, points)
    kernel = nullspace(field, [[point[row] for point in points] for row in range(4)])
    assert len(kernel) == 3
    gale = tuple(tuple(kernel[row][column] for row in range(3)) for column in range(7))
    evaluations = []
    for x, y, z in gale:
        evaluations.append([
            field.mul(x, x), field.mul(y, y), field.mul(z, z),
            field.mul(x, y), field.mul(x, z), field.mul(y, z),
        ])
    return matrix_rank(field, evaluations) < 6


def locus_on_twisted_cubic(field: FiniteField, points: tuple[Point4, ...]) -> bool:
    if not is_linearly_general4(field, points):
        return False
    if len(points) <= 6:
        return True
    base = points[:6]
    return all(seven_on_twisted_cubic(field, base + (point,)) for point in points[6:])


def quadratic_evaluation(field: FiniteField, point: Point4) -> tuple[int, ...]:
    squares = tuple(field.mul(x, x) for x in point)
    crosses = tuple(field.mul(point[i], point[j]) for i, j in combinations(range(4), 2))
    return squares + crosses


def quadric_matrix(field: FiniteField, coefficients: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    assert len(coefficients) == 10 and field.p != 2
    half = field.inverse(2)
    matrix = [[0] * 4 for _ in range(4)]
    for i in range(4):
        matrix[i][i] = coefficients[i]
    for coefficient, (i, j) in zip(coefficients[4:], combinations(range(4), 2)):
        matrix[i][j] = matrix[j][i] = field.mul(half, coefficient)
    return tuple(tuple(row) for row in matrix)


def permutation_sign(permutation: tuple[int, ...]) -> int:
    inversions = sum(permutation[i] > permutation[j] for i in range(len(permutation)) for j in range(i + 1, len(permutation)))
    return -1 if inversions % 2 else 1


def determinant_net_quartic(
    field: FiniteField, matrices: tuple[tuple[tuple[int, ...], ...], ...]
) -> tuple[tuple[tuple[int, int, int], int], ...]:
    coefficients: dict[tuple[int, int, int], int] = {}
    for permutation in permutations(range(4)):
        sign = permutation_sign(permutation)
        for variables in product(range(3), repeat=4):
            value = 1
            exponents = [0, 0, 0]
            for row, variable in enumerate(variables):
                value = field.mul(value, matrices[variable][row][permutation[row]])
                exponents[variable] += 1
            if sign < 0:
                value = field.neg(value)
            exponent = tuple(exponents)
            coefficients[exponent] = field.add(coefficients.get(exponent, 0), value)
    return tuple(sorted((exponent, value) for exponent, value in coefficients.items() if value))


def evaluate_homogeneous(field: FiniteField, terms: tuple[tuple[tuple[int, ...], int], ...], point: tuple[int, ...]) -> int:
    answer = 0
    for exponents, coefficient in terms:
        monomial = coefficient
        for coordinate, exponent in zip(point, exponents):
            monomial = field.mul(monomial, field.pow(coordinate, exponent))
        answer = field.add(answer, monomial)
    return answer


def projective_points3(field: FiniteField) -> tuple[Point3, ...]:
    q = range(field.q)
    return tuple([(1, a, b) for a, b in product(q, repeat=2)] + [(0, 1, a) for a in q] + [(0, 0, 1)])


def pointset_stabilizers(field: FiniteField, points: tuple[Point4, ...]) -> tuple[int, int]:
    images = set()
    for power in range(field.degree):
        twisted = tuple(tuple(field.frobenius(x, power) for x in point) for point in points)
        for ordered in permutations(twisted, 5):
            images.add(frame_normalize4(field, ordered, twisted))
    frame_count = 1
    for factor in range(len(points) - 4, len(points) + 1):
        frame_count *= factor
    semilinear = frame_count * field.degree // len(images)
    projective = semilinear // field.degree
    assert projective * field.degree == semilinear
    return projective, semilinear


def q9_free_upgrade(parent: Arc, locus: tuple[Point4, ...], pair_stabilizer: int) -> dict[str, object]:
    field = FiniteField(9)
    space = projective_points4(field)
    evaluations = [list(quadratic_evaluation(field, point)) for point in locus]
    quadrics = nullspace(field, evaluations)
    assert len(quadrics) == 3
    base_locus = tuple(point for point in space if all(dot(field, quadratic_evaluation(field, point), quadric) == 0 for quadric in quadrics))
    assert tuple(sorted(base_locus)) == tuple(sorted(locus))
    matrices = tuple(quadric_matrix(field, quadric) for quadric in quadrics)
    discriminant = determinant_net_quartic(field, matrices)
    frobenius_matrix = [[0] * 3 for _ in range(3)]
    for exponents, coefficient in discriminant:
        assert sorted(exponents) == [0, 1, 3]
        frobenius_index = exponents.index(3)
        linear_index = exponents.index(1)
        frobenius_matrix[frobenius_index][linear_index] = coefficient
    hermitian_adjoint = [
        [field.frobenius(frobenius_matrix[j][i]) for j in range(3)] for i in range(3)
    ]
    assert hermitian_adjoint == frobenius_matrix
    discriminant_points = tuple(
        point for point in projective_points3(field) if evaluate_homogeneous(field, discriminant, point) == 0
    )
    rank_distribution = Counter()
    for parameters in projective_points3(field):
        matrix = [
            [field.add(field.add(field.mul(parameters[0], matrices[0][i][j]), field.mul(parameters[1], matrices[1][i][j])), field.mul(parameters[2], matrices[2][i][j])) for j in range(4)]
            for i in range(4)
        ]
        rank_distribution[matrix_rank(field, matrix)] += 1
    self_duality_rows = []
    for i in range(4):
        for j in range(i, 4):
            self_duality_rows.append([field.mul(point[i], point[j]) for point in locus])
    self_duality_kernel = nullspace(field, self_duality_rows)
    assert len(self_duality_kernel) == 1 and all(self_duality_kernel[0])
    squares = {field.mul(value, value) for value in range(1, field.q)}
    assert all(value in squares for value in self_duality_kernel[0])
    second_locus = deep_locus_direct(field, tuple(sorted(locus)), space)
    projective_stabilizer, semilinear_stabilizer = pointset_stabilizers(field, locus)
    assert semilinear_stabilizer % pair_stabilizer == 0
    return {
        "classification": "complete Cayley octad with Hermitian discriminant quartic",
        "quadratic_evaluation_rank": matrix_rank(field, evaluations),
        "quadric_net_basis": quadrics,
        "base_locus_size": len(base_locus),
        "base_locus_equals_locus": tuple(sorted(base_locus)) == tuple(sorted(locus)),
        "discriminant_quartic_terms": discriminant,
        "discriminant_frobenius_matrix": tuple(tuple(row) for row in frobenius_matrix),
        "discriminant_matrix_determinant": det3(field, tuple(tuple(row) for row in frobenius_matrix)),
        "discriminant_is_hermitian_form": hermitian_adjoint == frobenius_matrix,
        "discriminant_f9_points": len(discriminant_points),
        "quadric_net_rank_distribution": dict(sorted(rank_distribution.items())),
        "second_deep_locus_size": len(second_locus),
        "weighted_self_duality_kernel": self_duality_kernel,
        "weighted_self_duality_vector_all_squares": all(value in squares for value in self_duality_kernel[0]),
        "projective_stabilizer": projective_stabilizer,
        "semilinear_stabilizer": semilinear_stabilizer,
        "pair_semilinear_stabilizer": pair_stabilizer,
        "parent_decoration_orbit_size": semilinear_stabilizer // pair_stabilizer,
    }


def inverse_matrix(field: FiniteField, columns: tuple[Point4, Point4, Point4, Point4]) -> tuple[tuple[int, ...], ...]:
    augmented = []
    for row in range(4):
        augmented.append([columns[column][row] for column in range(4)] + [int(row == column) for column in range(4)])
    rref, pivots = matrix_rref(field, augmented)
    assert pivots[:4] == (0, 1, 2, 3)
    return tuple(tuple(row[4:]) for row in rref)


def mat_vec(field: FiniteField, matrix: tuple[tuple[int, ...], ...], point: Point4) -> Point4:
    return tuple(dot(field, row, point) for row in matrix)  # type: ignore[return-value]


def frame_normalize4(field: FiniteField, ordered: tuple[Point4, ...], points: tuple[Point4, ...]) -> tuple[Point4, ...]:
    inverse = inverse_matrix(field, ordered[:4])
    fifth = mat_vec(field, inverse, ordered[4])
    assert all(fifth)
    diagonal = tuple(field.inverse(entry) for entry in fifth)
    transformed = []
    for point in points:
        coordinates = mat_vec(field, inverse, point)
        transformed.append(normalize(field, tuple(field.mul(diagonal[i], coordinates[i]) for i in range(4))))
    return tuple(sorted(transformed))  # type: ignore[return-value]


def canonical_pair(field: FiniteField, parent: Arc, locus: tuple[Point4, ...]) -> tuple[Arc, tuple[Point4, ...], int]:
    images: set[tuple[Arc, tuple[Point4, ...]]] = set()
    for power in range(field.degree):
        twisted_parent = tuple(tuple(field.frobenius(x, power) for x in point) for point in parent)
        twisted_locus = tuple(tuple(field.frobenius(x, power) for x in point) for point in locus)
        for ordered in permutations(twisted_parent, 5):
            normalized_parent = frame_normalize4(field, ordered, twisted_parent)
            normalized_locus = frame_normalize4(field, ordered, twisted_locus)
            images.add((normalized_parent, normalized_locus))
    representative = min(images)
    stabilizer = 2520 * field.degree // len(images)
    assert stabilizer * len(images) == 2520 * field.degree
    return representative[0], representative[1], stabilizer


def deep_locus_direct(field: FiniteField, parent: Arc, points: tuple[Point4, ...]) -> tuple[Point4, ...]:
    planes = tuple(plane_form(field, *triple) for triple in combinations(parent, 3))
    return tuple(point for point in points if all(dot(field, plane, point) for plane in planes))


def classify_field(field: FiniteField) -> dict[str, object]:
    space = projective_points4(field)
    six_sets = six_set_representatives(field)
    canonical_survivors: dict[Arc, dict[str, object]] = {}
    canonical_near_misses: dict[Arc, dict[str, object]] = {}
    extension_tests = 0
    nonempty = 0
    small_locus = 0
    arc_locus = 0
    non_grs = 0
    duplicate_hits = 0
    direct_replays = 0

    for parameter_set in six_sets:
        six_arc = tuple(sorted(twisted_cubic_point(field, point) for point in parameter_set))
        assert is_arc4(field, six_arc)
        old_planes = tuple(plane_form(field, *triple) for triple in combinations(six_arc, 3))
        uncovered = tuple(point for point in space if all(dot(field, plane, point) for plane in old_planes))
        full_mask = (1 << len(uncovered)) - 1
        cover_masks = [0] * len(uncovered)
        for a, b in combinations(six_arc, 2):
            groups: dict[Point4, tuple[int, list[int]]] = {}
            for index, point in enumerate(uncovered):
                plane = plane_form(field, a, b, point)
                mask, indices = groups.get(plane, (0, []))
                groups[plane] = (mask | (1 << index), indices + [index])
            for mask, indices in groups.values():
                for index in indices:
                    cover_masks[index] |= mask

        if uncovered:
            replay_parent = tuple(sorted(six_arc + (uncovered[0],)))
            replay_locus = deep_locus_direct(field, replay_parent, space)
            replay_mask = full_mask & ~cover_masks[0]
            bitset_locus = tuple(uncovered[i] for i in range(len(uncovered)) if replay_mask >> i & 1)
            assert tuple(sorted(replay_locus)) == tuple(sorted(bitset_locus))
            direct_replays += 1

        for index, seventh in enumerate(uncovered):
            extension_tests += 1
            locus_mask = full_mask & ~cover_masks[index]
            locus_size = locus_mask.bit_count()
            if not locus_size:
                continue
            nonempty += 1
            if locus_size > field.q + 1:
                continue
            small_locus += 1
            locus = tuple(uncovered[i] for i in range(len(uncovered)) if locus_mask >> i & 1)
            if not is_linearly_general4(field, locus):
                continue
            arc_locus += 1
            parent = tuple(sorted(six_arc + (seventh,)))
            if seven_on_twisted_cubic(field, parent):
                continue
            non_grs += 1
            if not locus_on_twisted_cubic(field, locus):
                canonical_parent, canonical_locus, stabilizer = canonical_pair(field, parent, locus)
                direct = deep_locus_direct(field, canonical_parent, space)
                assert tuple(sorted(direct)) == canonical_locus
                record = {
                    "parent": canonical_parent,
                    "locus": canonical_locus,
                    "locus_size": len(canonical_locus),
                    "semilinear_stabilizer": stabilizer,
                    "base_six_plus_each_on_twisted_cubic": tuple(
                        seven_on_twisted_cubic(field, canonical_locus[:6] + (point,))
                        for point in canonical_locus[6:]
                    ),
                }
                if canonical_parent in canonical_near_misses:
                    assert all(canonical_near_misses[canonical_parent][key] == value for key, value in record.items())
                else:
                    if field.q == 9 and len(canonical_locus) == 8:
                        record["free_upgrade"] = q9_free_upgrade(canonical_parent, canonical_locus, stabilizer)
                    canonical_near_misses[canonical_parent] = record
                continue
            canonical_parent, canonical_locus, stabilizer = canonical_pair(field, parent, locus)
            direct = deep_locus_direct(field, canonical_parent, space)
            assert tuple(sorted(direct)) == canonical_locus
            record = {
                "parent": canonical_parent,
                "locus": canonical_locus,
                "locus_size": len(canonical_locus),
                "semilinear_stabilizer": stabilizer,
                "full_twisted_cubic": len(canonical_locus) == field.q + 1,
            }
            if canonical_parent in canonical_survivors:
                assert canonical_survivors[canonical_parent] == record
                duplicate_hits += 1
            else:
                canonical_survivors[canonical_parent] = record

    survivors = tuple(sorted(canonical_survivors.values(), key=lambda record: (record["parent"], record["locus"])))
    near_misses = tuple(sorted(canonical_near_misses.values(), key=lambda record: (record["parent"], record["locus"])))
    return {
        "q": field.q,
        "six_set_presentations": six_set_presentation_count(field),
        "six_set_orbits": len(six_sets),
        "direct_replays": direct_replays,
        "extension_tests": extension_tests,
        "nonempty_presentations": nonempty,
        "small_locus_presentations": small_locus,
        "arc_locus_presentations": arc_locus,
        "non_grs_presentations": non_grs,
        "duplicate_survivor_hits": duplicate_hits,
        "near_miss_orbits": len(near_misses),
        "survivor_orbits": len(survivors),
        "locus_size_distribution": dict(sorted(Counter(record["locus_size"] for record in survivors).items())),
        "near_misses": near_misses,
        "survivors": survivors,
    }


def literature_control() -> dict[str, object]:
    """Li--Lu--Ling--Lam Example 2, arXiv:2605.12133v1, pp. 19--20."""
    field = FiniteField(11)
    rows = (
        (1, 1, 1, 1, 1, 0, 0),
        (3, 4, 5, 6, 7, 0, 0),
        (5, 9, 4, 7, 2, 1, 0),
        (7, 10, 5, 5, 1, 4, 1),
    )
    parent = tuple(tuple(row[column] for row in rows) for column in range(7))
    locus = deep_locus_direct(field, tuple(sorted(parent)), projective_points4(field))
    return {
        "source": "Li--Lu--Ling--Lam arXiv:2605.12133v1 Example 2",
        "q": 11,
        "parent_rows": rows,
        "parent_is_arc": is_arc4(field, parent),
        "parent_is_grs": seven_on_twisted_cubic(field, parent),
        "locus_size": len(locus),
        "locus_is_linearly_general": is_linearly_general4(field, locus),
        "locus_on_twisted_cubic": locus_on_twisted_cubic(field, locus),
    }


def generate(fields: tuple[int, ...]) -> dict[str, object]:
    rows = [classify_field(FiniteField(q)) for q in fields]
    return {
        "schema": SCHEMA,
        "field_bound": 35,
        "parent_length": 7,
        "fields": list(fields),
        "literature_control": literature_control(),
        "rows": rows,
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fields", default=",".join(map(str, FIELDS)))
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    fields = tuple(int(value) for value in args.fields.split(","))
    assert fields and all(q in FIELDS for q in fields)
    payload = generate(fields)
    encoded = canonical_bytes(payload)
    path = Path(__file__).with_name(f"{STEM}.json")
    if args.write:
        assert fields == FIELDS
        path.write_bytes(encoded)
    if args.check:
        assert fields == FIELDS
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory) / path.name
            temporary.write_bytes(encoded)
            assert path.read_bytes() == temporary.read_bytes()
    summary = {
        "fields": list(fields),
        "sha256": hashlib.sha256(encoded).hexdigest(),
        "rows": [
            {key: row[key] for key in (
                "q", "six_set_presentations", "six_set_orbits", "direct_replays", "extension_tests",
                "nonempty_presentations", "small_locus_presentations", "arc_locus_presentations",
                "non_grs_presentations", "near_miss_orbits", "survivor_orbits", "locus_size_distribution",
            )}
            for row in payload["rows"]  # type: ignore[index]
        ],
    }
    print(json.dumps(summary, sort_keys=True))


if __name__ == "__main__":
    main()
