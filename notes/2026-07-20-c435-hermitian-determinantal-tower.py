#!/usr/bin/env python3
"""Exact subgroup and determinantal-class certificate for C435."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import tempfile
from collections import Counter, deque
from itertools import combinations, permutations, product
from pathlib import Path


STEM = "2026-07-20-c435-hermitian-determinantal-tower"
SCHEMA = "c435-hermitian-determinantal-tower-v1"
C405_STEM = "2026-07-20-c405-twisted-cubic-deep-hole-pilot"
C405_JSON_SHA256 = "c1d9a0e11b7890c415a18c49a989301101784ae3b4d9931be59a15820c5df692"

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Permutation = tuple[int, ...]


class F9:
    """The C405 polynomial-basis model F_3[x]/(x^2+1)."""

    q = 9
    p = 3

    def __init__(self) -> None:
        self._add = tuple(tuple(self._add_raw(a, b) for b in range(9)) for a in range(9))
        self._mul = tuple(tuple(self._mul_raw(a, b) for b in range(9)) for a in range(9))
        self._neg = tuple(self._neg_raw(a) for a in range(9))
        self._inv = (0,) + tuple(self.pow(a, 7) for a in range(1, 9))
        assert all(self.mul(a, self._inv[a]) == 1 for a in range(1, 9))

    @staticmethod
    def coefficients(value: int) -> tuple[int, int]:
        return value % 3, value // 3

    @staticmethod
    def encode(coefficients: tuple[int, int] | list[int]) -> int:
        return coefficients[0] % 3 + 3 * (coefficients[1] % 3)

    def _add_raw(self, left: int, right: int) -> int:
        a, b = self.coefficients(left)
        c, d = self.coefficients(right)
        return self.encode((a + c, b + d))

    def add(self, left: int, right: int) -> int:
        return self._add[left][right]

    def _neg_raw(self, value: int) -> int:
        a, b = self.coefficients(value)
        return self.encode((-a, -b))

    def neg(self, value: int) -> int:
        return self._neg[value]

    def sub(self, left: int, right: int) -> int:
        return self._add[left][self._neg[right]]

    def _mul_raw(self, left: int, right: int) -> int:
        a, b = self.coefficients(left)
        c, d = self.coefficients(right)
        # x^2 = -1 = 2.
        return self.encode((a * c + 2 * b * d, a * d + b * c))

    def mul(self, left: int, right: int) -> int:
        return self._mul[left][right]

    def pow(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inverse(self, value: int) -> int:
        assert value
        return self._inv[value]

    def div(self, left: int, right: int) -> int:
        return self.mul(left, self.inverse(right))

    def frobenius(self, value: int) -> int:
        return self.pow(value, 3)


FIELD = F9()


def dot(left: Vector, right: Vector) -> int:
    answer = 0
    for a, b in zip(left, right):
        answer = FIELD.add(answer, FIELD.mul(a, b))
    return answer


def normalize(vector: Vector) -> Vector:
    scale = FIELD.inverse(next(entry for entry in vector if entry))
    return tuple(FIELD.mul(scale, entry) for entry in vector)


def identity(size: int) -> Matrix:
    return tuple(tuple(int(i == j) for j in range(size)) for i in range(size))


def transpose(matrix: Matrix) -> Matrix:
    return tuple(tuple(matrix[i][j] for i in range(len(matrix))) for j in range(len(matrix[0])))


def mat_vec(matrix: Matrix, vector: Vector) -> Vector:
    return tuple(dot(row, vector) for row in matrix)


def mat_mul(left: Matrix, right: Matrix) -> Matrix:
    columns = transpose(right)
    return tuple(tuple(dot(row, column) for column in columns) for row in left)


def mat_scale(scalar: int, matrix: Matrix) -> Matrix:
    return tuple(tuple(FIELD.mul(scalar, entry) for entry in row) for row in matrix)


def normalize_matrix(matrix: Matrix) -> Matrix:
    flat = tuple(entry for row in matrix for entry in row)
    scale = FIELD.inverse(next(entry for entry in flat if entry))
    return mat_scale(scale, matrix)


def rref(matrix: list[list[int]]) -> tuple[list[list[int]], tuple[int, ...]]:
    answer = [row[:] for row in matrix]
    pivots: list[int] = []
    row = 0
    for column in range(len(answer[0]) if answer else 0):
        pivot = next((candidate for candidate in range(row, len(answer)) if answer[candidate][column]), None)
        if pivot is None:
            continue
        answer[row], answer[pivot] = answer[pivot], answer[row]
        scale = FIELD.inverse(answer[row][column])
        answer[row] = [FIELD.mul(scale, entry) for entry in answer[row]]
        for other in range(len(answer)):
            if other == row or not answer[other][column]:
                continue
            multiple = answer[other][column]
            answer[other] = [
                FIELD.sub(x, FIELD.mul(multiple, y)) for x, y in zip(answer[other], answer[row])
            ]
        pivots.append(column)
        row += 1
        if row == len(answer):
            break
    return answer, tuple(pivots)


def matrix_rank(matrix: Matrix | tuple[Vector, ...]) -> int:
    return len(rref([list(row) for row in matrix])[1])


def matrix_inverse(matrix: Matrix) -> Matrix:
    size = len(matrix)
    augmented = [list(matrix[row]) + list(identity(size)[row]) for row in range(size)]
    reduced, pivots = rref(augmented)
    assert pivots[:size] == tuple(range(size))
    return tuple(tuple(row[size:]) for row in reduced)


def columns(vectors: tuple[Vector, ...]) -> Matrix:
    return tuple(tuple(vector[row] for vector in vectors) for row in range(len(vectors[0])))


def frame_map(source: tuple[Vector, ...], target: tuple[Vector, ...]) -> Matrix | None:
    """Unique projectivity mapping one ordered projective frame to another."""
    dimension = len(source[0])
    assert len(source) == len(target) == dimension + 1
    source_columns = columns(source[:dimension])
    target_columns = columns(target[:dimension])
    if matrix_rank(source_columns) != dimension or matrix_rank(target_columns) != dimension:
        return None
    source_inverse = matrix_inverse(source_columns)
    target_inverse = matrix_inverse(target_columns)
    source_last = mat_vec(source_inverse, source[dimension])
    target_last = mat_vec(target_inverse, target[dimension])
    if not all(source_last) or not all(target_last):
        return None
    diagonal = tuple(FIELD.div(target_last[i], source_last[i]) for i in range(dimension))
    scaled_target = tuple(
        tuple(FIELD.mul(target_columns[row][column], diagonal[column]) for column in range(dimension))
        for row in range(dimension)
    )
    answer = normalize_matrix(mat_mul(scaled_target, source_inverse))
    assert all(normalize(mat_vec(answer, source[i])) == normalize(target[i]) for i in range(dimension + 1))
    return answer


def apply_projectivity(matrix: Matrix, point: Vector) -> Vector:
    return normalize(mat_vec(matrix, point))


def frobenius_vector(vector: Vector) -> Vector:
    return tuple(FIELD.frobenius(entry) for entry in vector)


def frobenius_matrix(matrix: Matrix) -> Matrix:
    return tuple(frobenius_vector(row) for row in matrix)


def projective_points(dimension: int) -> tuple[Vector, ...]:
    answer: list[Vector] = []
    for pivot in range(dimension):
        suffix_length = dimension - pivot - 1
        for suffix in product(range(9), repeat=suffix_length):
            answer.append((0,) * pivot + (1,) + tuple(suffix))
    return tuple(answer)


def quadric_matrix(coefficients: Vector) -> Matrix:
    assert len(coefficients) == 10
    half = FIELD.inverse(2)
    matrix = [[0] * 4 for _ in range(4)]
    for i in range(4):
        matrix[i][i] = coefficients[i]
    for coefficient, (i, j) in zip(coefficients[4:], combinations(range(4), 2)):
        matrix[i][j] = matrix[j][i] = FIELD.mul(half, coefficient)
    return tuple(tuple(row) for row in matrix)


def matrix_to_quadric(matrix: Matrix) -> Vector:
    answer = [matrix[i][i] for i in range(4)]
    answer.extend(FIELD.mul(2, matrix[i][j]) for i, j in combinations(range(4), 2))
    return tuple(answer)


def linear_combination(coefficients: Vector, vectors: tuple[Vector, ...]) -> Vector:
    answer = [0] * len(vectors[0])
    for coefficient, vector in zip(coefficients, vectors):
        for i, entry in enumerate(vector):
            answer[i] = FIELD.add(answer[i], FIELD.mul(coefficient, entry))
    return tuple(answer)


def net_coordinate_dictionary(quadrics: tuple[Vector, ...]) -> dict[Vector, Vector]:
    answer = {
        linear_combination(coefficients, quadrics): coefficients
        for coefficients in product(range(9), repeat=3)
    }
    assert len(answer) == 9**3
    return answer


def enumerate_octad_stabilizer(points: tuple[Vector, ...], parent: tuple[Vector, ...]) -> tuple[set[Matrix], set[Matrix]]:
    base = points[:5]
    point_set = set(points)
    parent_set = set(parent)
    stabilizer: set[Matrix] = set()
    parent_stabilizer: set[Matrix] = set()
    for target in permutations(points, 5):
        matrix = frame_map(base, target)
        assert matrix is not None
        if {apply_projectivity(matrix, point) for point in points} != point_set:
            continue
        stabilizer.add(matrix)
        if {apply_projectivity(matrix, point) for point in parent} == parent_set:
            parent_stabilizer.add(matrix)
    assert len(stabilizer) == 168
    assert len(parent_stabilizer) == 21
    return stabilizer, parent_stabilizer


def enumerate_semilinear_octad_coset(points: tuple[Vector, ...], parent: tuple[Vector, ...]) -> tuple[set[Matrix], set[Matrix]]:
    """Linear parts T for semilinear maps x -> T*x^3 preserving the data."""
    twisted_points = tuple(frobenius_vector(point) for point in points)
    twisted_parent = tuple(frobenius_vector(point) for point in parent)
    base = twisted_points[:5]
    point_set = set(points)
    parent_set = set(parent)
    stabilizer_coset: set[Matrix] = set()
    parent_coset: set[Matrix] = set()
    for target in permutations(points, 5):
        matrix = frame_map(base, target)
        assert matrix is not None
        if {apply_projectivity(matrix, point) for point in twisted_points} != point_set:
            continue
        stabilizer_coset.add(matrix)
        if {apply_projectivity(matrix, point) for point in twisted_parent} == parent_set:
            parent_coset.add(matrix)
    assert len(stabilizer_coset) == 168
    assert len(parent_coset) == 21
    return stabilizer_coset, parent_coset


def induced_net_action(matrix: Matrix, quadric_matrices: tuple[Matrix, ...], coordinate_map: dict[Vector, Vector]) -> Matrix:
    transformed_coordinates = []
    matrix_transpose = transpose(matrix)
    for quadric in quadric_matrices:
        transformed = mat_mul(mat_mul(matrix_transpose, quadric), matrix)
        transformed_coordinates.append(coordinate_map[matrix_to_quadric(transformed)])
    # If q_i(Tu) = sum_j B_ij q_j(u), then lambda -> B^T lambda.
    return normalize_matrix(transpose(tuple(transformed_coordinates)))


def induced_semilinear_net_action(matrix: Matrix, quadric_matrices: tuple[Matrix, ...], coordinate_map: dict[Vector, Vector]) -> Matrix:
    """Linear part B of lambda -> B*lambda^3 induced by x -> T*x^3."""
    inverse = matrix_inverse(matrix)
    inverse_transpose = transpose(inverse)
    transformed_coordinates = []
    for quadric in quadric_matrices:
        pushed_forward = mat_mul(mat_mul(inverse_transpose, frobenius_matrix(quadric)), inverse)
        transformed_coordinates.append(coordinate_map[matrix_to_quadric(pushed_forward)])
    return normalize_matrix(transpose(tuple(transformed_coordinates)))


def semilinear_conjugate(linear_part: Matrix, matrix: Matrix) -> Matrix:
    return normalize_matrix(
        mat_mul(mat_mul(linear_part, frobenius_matrix(matrix)), matrix_inverse(linear_part))
    )


def hermitian_adjoint(matrix: Matrix) -> Matrix:
    return tuple(tuple(FIELD.frobenius(matrix[j][i]) for j in range(len(matrix))) for i in range(len(matrix)))


def similitude_multiplier(matrix: Matrix, hermitian: Matrix) -> int | None:
    transformed = mat_mul(mat_mul(hermitian_adjoint(matrix), hermitian), matrix)
    pivot = next((
        (i, j) for i in range(3) for j in range(3) if hermitian[i][j]
    ))
    multiplier = FIELD.div(transformed[pivot[0]][pivot[1]], hermitian[pivot[0]][pivot[1]])
    return multiplier if transformed == mat_scale(multiplier, hermitian) else None


def hermitian_value(point: Vector, hermitian: Matrix) -> int:
    conjugate = tuple(FIELD.frobenius(entry) for entry in point)
    return dot(conjugate, mat_vec(hermitian, point))


def enumerate_projective_unitary_group(hermitian: Matrix) -> tuple[tuple[Vector, ...], set[Matrix]]:
    curve = tuple(point for point in projective_points(3) if hermitian_value(point, hermitian) == 0)
    assert len(curve) == 28
    base = next(
        frame for frame in combinations(curve, 4)
        if frame_map(frame, frame) is not None
    )
    group: set[Matrix] = set()
    for target in permutations(curve, 4):
        matrix = frame_map(base, target)
        if matrix is not None and similitude_multiplier(matrix, hermitian) is not None:
            group.add(matrix)
    formula_order = 3**3 * (3**3 + 1) * (3**2 - 1)
    assert formula_order == 6048 == len(group)
    return curve, group


def matrix_group_closure(generators: tuple[Matrix, ...]) -> set[Matrix]:
    size = len(generators[0])
    answer = {identity(size)}
    queue = deque([identity(size)])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = normalize_matrix(mat_mul(current, generator))
            if candidate not in answer:
                answer.add(candidate)
                queue.append(candidate)
    return answer


def matrix_generators(group: set[Matrix]) -> tuple[Matrix, ...]:
    generators: list[Matrix] = []
    closure = {identity(len(next(iter(group))))}
    for candidate in sorted(group):
        if candidate in closure:
            continue
        generators.append(candidate)
        closure = matrix_group_closure(tuple(generators))
        assert closure <= group
        if closure == group:
            break
    assert closure == group
    return tuple(generators)


def point_permutation(matrix: Matrix, points: tuple[Vector, ...]) -> Permutation:
    index = {point: i for i, point in enumerate(points)}
    return tuple(index[apply_projectivity(matrix, point)] for point in points)


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[i]] for i in range(len(left)))


def permutation_order(permutation: Permutation) -> int:
    seen: set[int] = set()
    answer = 1
    for start in range(len(permutation)):
        if start in seen:
            continue
        length = 0
        current = start
        while current not in seen:
            seen.add(current)
            current = permutation[current]
            length += 1
        answer = math.lcm(answer, length)
    return answer


def order_distribution(permutations_: set[Permutation]) -> dict[int, int]:
    return dict(sorted(Counter(permutation_order(permutation) for permutation in permutations_).items()))


def permutation_closure(generators: tuple[Permutation, ...]) -> set[Permutation]:
    degree = len(generators[0])
    identity_permutation = tuple(range(degree))
    answer = {identity_permutation}
    queue = deque([identity_permutation])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = compose(current, generator)
            if candidate not in answer:
                answer.add(candidate)
                queue.append(candidate)
    return answer


def permutation_generators(group: set[Permutation]) -> tuple[Permutation, ...]:
    generators: list[Permutation] = []
    closure = {tuple(range(len(next(iter(group)))))}
    for candidate in sorted(group):
        if candidate in closure:
            continue
        generators.append(candidate)
        closure = permutation_closure(tuple(generators))
        assert closure <= group
        if closure == group:
            break
    assert closure == group
    return tuple(generators)


def standard_psl2_7() -> set[Permutation]:
    points = tuple((value, 1) for value in range(7)) + ((1, 0),)
    index = {normalize_mod7(point): i for i, point in enumerate(points)}
    answer: set[Permutation] = set()
    for a, b, c, d in product(range(7), repeat=4):
        if (a * d - b * c) % 7 != 1:
            continue
        permutation = []
        for x, y in points:
            image = ((a * x + b * y) % 7, (c * x + d * y) % 7)
            permutation.append(index[normalize_mod7(image)])
        answer.add(tuple(permutation))
    assert len(answer) == 168
    return answer


def normalize_mod7(point: tuple[int, int]) -> tuple[int, int]:
    scale = pow(next(entry for entry in point if entry), -1, 7)
    return tuple(scale * entry % 7 for entry in point)  # type: ignore[return-value]


def conjugate_permutation(permutation: Permutation, labels: Permutation) -> Permutation:
    answer = [0] * len(permutation)
    for source, target_label in enumerate(labels):
        answer[target_label] = labels[permutation[source]]
    return tuple(answer)


def find_conjugacy(group: set[Permutation], standard: set[Permutation]) -> Permutation:
    generators = permutation_generators(group)
    for labels in permutations(range(8)):
        if not all(conjugate_permutation(generator, labels) in standard for generator in generators):
            continue
        conjugated = {conjugate_permutation(element, labels) for element in group}
        if conjugated == standard:
            return labels
    raise AssertionError("the eight-point group is not conjugate to the standard PSL_2(7) action")


def left_cosets(group: set[Matrix], subgroup: set[Matrix]) -> tuple[tuple[Matrix, ...], dict[Matrix, int]]:
    unassigned = set(group)
    cosets: list[tuple[Matrix, ...]] = []
    element_to_coset: dict[Matrix, int] = {}
    while unassigned:
        representative = min(unassigned)
        coset = tuple(sorted(normalize_matrix(mat_mul(representative, element)) for element in subgroup))
        assert len(coset) == len(subgroup) and set(coset) <= group
        index = len(cosets)
        for element in coset:
            assert element not in element_to_coset
            element_to_coset[element] = index
        unassigned.difference_update(coset)
        cosets.append(coset)
    assert len(element_to_coset) == len(group)
    return tuple(cosets), element_to_coset


def coset_permutation(matrix: Matrix, cosets: tuple[tuple[Matrix, ...], ...], lookup: dict[Matrix, int]) -> Permutation:
    return tuple(
        lookup[normalize_matrix(mat_mul(matrix, coset[0]))]
        for coset in cosets
    )


def subgroup_orbit_sizes(permutations_: set[Permutation]) -> tuple[int, ...]:
    remaining = set(range(len(next(iter(permutations_)))))
    sizes = []
    while remaining:
        seed = min(remaining)
        orbit = {permutation[seed] for permutation in permutations_}
        sizes.append(len(orbit))
        remaining.difference_update(orbit)
    return tuple(sorted(sizes))


def subgroup_orbits(permutations_: set[Permutation]) -> tuple[frozenset[int], ...]:
    remaining = set(range(len(next(iter(permutations_)))))
    orbits = []
    while remaining:
        seed = min(remaining)
        orbit = frozenset(permutation[seed] for permutation in permutations_)
        orbits.append(orbit)
        remaining.difference_update(orbit)
    return tuple(sorted(orbits, key=lambda orbit: (len(orbit), min(orbit))))


def json_int_key_dict(dictionary: dict[int, int]) -> dict[str, int]:
    return {str(key): value for key, value in dictionary.items()}


def load_c405() -> tuple[tuple[Vector, ...], tuple[Vector, ...], tuple[Vector, ...], Matrix, dict[str, object]]:
    path = Path(__file__).with_name(f"{C405_STEM}.json")
    encoded = path.read_bytes()
    assert hashlib.sha256(encoded).hexdigest() == C405_JSON_SHA256
    payload = json.loads(encoded)
    row = next(row for row in payload["rows"] if row["q"] == 9)
    near_miss = row["near_misses"][0]
    upgrade = near_miss["free_upgrade"]
    octad = tuple(tuple(point) for point in near_miss["locus"])
    parent = tuple(tuple(point) for point in near_miss["parent"])
    quadrics = tuple(tuple(quadric) for quadric in upgrade["quadric_net_basis"])
    hermitian = tuple(tuple(row_) for row_ in upgrade["discriminant_frobenius_matrix"])
    return octad, parent, quadrics, hermitian, upgrade


def generate() -> dict[str, object]:
    octad, parent, quadrics, hermitian, c405_upgrade = load_c405()
    assert matrix_rank(hermitian) == 3
    assert hermitian == hermitian_adjoint(hermitian)

    octad_group4, parent_group4 = enumerate_octad_stabilizer(octad, parent)
    semilinear_octad_coset4, semilinear_parent_coset4 = enumerate_semilinear_octad_coset(octad, parent)
    quadric_matrices = tuple(quadric_matrix(quadric) for quadric in quadrics)
    coordinate_map = net_coordinate_dictionary(quadrics)
    octad_group3 = {induced_net_action(matrix, quadric_matrices, coordinate_map) for matrix in octad_group4}
    parent_group3 = {induced_net_action(matrix, quadric_matrices, coordinate_map) for matrix in parent_group4}
    assert len(octad_group3) == 168 and len(parent_group3) == 21
    semilinear_matrix4 = min(semilinear_parent_coset4)
    semilinear_matrix3 = induced_semilinear_net_action(semilinear_matrix4, quadric_matrices, coordinate_map)

    curve, unitary_group = enumerate_projective_unitary_group(hermitian)
    assert octad_group3 <= unitary_group
    assert parent_group3 <= octad_group3
    assert all(similitude_multiplier(matrix, hermitian) is not None for matrix in unitary_group)
    assert {
        apply_projectivity(semilinear_matrix3, frobenius_vector(point)) for point in curve
    } == set(curve)
    assert {semilinear_conjugate(semilinear_matrix3, matrix) for matrix in unitary_group} == unitary_group
    assert {semilinear_conjugate(semilinear_matrix3, matrix) for matrix in octad_group3} == octad_group3
    assert {semilinear_conjugate(semilinear_matrix3, matrix) for matrix in parent_group3} == parent_group3

    octad_permutations = {point_permutation(matrix, octad) for matrix in octad_group4}
    parent_permutations = {point_permutation(matrix, octad) for matrix in parent_group4}
    assert len(octad_permutations) == 168 and len(parent_permutations) == 21
    psl = standard_psl2_7()
    labels = find_conjugacy(octad_permutations, psl)
    fixed_octad_points = tuple(
        index for index in range(8) if all(permutation[index] == index for permutation in parent_permutations)
    )
    assert len(fixed_octad_points) == 1
    conjugated_parent = {conjugate_permutation(element, labels) for element in parent_permutations}
    standard_fixed = labels[fixed_octad_points[0]]
    standard_point_stabilizer = {element for element in psl if element[standard_fixed] == standard_fixed}
    assert conjugated_parent == standard_point_stabilizer

    octad_index = {point: index for index, point in enumerate(octad)}
    decoration_to_point: dict[tuple[Vector, ...], int] = {}
    for matrix in octad_group4:
        decoration = tuple(sorted(apply_projectivity(matrix, point) for point in parent))
        point_index = octad_index[apply_projectivity(matrix, octad[fixed_octad_points[0]])]
        if decoration in decoration_to_point:
            assert decoration_to_point[decoration] == point_index
        decoration_to_point[decoration] = point_index
    assert len(decoration_to_point) == 8
    assert set(decoration_to_point.values()) == set(range(8))

    unitary_generators = matrix_generators(unitary_group)
    octad_generators = matrix_generators(octad_group3)
    parent_generators = matrix_generators(parent_group3)
    cosets, coset_lookup = left_cosets(unitary_group, octad_group3)
    assert len(cosets) == 36
    coset_group = {coset_permutation(matrix, cosets, coset_lookup) for matrix in unitary_group}
    coset_stabilizer = {coset_permutation(matrix, cosets, coset_lookup) for matrix in octad_group3}
    assert len(coset_group) == 6048 and len(coset_stabilizer) == 168
    assert {permutation[coset_lookup[identity(3)]] for permutation in coset_group} == set(range(36))
    subdegrees = subgroup_orbit_sizes(coset_stabilizer)
    assert subdegrees == (1, 7, 7, 21)
    semilinear_coset_action = tuple(
        coset_lookup[semilinear_conjugate(semilinear_matrix3, coset[0])]
        for coset in cosets
    )
    semilinear_stabilizer_action = permutation_closure(
        permutation_generators(coset_stabilizer) + (semilinear_coset_action,)
    )
    full_semilinear_action = permutation_closure(
        permutation_generators(coset_group) + (semilinear_coset_action,)
    )
    assert len(semilinear_stabilizer_action) == 336
    assert len(full_semilinear_action) == 12096
    semilinear_subdegrees = subgroup_orbit_sizes(semilinear_stabilizer_action)
    assert semilinear_subdegrees == (1, 14, 21)
    linear_orbits = subgroup_orbits(coset_stabilizer)
    orbit_index = {orbit: index for index, orbit in enumerate(linear_orbits)}
    fusion_permutation = tuple(
        orbit_index[frozenset(semilinear_coset_action[point] for point in orbit)]
        for orbit in linear_orbits
    )
    assert fusion_permutation == (0, 2, 1, 3)

    curve_permutations = {point_permutation(matrix, curve) for matrix in unitary_group}
    assert len(curve_permutations) == 6048
    octad_order_distribution = order_distribution(octad_permutations)
    parent_order_distribution = order_distribution(parent_permutations)
    assert octad_order_distribution == {1: 1, 2: 21, 3: 56, 4: 42, 7: 48}
    assert parent_order_distribution == {1: 1, 3: 14, 7: 6}

    coset_representatives = tuple(coset[0] for coset in cosets)
    coset_generator_actions = tuple(coset_permutation(generator, cosets, coset_lookup) for generator in unitary_generators)
    return {
        "schema": SCHEMA,
        "field": {
            "order": 9,
            "prime": 3,
            "basis": "F_3[x]/(x^2+1), encoded a+3b",
        },
        "c405_input": {
            "json": f"notes/{C405_STEM}.json",
            "bytes": Path(__file__).with_name(f"{C405_STEM}.json").stat().st_size,
            "sha256": C405_JSON_SHA256,
            "octad_points": octad,
            "parent_points": parent,
            "quadric_net_basis": quadrics,
            "hermitian_matrix": hermitian,
        },
        "projective_unitary_group": {
            "identification": "PGU(3,3)=PSU(3,3)",
            "construction": "all projectivities satisfying g^(3T) H g = scalar*H",
            "hermitian_curve_points": len(curve),
            "order_formula": "3^3*(3^3+1)*(3^2-1)",
            "order": len(unitary_group),
            "generator_count": len(unitary_generators),
            "generators": unitary_generators,
            "element_order_distribution_on_28_points": json_int_key_dict(order_distribution(curve_permutations)),
        },
        "octad_stabilizer": {
            "identification": "PSL_2(7)",
            "order": len(octad_group3),
            "index_in_projective_unitary_group": len(unitary_group) // len(octad_group3),
            "all_induced_net_actions_unitary": octad_group3 <= unitary_group,
            "generator_count": len(octad_generators),
            "generators_on_net": octad_generators,
            "element_order_distribution_on_octad": json_int_key_dict(octad_order_distribution),
            "standard_p1_f7_label_map": labels,
            "conjugate_to_standard_psl2_7": True,
            "c405_semilinear_order": c405_upgrade["semilinear_stabilizer"],
        },
        "parent_stabilizer": {
            "identification": "7:3",
            "order": len(parent_group3),
            "index_in_octad_stabilizer": len(octad_group3) // len(parent_group3),
            "generator_count": len(parent_generators),
            "generators_on_net": parent_generators,
            "element_order_distribution_on_octad": json_int_key_dict(parent_order_distribution),
            "fixed_octad_point": fixed_octad_points[0],
            "fixed_standard_p1_f7_point": standard_fixed,
            "equals_standard_psl2_7_point_stabilizer": True,
            "c405_semilinear_order": c405_upgrade["pair_semilinear_stabilizer"],
        },
        "parent_decoration_recovery": {
            "decoration_orbit_size": len(decoration_to_point),
            "octad_point_orbit_size": len(set(decoration_to_point.values())),
            "equivariant_bijection": True,
            "base_parent_recovers_octad_point": fixed_octad_points[0],
            "decoration_to_octad_point": tuple(
                {"parent": decoration, "octad_point": point}
                for decoration, point in sorted(decoration_to_point.items())
            ),
        },
        "subgroup_tower": {
            "orders": (21, 168, 6048),
            "strict": parent_group3 < octad_group3 < unitary_group,
            "indices": (8, 36),
        },
        "determinantal_class_action": {
            "classical_total_for_smooth_plane_quartic_in_characteristic_not_two": 36,
            "explicit_left_cosets": len(cosets),
            "transitive": True,
            "faithful_action_order": len(coset_group),
            "point_stabilizer_order": len(coset_stabilizer),
            "rank": len(subdegrees),
            "subdegrees": subdegrees,
            "all_classes_have_f9_representatives": True,
            "coset_representatives": coset_representatives,
            "unitary_generator_actions": coset_generator_actions,
        },
        "semilinear_fusion": {
            "semilinear_group_order": len(full_semilinear_action),
            "determinantal_class_stabilizer_order": len(semilinear_stabilizer_action),
            "linear_part_on_net": semilinear_matrix3,
            "class_permutation_order": permutation_order(semilinear_coset_action),
            "projective_subdegrees": subdegrees,
            "semilinear_subdegrees": semilinear_subdegrees,
            "projective_orbit_fusion_permutation": fusion_permutation,
            "two_seven_point_suborbits_are_exchanged": True,
        },
        "trusted_boundary": [
            "finite-field arithmetic and exhaustive projective-frame enumeration in this checker",
            "C405's pinned octad, parent, quadric-net, and Hermitian-matrix certificate",
            "the Cayley-octad/even-theta correspondence and the total of 36 symmetric determinantal classes",
            "equivalence by GL_4 congruence, whose stabilizer is the induced projective octad stabilizer",
        ],
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = generate()
    encoded = canonical_bytes(payload)
    path = Path(__file__).with_name(f"{STEM}.json")
    if args.write:
        path.write_bytes(encoded)
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory) / path.name
            temporary.write_bytes(encoded)
            assert path.read_bytes() == temporary.read_bytes()
    summary = {
        "sha256": hashlib.sha256(encoded).hexdigest(),
        "orders": payload["subgroup_tower"]["orders"],
        "determinantal_classes": payload["determinantal_class_action"]["explicit_left_cosets"],
        "subdegrees": payload["determinantal_class_action"]["subdegrees"],
        "semilinear_subdegrees": payload["semilinear_fusion"]["semilinear_subdegrees"],
        "parent_decoration_recovery": payload["parent_decoration_recovery"]["equivariant_bijection"],
    }
    print(json.dumps(summary, sort_keys=True))


if __name__ == "__main__":
    main()
