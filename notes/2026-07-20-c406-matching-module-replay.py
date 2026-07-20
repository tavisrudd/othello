#!/usr/bin/env python3
"""Independent replay of the C406 harmonic and cubic-memory claims."""

from __future__ import annotations

import itertools
import json
import functools
from pathlib import Path


HERE = Path(__file__).resolve().parent
SCOUT = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
PRIMARY = json.loads((HERE / "2026-07-20-c406-matching-module.json").read_text())


def mobius_groups(q):
    points = tuple([(1, value) for value in range(q)] + [(0, 1)])
    point_index = {point: index for index, point in enumerate(points)}
    actions = {}
    for a, b, c, d in itertools.product(range(q), repeat=4):
        determinant = (a * d - b * c) % q
        if not determinant:
            continue
        entries = (a, b, c, d)
        pivot = next(value for value in entries if value)
        if pivot != 1:
            continue
        permutation = []
        for left, right in points:
            image = ((a * left + b * right) % q, (c * left + d * right) % q)
            if image[0]:
                scale = pow(image[0], -1, q)
            else:
                scale = pow(image[1], -1, q)
            permutation.append(point_index[(image[0] * scale % q, image[1] * scale % q)])
        actions[tuple(permutation)] = determinant
    squares = {value * value % q for value in range(1, q)}
    return points, set(actions), {action for action, determinant in actions.items() if determinant in squares}


def image_matching(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching))


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def invert(permutation):
    result = [0] * len(permutation)
    for index, value in enumerate(permutation):
        result[value] = index
    return tuple(result)


def element_order(permutation):
    identity = tuple(range(len(permutation)))
    power = identity
    for order in range(1, 61):
        power = compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError


def monomials(degree):
    return tuple((a, b, degree - a - b) for a in range(degree + 1) for b in range(degree - a + 1))


def polynomial_product(left, right, q):
    answer = {}
    for alpha, coefficient_left in left.items():
        for beta, coefficient_right in right.items():
            exponent = tuple(alpha[index] + beta[index] for index in range(3))
            answer[exponent] = (answer.get(exponent, 0) + coefficient_left * coefficient_right) % q
    return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}


def secant_product(matching, endpoints, q):
    answer = {(0, 0, 0): 1}
    for left, right in matching:
        s, t = endpoints[left]
        u, v = endpoints[right]
        answer = polynomial_product(
            answer,
            {(1, 0, 0): t * v % q, (0, 1, 0): -(s * v + t * u) % q, (0, 0, 1): s * u % q},
            q,
        )
    return answer


def row_reduce(rows, q):
    data = [[value % q for value in row] for row in rows]
    pivots = []
    row = 0
    for column in range(len(data[0]) if data else 0):
        found = next((index for index in range(row, len(data)) if data[index][column]), None)
        if found is None:
            continue
        data[row], data[found] = data[found], data[row]
        inverse = pow(data[row][column], -1, q)
        data[row] = [value * inverse % q for value in data[row]]
        for other in range(len(data)):
            if other == row or not data[other][column]:
                continue
            multiplier = data[other][column]
            data[other] = [(x - multiplier * y) % q for x, y in zip(data[other], data[row])]
        pivots.append(column)
        row += 1
        if row == len(data):
            break
    return data, pivots


def matrix_rank(rows, q):
    return len(row_reduce(rows, q)[1]) if rows else 0


def conic_quotient(difference, degree, q):
    source = monomials(degree)
    target = monomials(degree + 2)
    index = {exponent: position for position, exponent in enumerate(target)}
    rows = [[0] * len(source) for _ in target]
    for column, exponent in enumerate(source):
        for shift, coefficient in (((1, 0, 1), 1), ((0, 2, 0), -1)):
            product = tuple(exponent[position] + shift[position] for position in range(3))
            rows[index[product]][column] = coefficient % q
    augmented = [row + [difference.get(exponent, 0)] for row, exponent in zip(rows, target)]
    reduced, pivots = row_reduce(augmented, q)
    assert len(source) not in pivots
    answer = [0] * len(source)
    for row, pivot in enumerate(pivots):
        if pivot < len(source):
            answer[pivot] = reduced[row][-1]
    return answer


def transpose(columns):
    return [list(row) for row in zip(*columns)] if columns else []


def laplacian_kernel_dimension(degree, q):
    if degree < 2:
        return len(monomials(degree))
    source = monomials(degree)
    target = monomials(degree - 2)
    index = {exponent: position for position, exponent in enumerate(target)}
    rows = [[0] * len(source) for _ in target]
    for column, (a, b, c) in enumerate(source):
        if a and c:
            rows[index[(a - 1, b, c - 1)]][column] += 4 * a * c
        if b >= 2:
            rows[index[(a, b - 2, c)]][column] -= b * (b - 1)
    return len(source) - matrix_rank(rows, q)


def power_coordinates(vector, degree, q):
    return tuple(
        product % q
        for indices in itertools.combinations_with_replacement(range(len(vector)), degree)
        for product in [
            functools.reduce(lambda value, index: value * vector[index], indices, 1)
        ]
    )


def subset_sums(features, q):
    records = []
    for mask in range(1 << len(features)):
        total = [0] * len(features[0])
        count = 0
        for index, feature in enumerate(features):
            if mask >> index & 1:
                count += 1
                total = [(left + right) % q for left, right in zip(total, feature)]
        records.append((count, tuple(total), mask))
    return records


def zero_moment_halves(features, q):
    split = len(features) // 2
    target = [sum(feature[index] for feature in features) * pow(2, -1, q) % q for index in range(len(features[0]))]
    right = {}
    for count, total, mask in subset_sums(features[split:], q):
        right.setdefault((count, total), []).append(mask)
    solutions = []
    for count, total, left_mask in subset_sums(features[:split], q):
        needed = tuple((target[index] - total[index]) % q for index in range(len(target)))
        for right_mask in right.get((q - count, needed), ()):
            solutions.append((left_mask, right_mask))
    return len(solutions)


def replay_type(scout_record, primary_record):
    name = scout_record["type"]
    q = scout_record["field_order"]
    endpoints, pgl, psl = mobius_groups(q)
    base = tuple(tuple(pair) for pair in scout_record["coxeter_invariant_matching"])
    orbit = sorted({image_matching(group_element, base) for group_element in pgl})
    assert len(orbit) == scout_record["target_orbit_size"]
    stabilizer = {element for element in pgl if image_matching(element, base) == base}
    assert len(stabilizer) == scout_record["coxeter_parent_order"]

    fixed_by_signature = {}
    for element in stabilizer:
        centralizer = sum(compose(element, other) == compose(other, element) for other in stabilizer)
        signature = (element_order(element), centralizer)
        fixed = sum(image_matching(element, matching) == matching for matching in orbit)
        fixed_by_signature.setdefault(signature, set()).add(fixed)
    assert all(len(values) == 1 for values in fixed_by_signature.values())
    expected_by_signature = {}
    for record in primary_record["classes"]:
        signature = (record["element_order"], len(stabilizer) // record["size"])
        expected_by_signature.setdefault(signature, set()).add(record["fixed_matchings"])
    assert fixed_by_signature == expected_by_signature

    polynomial_degree = (q + 1) // 2
    quotient_degree = polynomial_degree - 2
    base_product = secant_product(base, endpoints, q)
    vectors = []
    for matching in orbit:
        product = secant_product(matching, endpoints, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        vectors.append(conic_quotient(difference, quotient_degree, q))
    image_rows = transpose(vectors)
    image_rank = matrix_rank(image_rows, q)
    assert image_rank == primary_record["factorization_difference_image_rank"]
    harmonic_dimension = laplacian_kernel_dimension(quotient_degree, q)
    assert harmonic_dimension == primary_record["harmonic_dimension"]
    assert image_rank == harmonic_dimension + (quotient_degree % 2 == 0)

    if name in ("B3", "H3"):
        sheet = {image_matching(element, base) for element in psl}
        signs = [1 if matching in sheet else -1 % q for matching in orbit]
        _reduced, coordinate_rows = row_reduce(transpose(image_rows), q)
        coordinates = [[vector[index] for index in coordinate_rows] for vector in vectors]
        moments = []
        for degree in (1, 2, 3):
            powers = [power_coordinates(vector, degree, q) for vector in coordinates]
            moment = [sum(sign * power[index] for sign, power in zip(signs, powers)) % q for index in range(len(powers[0]))]
            moments.append(any(moment))
        assert moments == [False, False, True]
        features = [list(vector) + list(power_coordinates(vector, 2, q)) for vector in coordinates]
        assert zero_moment_halves(features, q) == 2
        assert primary_record["outer_sheet_sign"]["first_nonzero_moment_degree"] == 3
        assert primary_record["outer_sheet_sign"]["equal_halves_with_vanishing_moments_through_degree_2"] == 2


def main():
    primary_by_type = {record["type"]: record for record in PRIMARY["types"]}
    for scout_record in SCOUT["types"]:
        replay_type(scout_record, primary_by_type[scout_record["type"]])
    print("C406 Gate 2/3 independent replay OK")


if __name__ == "__main__":
    main()
