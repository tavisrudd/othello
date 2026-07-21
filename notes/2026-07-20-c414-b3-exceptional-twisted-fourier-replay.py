#!/usr/bin/env python3
"""Independent q=7 replay using matching stabilizers and a last-pivot gauge."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERT = json.loads((ROOT / "2026-07-20-c414-b3-exceptional-twisted-fourier.json").read_text())
SOURCE = json.loads((ROOT / "2026-07-20-c406-matching-orbit-scout.json").read_text())
Q = 7
ORDER = 6
ZERO = (0, 0)
ONE = (1, 0)
IDENTITY = ((1, 0, 0), (0, 1, 0), (0, 0, 1))


def add(left, right):
    return left[0] + right[0], left[1] + right[1]


def neg(value):
    return -value[0], -value[1]


def multiply(left, right):
    # zeta_6^2-zeta_6+1=0.
    a, b = left
    c, d = right
    return a * c - b * d, a * d + b * c + b * d


def sum_values(values):
    answer = ZERO
    for value in values:
        answer = add(answer, value)
    return answer


def root_powers():
    roots = [ONE]
    zeta = (0, 1)
    for _ in range(1, ORDER):
        roots.append(multiply(roots[-1], zeta))
    assert multiply(roots[-1], zeta) == ONE
    return tuple(roots)


ROOTS = root_powers()


def cyclotomic_matrix_product(left, right):
    return [
        [
            sum_values(multiply(left[i][k], right[k][j]) for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def normalize_pair(pair):
    pivot = next(value % Q for value in pair if value % Q)
    inverse = pow(pivot, -1, Q)
    return tuple(value * inverse % Q for value in pair)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def inverse_permutation(permutation):
    answer = [0] * len(permutation)
    for index, image in enumerate(permutation):
        answer[image] = index
    return tuple(answer)


def conjugate(permutation, subgroup):
    inverse = inverse_permutation(permutation)
    return frozenset(compose(compose(permutation, element), inverse) for element in subgroup)


def mobius_group():
    parameters = tuple([(1, value) for value in range(Q)] + [(0, 1)])
    point_index = {point: index for index, point in enumerate(parameters)}
    actions = {}
    for entries in itertools.product(range(Q), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % Q
        if not determinant:
            continue
        if next(value for value in entries if value) != 1:
            continue
        permutation = tuple(
            point_index[normalize_pair((a * x + b * y, c * x + d * y))]
            for x, y in parameters
        )
        actions[permutation] = determinant
    squares = {1, 2, 4}
    full = set(actions)
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    assert len(full) == 336 and len(psl) == 168
    return full, psl


def matching_image(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def stabilizer(group, matching):
    return {element for element in group if matching_image(element, matching) == matching}


def mat_mul(left, right):
    columns = tuple(zip(*right))
    return tuple(
        tuple(sum(row[k] * column[k] for k in range(3)) % Q for column in columns)
        for row in left
    )


def mat_vec(matrix, vector):
    return tuple(sum(row[index] * vector[index] for index in range(3)) % Q for row in matrix)


def mat_inverse(matrix):
    work = [
        [matrix[row][column] % Q for column in range(3)]
        + [int(row == column) for column in range(3)]
        for row in range(3)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        scalar = pow(work[column][column], -1, Q)
        work[column] = [value * scalar % Q for value in work[column]]
        for row in range(3):
            if row == column:
                continue
            scalar = work[row][column]
            work[row] = [
                (value - scalar * pivot_value) % Q
                for value, pivot_value in zip(work[row], work[column])
            ]
    return tuple(tuple(row[3:]) for row in work)


def determinant(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % Q


def normalize_matrix(matrix):
    pivot = next(value for row in matrix for value in row if value)
    inverse = pow(pivot, -1, Q)
    return tuple(tuple(value * inverse % Q for value in row) for row in matrix)


def columns_matrix(columns):
    return tuple(tuple(columns[column][row] for column in range(3)) for row in range(3))


def frame_matrix(points):
    basis = columns_matrix(points[:3])
    coordinates = mat_vec(mat_inverse(basis), points[3])
    assert all(coordinates)
    return tuple(
        tuple(basis[row][column] * coordinates[column] % Q for column in range(3))
        for row in range(3)
    )


def frame_map(source, target):
    return normalize_matrix(mat_mul(frame_matrix(target), mat_inverse(frame_matrix(source))))


def normalize_last(vector):
    pivot = next(value for value in reversed(vector) if value)
    inverse = pow(pivot, -1, Q)
    return tuple(value * inverse % Q for value in vector)


def last_scale(vector):
    return next(value for value in reversed(vector) if value)


def canonical_lift(conic, permutation):
    matrix = frame_map(conic[:4], [conic[permutation[index]] for index in range(4)])
    assert all(normalize_last(mat_vec(matrix, conic[index])) == normalize_last(conic[permutation[index]]) for index in range(Q + 1))
    gram = mat_mul(tuple(zip(*matrix)), matrix)
    multiplier = gram[0][0]
    assert gram == tuple(
        tuple(multiplier * int(i == j) % Q for j in range(3)) for i in range(3)
    )
    scalar = multiplier * pow(determinant(matrix), -1, Q) % Q
    lift = tuple(tuple(scalar * entry % Q for entry in row) for row in matrix)
    assert determinant(lift) == 1 and mat_mul(tuple(zip(*lift)), lift) == IDENTITY
    return lift


def projective_points():
    return (
        [(x, y, 1) for x in range(Q) for y in range(Q)]
        + [(x, 1, 0) for x in range(Q)]
        + [(1, 0, 0)]
    )


def projective_orbits(group, points):
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {normalize_last(mat_vec(matrix, seed)) for matrix in group}
        unseen -= orbit
        answer.append((seed, orbit))
    return sorted(answer, key=lambda item: (len(item[1]), item[0]))


def invariant_sections(group, points, point_index, weight, logs):
    records, killed = [], []
    for seed, orbit in projective_orbits(group, points):
        assigned = {}
        consistent = True
        for matrix in group:
            image = mat_vec(matrix, seed)
            target = normalize_last(image)
            exponent = (-weight * logs[last_scale(image)]) % ORDER
            consistent &= target not in assigned or assigned[target] == exponent
            assigned[target] = exponent
        assert set(assigned) == orbit
        if not consistent:
            killed.append(len(orbit))
            continue
        section = [None] * len(points)
        for point, exponent in assigned.items():
            section[point_index[point]] = exponent
        records.append({"seed": seed, "orbit": orbit, "section": section})
    return records, sorted(killed)


def apply_group(matrix, points, point_index, section, weight, logs):
    inverse = mat_inverse(matrix)
    answer = []
    for point in points:
        preimage = mat_vec(inverse, point)
        target = normalize_last(preimage)
        value = section[point_index[target]]
        answer.append(None if value is None else (value + weight * logs[last_scale(preimage)]) % ORDER)
    return answer


def involution_action(matrix, points, point_index, records, weight, logs):
    support_index = {frozenset(record["orbit"]): index for index, record in enumerate(records)}
    actions = []
    for record in records:
        transformed = apply_group(matrix, points, point_index, record["section"], weight, logs)
        support = frozenset(points[index] for index, value in enumerate(transformed) if value is not None)
        target = support_index[support]
        coefficient = transformed[point_index[records[target]["seed"]]]
        assert coefficient is not None
        actions.append((target, coefficient))
    return actions


def parity_basis(actions, parity):
    basis, visited = [], set()
    for index, (target, coefficient) in enumerate(actions):
        if index in visited:
            continue
        visited |= {index, target}
        vector = [ZERO] * len(actions)
        if target == index:
            sign = 1 if coefficient == 0 else -1 if coefficient == ORDER // 2 else None
            assert sign is not None
            if sign == parity:
                vector[index] = ONE
                basis.append(vector)
        elif index < target:
            vector[index] = ONE
            vector[target] = ROOTS[coefficient] if parity == 1 else neg(ROOTS[coefficient])
            basis.append(vector)
    return basis


def kernel_image(points, section, weight, logs):
    answer = []
    for target in points:
        total = ZERO
        for source, exponent in zip(points, section):
            if exponent is None:
                continue
            pairing = sum(x * y for x, y in zip(target, source)) % Q
            if pairing:
                total = add(total, ROOTS[(exponent - weight * logs[pairing]) % ORDER])
        answer.append(total)
    return answer


def fourier_matrix(points, point_index, source, target, weight, logs):
    matrix = [[ZERO for _ in source] for _ in target]
    for column, record in enumerate(source):
        image = kernel_image(points, record["section"], weight, logs)
        rebuilt = [ZERO] * len(points)
        for row, target_record in enumerate(target):
            coefficient = image[point_index[target_record["seed"]]]
            matrix[row][column] = coefficient
            for index, exponent in enumerate(target_record["section"]):
                if exponent is not None:
                    rebuilt[index] = multiply(coefficient, ROOTS[exponent])
        assert rebuilt == image
    return matrix


def coordinates(vector, basis):
    remainder = list(vector)
    answer = []
    for column in basis:
        pivot = next(index for index, value in enumerate(column) if value != ZERO)
        assert column[pivot] == ONE
        coefficient = remainder[pivot]
        answer.append(coefficient)
        remainder = [add(value, neg(multiply(coefficient, entry))) for value, entry in zip(remainder, column)]
    assert all(value == ZERO for value in remainder)
    return answer


def restrict(matrix, source_basis, target_basis):
    columns = []
    for source in source_basis:
        image = [
            sum_values(multiply(matrix[row][column], source[column]) for column in range(len(source)))
            for row in range(len(matrix))
        ]
        columns.append(coordinates(image, target_basis))
    return [[columns[column][row] for column in range(len(columns))] for row in range(len(target_basis))]


def convert_matrix(value):
    return [[tuple(entry) for entry in row] for row in value]


def main():
    assert CERT["schema"] == "c414-b3-exceptional-twisted-fourier-v1"
    b3 = next(record for record in SOURCE["types"] if record["type"] == "B3")
    conic = [tuple(point) for point in b3["conic_points"]]
    base_matching = tuple(tuple(edge) for edge in b3["coxeter_invariant_matching"])
    full, psl = mobius_group()
    parent = stabilizer(full, base_matching)
    assert len(parent) == 24 and parent <= psl
    opposite_matchings = sorted(
        {matching_image(element, base_matching) for element in full - psl}
    )
    assert len(opposite_matchings) == 7
    points = projective_points()
    point_index = {point: index for index, point in enumerate(points)}
    logs = {pow(3, exponent, Q): exponent for exponent in range(ORDER)}
    identity_permutation = tuple(range(Q + 1))
    checked_block_types = set()
    dimension_summary = Counter()

    for matching in opposite_matchings:
        other = stabilizer(full, matching)
        common_permutations = parent & other
        seam_type = "S3" if len(common_permutations) == 6 else "D8"
        common = {canonical_lift(conic, element) for element in common_permutations}
        swaps = [
            element
            for element in full - psl
            if conjugate(element, parent) == frozenset(other)
            and conjugate(element, other) == frozenset(parent)
        ]
        involutions = sorted(element for element in swaps if compose(element, element) == identity_permutation)
        assert len(involutions) == 4
        by_weight = {}
        for weight in (-1, 1, 2, 4):
            records, killed = invariant_sections(common, points, point_index, weight, logs)
            dimensions = set()
            chosen = None
            for permutation in involutions:
                matrix = canonical_lift(conic, permutation)
                actions = involution_action(matrix, points, point_index, records, weight, logs)
                even, odd = parity_basis(actions, 1), parity_basis(actions, -1)
                dimensions.add((len(even), len(odd)))
                if permutation == involutions[0]:
                    chosen = (even, odd)
            assert len(dimensions) == 1 and chosen is not None
            even, odd = chosen
            by_weight[weight] = (records, even, odd)
            dimension_summary[(seam_type, weight, len(records), len(even), len(odd), tuple(killed))] += 1

        if seam_type not in checked_block_types:
            source, _source_even, source_odd = by_weight[2]
            target, _target_even, target_odd = by_weight[4]
            forward = fourier_matrix(points, point_index, source, target, 2, logs)
            reverse = fourier_matrix(points, point_index, target, source, 4, logs)
            forward_odd = restrict(forward, source_odd, target_odd)
            reverse_odd = restrict(reverse, target_odd, source_odd)
            identity = [[(49 * int(i == j), 0) for j in range(4)] for i in range(4)]
            assert cyclotomic_matrix_product(reverse_odd, forward_odd) == identity
            checked_block_types.add(seam_type)

    expected = Counter(
        {
            ("S3", -1, 6, 1, 5, (1, 2, 3, 3, 3, 3, 3, 3, 3)): 4,
            ("S3", 1, 6, 1, 5, (1, 2, 3, 3, 3, 3, 3, 3, 3)): 4,
            ("S3", 2, 14, 10, 4, (2,)): 4,
            ("S3", 4, 14, 10, 4, (2,)): 4,
            ("D8", -1, 3, 0, 3, (1, 2, 2, 4, 4, 4, 4, 4, 4, 4)): 3,
            ("D8", 1, 3, 0, 3, (1, 2, 2, 4, 4, 4, 4, 4, 4, 4)): 3,
            ("D8", 2, 13, 9, 4, ()): 3,
            ("D8", 4, 13, 9, 4, ()): 3,
        }
    )
    assert dimension_summary == expected and checked_block_types == {"S3", "D8"}

    identity = [[(49 * int(i == j), 0) for j in range(4)] for i in range(4)]
    for record in CERT["seams"]:
        block = record["factorization_odd_block"]
        assert cyclotomic_matrix_product(
            convert_matrix(block["reverse"]), convert_matrix(block["forward"])
        ) == identity
    print("C414 independent q=7 B3 exceptional twisted Fourier replay OK")


if __name__ == "__main__":
    main()
