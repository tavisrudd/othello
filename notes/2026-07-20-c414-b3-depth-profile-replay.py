#!/usr/bin/env python3
"""Independent Möbius/Sym^2 replay of the C414 B3 depth theorem."""

from __future__ import annotations

import functools
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE_PATH = HERE / "2026-07-20-c414-b3-depth-profile.json"


def normalize(vector, prime):
    pivot = next(value % prime for value in vector if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(permutation):
    result = [0] * len(permutation)
    for index, image in enumerate(permutation):
        result[image] = index
    return tuple(result)


def matching_image(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def pgl(prime):
    parameters = [(1, value) for value in range(prime)] + [(0, 1)]
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    matrix_by_permutation = {}
    squares = {value * value % prime for value in range(1, prime)}
    psl = set()
    for entries in itertools.product(range(prime), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % prime
        if not determinant:
            continue
        if normalize(entries, prime) != entries:
            continue
        permutation = tuple(
            parameter_index[normalize((a * left + b * right, c * left + d * right), prime)]
            for left, right in parameters
        )
        matrix_by_permutation[permutation] = ((a, b), (c, d))
        if determinant in squares:
            psl.add(permutation)
    return parameters, matrix_by_permutation, psl


def sym2(matrix, prime):
    (a, b), (c, d) = matrix
    return (
        (a * a % prime, 2 * a * b % prime, b * b % prime),
        (a * c % prime, (a * d + b * c) % prime, b * d % prime),
        (c * c % prime, 2 * c * d % prime, d * d % prime),
    )


def mat_vec(matrix, vector, prime):
    return tuple(sum(left * right for left, right in zip(row, vector)) % prime for row in matrix)


def projective_points(prime):
    return sorted(
        {
            normalize(vector, prime)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )


def orbit_partition(group, objects, action):
    index = {value: position for position, value in enumerate(objects)}
    unseen = set(range(len(objects)))
    parts = []
    while unseen:
        seed = min(unseen)
        part = {index[action(element, objects[seed])] for element in group}
        unseen -= part
        parts.append(part)
    return sorted(parts, key=lambda part: (len(part), min(part)))


def perfect_matchings(vertices):
    if not vertices:
        return [()]
    first = vertices[0]
    result = []
    for index in range(1, len(vertices)):
        second = vertices[index]
        remainder = vertices[1:index] + vertices[index + 1 :]
        for tail in perfect_matchings(remainder):
            result.append(tuple(sorted(((first, second),) + tail)))
    return result


def secant_lines(parameters, matching, prime):
    result = []
    for left, right in matching:
        (s_i, t_i), (s_j, t_j) = parameters[left], parameters[right]
        result.append(
            (
                t_i * t_j % prime,
                -(s_i * t_j + t_i * s_j) % prime,
                s_i * s_j % prime,
            )
        )
    return result


def zero_on_product(lines, point, prime):
    return any(sum(a * b for a, b in zip(line, point)) % prime == 0 for line in lines)


def multiply_polynomials(left, right, prime):
    result = {}
    for left_exponent, left_coefficient in left.items():
        for right_exponent, right_coefficient in right.items():
            exponent = tuple(
                left_exponent[index] + right_exponent[index] for index in range(3)
            )
            result[exponent] = (
                result.get(exponent, 0) + left_coefficient * right_coefficient
            ) % prime
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient}


def matching_product(parameters, matching, prime):
    product = {(0, 0, 0): 1}
    for line in secant_lines(parameters, matching, prime):
        product = multiply_polynomials(
            product,
            {(1, 0, 0): line[0], (0, 1, 0): line[1], (0, 0, 1): line[2]},
            prime,
        )
    return product


def homogeneous_basis(degree):
    return tuple(
        (x_degree, y_degree, degree - x_degree - y_degree)
        for x_degree in range(degree + 1)
        for y_degree in range(degree - x_degree + 1)
    )


def rref(matrix, prime):
    data = [[value % prime for value in row] for row in matrix]
    pivots = []
    pivot_row = 0
    for column in range(len(data[0]) if data else 0):
        candidate = next(
            (row for row in range(pivot_row, len(data)) if data[row][column]), None
        )
        if candidate is None:
            continue
        data[pivot_row], data[candidate] = data[candidate], data[pivot_row]
        scale = pow(data[pivot_row][column], -1, prime)
        data[pivot_row] = [value * scale % prime for value in data[pivot_row]]
        for row in range(len(data)):
            if row == pivot_row or not data[row][column]:
                continue
            factor = data[row][column]
            data[row] = [
                (value - factor * pivot) % prime
                for value, pivot in zip(data[row], data[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(data):
            break
    return data, pivots


def rank(matrix, prime):
    return len(rref(matrix, prime)[1]) if matrix else 0


def quotient_by_conic(polynomial, prime):
    source = homogeneous_basis(2)
    target = homogeneous_basis(4)
    target_index = {exponent: index for index, exponent in enumerate(target)}
    matrix = [[0] * len(source) for _ in target]
    for column, exponent in enumerate(source):
        x_degree, y_degree, z_degree = exponent
        matrix[target_index[(x_degree + 1, y_degree, z_degree + 1)]][column] = 1
        matrix[target_index[(x_degree, y_degree + 2, z_degree)]][column] = -1 % prime
    rhs = [polynomial.get(exponent, 0) for exponent in target]
    reduced, pivots = rref(
        [row + [rhs[index]] for index, row in enumerate(matrix)], prime
    )
    assert len(source) not in pivots
    solution = [0] * len(source)
    for row, pivot in enumerate(pivots):
        if pivot < len(source):
            solution[pivot] = reduced[row][-1]
    reconstructed = multiply_polynomials(
        {exponent: coefficient for exponent, coefficient in zip(source, solution) if coefficient},
        {(1, 0, 1): 1, (0, 2, 0): -1 % prime},
        prime,
    )
    assert reconstructed == polynomial
    return solution


def subtract(left, right, prime):
    return {
        exponent: value
        for exponent in set(left) | set(right)
        for value in [(left.get(exponent, 0) - right.get(exponent, 0)) % prime]
        if value
    }


def symmetric_power(vector, degree, prime):
    return [
        functools.reduce(lambda value, index: value * vector[index] % prime, indices, 1)
        for indices in itertools.combinations_with_replacement(range(len(vector)), degree)
    ]


def canonical_signature(pair_sizes, weights, profiles):
    candidates = []
    for permutation in itertools.permutations(range(len(pair_sizes))):
        sizes = tuple(pair_sizes[index] for index in permutation)
        for signs in itertools.product((-1, 1), repeat=len(pair_sizes)):
            rows = sorted(
                (
                    weight,
                    tuple(
                        signs[column] * profile[permutation[column]]
                        for column in range(len(pair_sizes))
                    ),
                )
                for weight, profile in zip(weights, profiles)
            )
            candidates.append((sizes, tuple(rows)))
    return min(candidates)


def digest(value):
    return hashlib.sha256(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    ).hexdigest()


def replay_seam(certificate, seam, parameters, matrix_by_permutation, psl):
    prime = 7
    full_group = set(matrix_by_permutation)
    base_matching = tuple(tuple(edge) for edge in certificate["base_matching"])
    exchange = tuple(seam["exchange_records"][0]["exchange_permutation"])
    other_matching = matching_image(exchange, base_matching)
    parent = {element for element in full_group if matching_image(element, base_matching) == base_matching}
    other = {element for element in full_group if matching_image(element, other_matching) == other_matching}
    common = parent & other
    seam_type = {6: "S3", 8: "D8"}[len(common)]
    assert seam_type == seam["seam_type"] and len(parent) == len(other) == 24
    assert compose(exchange, exchange) == tuple(range(8))
    assert all(compose(compose(exchange, element), exchange) in common for element in common)

    matchings = sorted({matching_image(element, base_matching) for element in full_group})
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    plus_sheet = {matching_image(element, base_matching) for element in psl}
    minus_sheet = set(matchings) - plus_sheet
    assert len(matchings) == 14 and len(plus_sheet) == len(minus_sheet) == 7

    points = projective_points(prime)
    point_index = {point: index for index, point in enumerate(points)}
    common_matrices = {sym2(matrix_by_permutation[element], prime) for element in common}
    exchange_matrix = sym2(matrix_by_permutation[exchange], prime)
    point_orbits = orbit_partition(
        common_matrices,
        points,
        lambda matrix, point: normalize(mat_vec(matrix, point, prime), prime),
    )
    point_orbit_index = {
        point_index[points[position]]: orbit_index
        for orbit_index, part in enumerate(point_orbits)
        for position in part
    }
    orbit_permutation = []
    for part in point_orbits:
        image = normalize(mat_vec(exchange_matrix, points[min(part)], prime), prime)
        orbit_permutation.append(point_orbit_index[point_index[image]])
    odd_pairs = [
        (index, image) for index, image in enumerate(orbit_permutation) if index < image
    ]
    assert len(odd_pairs) == 4

    def profile(matching):
        lines = secant_lines(parameters, matching, prime)
        counts = [
            sum(zero_on_product(lines, points[position], prime) for position in part)
            for part in point_orbits
        ]
        return tuple(counts[left] - counts[right] for left, right in odd_pairs)

    matching_orbits = orbit_partition(common, matchings, matching_image)
    profiles = [profile(matching) for matching in matchings]
    assert all(len({profiles[index] for index in part}) == 1 for part in matching_orbits)
    assert all(
        profiles[matching_index[matching_image(exchange, matching)]]
        == tuple(-value for value in profiles[index])
        for index, matching in enumerate(matchings)
    )
    plus_parts = sorted(
        (part for part in matching_orbits if matchings[min(part)] in plus_sheet),
        key=lambda part: (len(part), min(part)),
    )
    weights = [len(part) for part in plus_parts]
    positive_profiles = [profiles[min(part)] for part in plus_parts]
    assert weights == ({"S3": [1, 3, 3], "D8": [1, 2, 4]}[seam_type])
    assert len(set(profiles)) == 6 and rank([list(profile) for profile in profiles], prime) == 2
    assert [
        sum(weight * profile[column] for weight, profile in zip(weights, positive_profiles))
        for column in range(4)
    ] == [0, 0, 0, 0]
    nonzero_moments = []
    for degree in (1, 2, 3):
        moment = [0] * len(symmetric_power(positive_profiles[0], degree, prime))
        for weight, positive_profile in zip(weights, positive_profiles):
            positive = symmetric_power(tuple(value % prime for value in positive_profile), degree, prime)
            negative = symmetric_power(tuple(-value % prime for value in positive_profile), degree, prime)
            moment = [
                (old + weight * (left - right)) % prime
                for old, left, right in zip(moment, positive, negative)
            ]
        nonzero_moments.append(any(moment))
    assert nonzero_moments == [False, False, True]

    products = {
        matching: matching_product(parameters, matching, prime) for matching in matchings
    }
    odd_products = []
    odd_quotients = []
    degree_four_basis = homogeneous_basis(4)
    for matching in sorted(plus_sheet):
        mate = matching_image(exchange, matching)
        difference = subtract(products[matching], products[mate], prime)
        odd_products.append([difference.get(exponent, 0) for exponent in degree_four_basis])
        odd_quotients.append(quotient_by_conic(difference, prime))
    assert rank(odd_products, prime) == rank(odd_quotients, prime) == 4

    pair_sizes = [len(point_orbits[left]) for left, _right in odd_pairs]
    signature_hash = digest(canonical_signature(pair_sizes, weights, positive_profiles))
    assert signature_hash == seam["exchange_records"][0]["canonical_weighted_profile_signature_sha256"]
    return seam_type, signature_hash


def a3_control():
    parameters, matrix_by_permutation, psl = pgl(5)
    full_group = set(matrix_by_permutation)
    matchings = perfect_matchings(tuple(range(6)))
    assert len(matchings) == 15
    base_matching = max(
        matchings,
        key=lambda matching: sum(matching_image(element, matching) == matching for element in full_group),
    )
    stabilizer = {element for element in full_group if matching_image(element, base_matching) == base_matching}
    full_orbit = {matching_image(element, base_matching) for element in full_group}
    psl_orbit = {matching_image(element, base_matching) for element in psl}
    assert len(stabilizer) == 24 and full_orbit == psl_orbit and len(full_orbit) == 5
    return parameters


def main():
    certificate = json.loads(CERTIFICATE_PATH.read_text())
    assert certificate["schema"] == "c414-b3-depth-profile-v1"
    parameters, matrix_by_permutation, psl = pgl(7)
    assert len(matrix_by_permutation) == 336 and len(psl) == 168
    results = [
        replay_seam(certificate, seam, parameters, matrix_by_permutation, psl)
        for seam in certificate["seams"]
    ]
    assert Counter(seam_type for seam_type, _signature in results) == {"S3": 4, "D8": 3}
    assert {
        seam_type: {signature for current_type, signature in results if current_type == seam_type}
        for seam_type in ("S3", "D8")
    } == {
        seam_type: {
            certificate["geometric_profile_class_by_seam_type"][seam_type][
                "canonical_weighted_profile_signature_sha256"
            ]
        }
        for seam_type in ("S3", "D8")
    }
    a3_control()
    print("C414 independent Möbius/Sym^2 depth-profile replay OK")


if __name__ == "__main__":
    main()
