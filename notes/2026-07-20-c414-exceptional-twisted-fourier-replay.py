#!/usr/bin/env python3
"""Independent q=11 replay for the exceptional twisted-Fourier restriction."""

from __future__ import annotations

import importlib.util
import json
import sys
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERT = json.loads((ROOT / "2026-07-20-c414-exceptional-twisted-fourier.json").read_text())
Q = 11
ORDER = 10
PHI10 = (1, -1, 1, -1, 1)
ZERO = (0, 0, 0, 0)
ONE = (1, 0, 0, 0)


def load_independent_h3():
    path = ROOT / "2026-07-19-c378-clebsch-common-duality-replay.py"
    spec = importlib.util.spec_from_file_location("c414_t1_independent_h3", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def determinant(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % Q


def negate_matrix(matrix):
    return tuple(tuple(-entry % Q for entry in row) for row in matrix)


def matrix_order(h3, matrix):
    power = h3.I
    for order in range(1, 25):
        power = h3.mm(power, matrix)
        if power == h3.I:
            return order
    raise AssertionError


def normalize_last(vector):
    pivot = next(value for value in reversed(vector) if value)
    inverse = pow(pivot, -1, Q)
    return tuple(value * inverse % Q for value in vector)


def last_scale(vector):
    return next(value for value in reversed(vector) if value)


def projective_points():
    return [(x, y, 1) for x in range(Q) for y in range(Q)] + [(x, 1, 0) for x in range(Q)] + [(1, 0, 0)]


def root_bases():
    degree = 4
    powers = []
    for exponent in range(ORDER):
        if exponent < degree:
            vector = [0] * degree
            vector[exponent] = 1
        else:
            shifted = [0] + list(powers[-1])
            leading = shifted.pop()
            vector = [shifted[index] - leading * PHI10[index] for index in range(degree)]
        powers.append(tuple(vector))
    return tuple(powers)


ROOTS = root_bases()


def add(left, right):
    return tuple(x + y for x, y in zip(left, right))


def neg(value):
    return tuple(-x for x in value)


def reduce_poly(coefficients):
    work = list(coefficients) + [0] * max(0, 5 - len(coefficients))
    for current in range(len(work) - 1, 3, -1):
        leading = work[current]
        offset = current - 4
        for index, coefficient in enumerate(PHI10):
            work[offset + index] -= leading * coefficient
    return tuple(work[:4])


def multiply(left, right):
    raw = [0] * 7
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            raw[i + j] += x * y
    return reduce_poly(raw)


def sum_values(values):
    answer = ZERO
    for value in values:
        answer = add(answer, value)
    return answer


def matrix_product(left, right):
    return [
        [sum_values(multiply(left[i][k], right[k][j]) for k in range(len(right))) for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def projective_orbits(h3, group, points):
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {normalize_last(h3.mv(matrix, seed)) for matrix in group}
        unseen -= orbit
        answer.append((seed, orbit))
    return sorted(answer, key=lambda item: (len(item[1]), item[0]))


def invariant_sections(h3, group, points, point_index, weight, logs):
    records, killed = [], []
    for seed, orbit in projective_orbits(h3, group, points):
        assigned = {}
        good = True
        for matrix in group:
            image = h3.mv(matrix, seed)
            target = normalize_last(image)
            exponent = (-weight * logs[last_scale(image)]) % ORDER
            good &= target not in assigned or assigned[target] == exponent
            assigned[target] = exponent
        assert set(assigned) == orbit
        if not good:
            killed.append(len(orbit))
            continue
        section = [None] * len(points)
        for point, exponent in assigned.items():
            section[point_index[point]] = exponent
        records.append({"seed": seed, "orbit": orbit, "section": section})
    return records, sorted(killed)


def apply_group(h3, matrix, inverse, points, point_index, section, weight, logs):
    answer = []
    for point in points:
        preimage = h3.mv(inverse, point)
        target = normalize_last(preimage)
        value = section[point_index[target]]
        answer.append(None if value is None else (value + weight * logs[last_scale(preimage)]) % ORDER)
    return answer


def j_action(h3, points, point_index, records, weight, logs):
    support_index = {frozenset(record["orbit"]): index for index, record in enumerate(records)}
    actions = []
    for record in records:
        transformed = apply_group(h3, h3.J, h3.J, points, point_index, record["section"], weight, logs)
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
            sign = 1 if coefficient == 0 else -1 if coefficient == 5 else None
            assert sign is not None
            if sign == parity:
                vector[index] = ONE
                basis.append(vector)
        elif index < target:
            vector[index] = ONE
            vector[target] = ROOTS[coefficient] if parity == 1 else neg(ROOTS[coefficient])
            basis.append(vector)
    return basis


def kernel_image(h3, points, section, weight, logs):
    answer = []
    for target in points:
        total = ZERO
        for source, exponent in zip(points, section):
            if exponent is None:
                continue
            value = h3.dot(target, source)
            if value:
                total = add(total, ROOTS[(exponent - weight * logs[value]) % ORDER])
        answer.append(total)
    return answer


def invariant_fourier(h3, points, point_index, source, target, weight, logs):
    result = [[ZERO for _ in source] for _ in target]
    for column, record in enumerate(source):
        image = kernel_image(h3, points, record["section"], weight, logs)
        rebuilt = [ZERO] * len(points)
        for row, target_record in enumerate(target):
            coefficient = image[point_index[target_record["seed"]]]
            result[row][column] = coefficient
            for index, exponent in enumerate(target_record["section"]):
                if exponent is not None:
                    rebuilt[index] = multiply(coefficient, ROOTS[exponent])
        assert rebuilt == image
    return result


def coordinates(vector, basis):
    remainder = list(vector)
    answer = []
    for column in basis:
        pivot = next(index for index, value in enumerate(column) if value != ZERO)
        assert column[pivot] == ONE
        coefficient = remainder[pivot]
        answer.append(coefficient)
        remainder = [add(x, neg(multiply(coefficient, y))) for x, y in zip(remainder, column)]
    assert all(value == ZERO for value in remainder)
    return answer


def restrict(matrix, source_basis, target_basis):
    columns = []
    for source in source_basis:
        image = [sum_values(multiply(matrix[row][column], source[column]) for column in range(len(source))) for row in range(len(matrix))]
        columns.append(coordinates(image, target_basis))
    return [[columns[column][row] for column in range(len(columns))] for row in range(len(target_basis))]


def convert_matrix(value):
    return [[tuple(entry) for entry in row] for row in value]


def main():
    assert CERT["schema"] == "c414-exceptional-twisted-fourier-v1"
    h3 = load_independent_h3()
    common = h3.a5(8) & h3.a5(4)
    negative_identity = negate_matrix(h3.I)
    lift_group = common | {negate_matrix(matrix) for matrix in common}
    assert len(lift_group) == 24 and negative_identity in lift_group
    assert {h3.mm(left, right) for left in lift_group for right in lift_group} == lift_group
    lift_orders = Counter(matrix_order(h3, matrix) for matrix in lift_group)
    assert dict(sorted(lift_orders.items())) == {
        int(order): count
        for order, count in CERT["projective_lift_cocycle"]["element_order_counts"].items()
    }
    negative_products = 0
    for left in common:
        for right in common:
            raw = h3.mm(left, right)
            normalized = h3.normm(raw)
            assert raw in {normalized, negate_matrix(normalized)}
            negative_products += raw == negate_matrix(normalized)
    assert negative_products == CERT["projective_lift_cocycle"]["negative_products_in_normalized_section"] == 48

    rotation = {matrix if determinant(matrix) == 1 else negate_matrix(matrix) for matrix in common}
    assert len(rotation) == CERT["projective_lift_cocycle"]["rotation_group_order"] == 12
    assert {h3.mm(left, right) for left in rotation for right in rotation} == rotation
    rotation_orders = Counter(matrix_order(h3, matrix) for matrix in rotation)
    assert dict(sorted(rotation_orders.items())) == {
        int(order): count
        for order, count in CERT["projective_lift_cocycle"]["rotation_group_element_order_counts"].items()
    }

    points = projective_points()
    point_index = {point: index for index, point in enumerate(points)}
    logs = {pow(2, exponent, Q): exponent for exponent in range(ORDER)}
    data = {}
    cert_weights = {record["weight"]: record for record in CERT["weights"]}
    for weight in (-1, 1, 4, 6):
        records, killed = invariant_sections(h3, rotation, points, point_index, weight, logs)
        actions = j_action(h3, points, point_index, records, weight, logs)
        even, odd = parity_basis(actions, 1), parity_basis(actions, -1)
        record = cert_weights[weight]
        assert len(records) == record["twisted_invariant_dimension"]
        assert sorted(len(item["orbit"]) for item in records) == record["surviving_orbit_sizes"]
        assert killed == record["killed_orbit_sizes"]
        assert (len(even), len(odd)) == (record["J_even_dimension"], record["J_odd_dimension"])
        data[weight] = (records, even, odd)

    source, _source_even, source_odd = data[4]
    target, _target_even, target_odd = data[6]
    forward = invariant_fourier(h3, points, point_index, source, target, 4, logs)
    reverse = invariant_fourier(h3, points, point_index, target, source, 6, logs)
    forward_odd = restrict(forward, source_odd, target_odd)
    reverse_odd = restrict(reverse, target_odd, source_odd)
    identity = [[(121 * int(i == j), 0, 0, 0) for j in range(4)] for i in range(4)]
    assert matrix_product(reverse_odd, forward_odd) == identity

    stored_forward = convert_matrix(CERT["factorization_weight_pair"]["parity_blocks"]["odd"]["forward"])
    stored_reverse = convert_matrix(CERT["factorization_weight_pair"]["parity_blocks"]["odd"]["reverse"])
    assert matrix_product(stored_reverse, stored_forward) == identity
    print("C414 independent q=11 exceptional twisted Fourier replay OK")


if __name__ == "__main__":
    main()
