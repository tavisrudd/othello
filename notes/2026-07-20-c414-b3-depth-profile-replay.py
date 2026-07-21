#!/usr/bin/env python3
"""Independent Möbius/Sym^2 replay of the C414 B3 depth theorem."""

from __future__ import annotations

import functools
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE_PATH = HERE / "2026-07-20-c414-b3-depth-profile.json"
C406_REPLAY_PATH = HERE / "2026-07-20-c406-matching-module-replay.py"
C406_REPLAY_SHA256 = "3d7a2288822531837b429c7151be69f1537ba060566fde35248a624df41c556d"
C378_REPLAY_PATH = HERE / "2026-07-19-c378-clebsch-common-duality-replay.py"
C378_REPLAY_SHA256 = "71d0a6799f4b567736881c431d758b90eff33fbd131b9cc91e9b04ef119e9c57"


def load_module(name, path, expected_sha256):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def subtract_vectors(left, right, prime):
    return [(a - b) % prime for a, b in zip(left, right)]


def augmentation_image_rank(vectors_by_index, orbit_parts, prime):
    differences = []
    for part in orbit_parts:
        reference = vectors_by_index[min(part)]
        differences.extend(
            subtract_vectors(vectors_by_index[index], reference, prime)
            for index in sorted(part)
        )
    return rank(differences, prime)


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
    odd_products_by_index = {}
    odd_quotients_by_index = {}
    positive_profile_vectors = []
    degree_four_basis = homogeneous_basis(4)
    for matching in sorted(plus_sheet):
        mate = matching_image(exchange, matching)
        difference = subtract(products[matching], products[mate], prime)
        product_vector = [difference.get(exponent, 0) for exponent in degree_four_basis]
        quotient_vector = quotient_by_conic(difference, prime)
        position = matching_index[matching]
        odd_products.append(product_vector)
        odd_quotients.append(quotient_vector)
        odd_products_by_index[position] = product_vector
        odd_quotients_by_index[position] = quotient_vector
        positive_profile_vectors.append(
            [value % prime for value in profiles[position]]
        )
    assert rank(odd_products, prime) == rank(odd_quotients, prime) == 4
    assert rank(
        [section + profile for section, profile in zip(odd_products, positive_profile_vectors)],
        prime,
    ) == 4
    assert rank(
        [section + profile for section, profile in zip(odd_quotients, positive_profile_vectors)],
        prime,
    ) == 4
    assert augmentation_image_rank(odd_products_by_index, plus_parts, prime) == 2
    assert augmentation_image_rank(odd_quotients_by_index, plus_parts, prime) == 2

    linearization = seam["exchange_records"][0]["section_depth_linearization"]
    assert linearization == {
        "depth_map_rank_mod_7": 2,
        "quotient_kernel_dimension": 2,
        "product_kernel_dimension": 2,
        "common_seam_augmentation_image_rank_on_quotients": 2,
        "common_seam_augmentation_image_rank_on_products": 2,
        "kernel_equals_common_seam_augmentation_image": True,
        "induced_coinvariant_dimension": 2,
        "coinvariant_to_depth_plane_isomorphism": True,
        "unique_linear_map_on_moving_section_span": True,
        "odd_section_linear_moment_vanishes": True,
    }

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


def replay_h3_linearization(certificate):
    c406 = load_module(
        "c414_c406_independent_replay", C406_REPLAY_PATH, C406_REPLAY_SHA256
    )
    assert hashlib.sha256(C378_REPLAY_PATH.read_bytes()).hexdigest() == C378_REPLAY_SHA256
    prime = 11
    scout = next(record for record in c406.SCOUT["types"] if record["type"] == "H3")
    endpoints, pgl_group, psl_group = c406.mobius_groups(prime)
    base_matching = tuple(tuple(pair) for pair in scout["coxeter_invariant_matching"])
    matchings = sorted(
        {c406.image_matching(element, base_matching) for element in pgl_group}
    )
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    plus_sheet = {
        c406.image_matching(element, base_matching) for element in psl_group
    }
    assert len(matchings) == 22 and len(plus_sheet) == 11
    products = {
        matching: c406.secant_product(matching, endpoints, prime)
        for matching in matchings
    }

    def normalize_projective(vector):
        pivot = next(value for value in vector if value % prime)
        scale = pow(pivot, -1, prime)
        return tuple(value * scale % prime for value in vector)

    projective_points_h3 = sorted(
        {
            normalize_projective(vector)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )
    conic = [
        point
        for point in projective_points_h3
        if sum(value * value for value in point) % prime == 0
    ]
    conic_base = conic[0]
    pencil = [
        line
        for line in projective_points_h3
        if sum(left * right for left, right in zip(line, conic_base)) % prime == 0
    ]
    first = pencil[0]

    def cross(left, right):
        return (
            (left[1] * right[2] - left[2] * right[1]) % prime,
            (left[2] * right[0] - left[0] * right[2]) % prime,
            (left[0] * right[1] - left[1] * right[0]) % prime,
        )

    second = next(line for line in pencil[1:] if cross(first, line) != (0, 0, 0))
    parameterized_conic = []
    for left, right in endpoints:
        line = normalize_projective(
            tuple(
                (left * first[index] + right * second[index]) % prime
                for index in range(3)
            )
        )
        incident = [
            point
            for point in conic
            if sum(a * b for a, b in zip(line, point)) % prime == 0
        ]
        parameterized_conic.append(
            conic_base
            if len(incident) == 1
            else next(point for point in incident if point != conic_base)
        )

    projectivity_rows = []
    for point_position, (point, (left, right)) in enumerate(
        zip(parameterized_conic[:5], endpoints[:5])
    ):
        standard_point = (
            left * left % prime,
            left * right % prime,
            right * right % prime,
        )
        for output_coordinate in range(3):
            row = [0] * 14
            for input_coordinate in range(3):
                row[3 * output_coordinate + input_coordinate] = standard_point[
                    input_coordinate
                ]
            row[9 + point_position] = -point[output_coordinate] % prime
            projectivity_rows.append(row)
    projectivity_solution = c406.nullspace(projectivity_rows, prime)
    assert len(projectivity_solution) == 1
    standard_to_h3 = [
        projectivity_solution[0][3 * row : 3 * row + 3] for row in range(3)
    ]
    h3_to_standard = c406.matrix_inverse(standard_to_h3, prime)

    plus_group = c406.C378_REPLAY.a5(8)
    minus_group = c406.C378_REPLAY.a5(4)
    common_group = plus_group & minus_group
    common_relations = c406.C378_REPLAY.orbits(
        c406.C378_REPLAY.linear(common_group)
    )
    c378_certificate = json.loads(c406.C378_REPLAY.CERT.read_text())
    representatives = [
        tuple(item["representative"])
        for item in c378_certificate["common_relation_metadata"]
    ]
    common_relations = [
        next(cell for cell in common_relations if representative in cell)
        for representative in representatives
    ]
    relation_permutation = []
    for relation in common_relations:
        image = {
            c406.C378_REPLAY.mv(c406.C378_REPLAY.J, vector)
            for vector in relation
        }
        relation_permutation.append(
            next(index for index, target in enumerate(common_relations) if image == target)
        )
    odd_pairs = [
        (index, image)
        for index, image in enumerate(relation_permutation)
        if index < image
    ]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
    projective_relations = [
        sorted(
            {
                c406.C378_REPLAY.normv(vector)
                for vector in relation
                if vector != (0, 0, 0)
            }
        )
        for relation in common_relations
    ]

    def product_vanishes(product, point):
        standard_point = c406.matrix_vector(h3_to_standard, point, prime)
        return (
            sum(
                coefficient
                * pow(standard_point[0], exponent[0], prime)
                * pow(standard_point[1], exponent[1], prime)
                * pow(standard_point[2], exponent[2], prime)
                for exponent, coefficient in product.items()
            )
            % prime
            == 0
        )

    profiles = []
    for matching in matchings:
        zero_counts = [
            sum(product_vanishes(products[matching], point) for point in relation)
            for relation in projective_relations
        ]
        profiles.append(
            tuple(zero_counts[left] - zero_counts[right] for left, right in odd_pairs)
        )

    conic_index = {point: index for index, point in enumerate(parameterized_conic)}
    exchange = tuple(
        conic_index[
            normalize_projective(c406.C378_REPLAY.mv(c406.C378_REPLAY.J, point))
        ]
        for point in parameterized_conic
    )
    assert all(
        profiles[matching_index[c406.image_matching(exchange, matching)]]
        == tuple(-value for value in profiles[index])
        for index, matching in enumerate(matchings)
    )
    common_point_actions = [
        tuple(
            conic_index[
                normalize_projective(c406.C378_REPLAY.mv(matrix, point))
            ]
            for point in parameterized_conic
        )
        for matrix in common_group
    ]
    matching_orbits = orbit_partition(
        common_point_actions, matchings, c406.image_matching
    )
    plus_parts = sorted(
        (part for part in matching_orbits if matchings[min(part)] in plus_sheet),
        key=lambda part: (len(part), min(part)),
    )
    assert [len(part) for part in plus_parts] == [1, 4, 6]

    odd_products = []
    odd_quotients = []
    odd_products_by_index = {}
    odd_quotients_by_index = {}
    positive_profile_vectors = []
    degree_six_basis = c406.monomials(6)
    for matching in sorted(plus_sheet):
        mate = c406.image_matching(exchange, matching)
        difference = {
            exponent: (
                products[matching].get(exponent, 0)
                - products[mate].get(exponent, 0)
            )
            % prime
            for exponent in set(products[matching]) | set(products[mate])
        }
        product_vector = [difference.get(exponent, 0) for exponent in degree_six_basis]
        quotient_vector = c406.conic_quotient(difference, 4, prime)
        position = matching_index[matching]
        odd_products.append(product_vector)
        odd_quotients.append(quotient_vector)
        odd_products_by_index[position] = product_vector
        odd_quotients_by_index[position] = quotient_vector
        positive_profile_vectors.append(
            [value % prime for value in profiles[position]]
        )

    assert rank(positive_profile_vectors, prime) == 2
    assert rank(odd_products, prime) == rank(odd_quotients, prime) == 6
    assert rank(
        [section + profile for section, profile in zip(odd_products, positive_profile_vectors)],
        prime,
    ) == 6
    assert rank(
        [section + profile for section, profile in zip(odd_quotients, positive_profile_vectors)],
        prime,
    ) == 6
    assert augmentation_image_rank(odd_products_by_index, plus_parts, prime) == 4
    assert augmentation_image_rank(odd_quotients_by_index, plus_parts, prime) == 4

    expected = certificate["h3_section_depth_linearization"]
    for key, value in {
        "field": 11,
        "common_seam": "A4",
        "sheet_orbit_weights": [1, 4, 6],
        "odd_product_section_rank": 6,
        "odd_quotient_section_rank": 6,
        "depth_map_rank": 2,
        "product_profile_joint_rank": 6,
        "quotient_profile_joint_rank": 6,
        "product_kernel_dimension": 4,
        "quotient_kernel_dimension": 4,
        "common_seam_augmentation_image_rank_on_products": 4,
        "common_seam_augmentation_image_rank_on_quotients": 4,
        "kernel_equals_common_seam_augmentation_image": True,
        "induced_coinvariant_dimension": 2,
        "coinvariant_to_depth_plane_isomorphism": True,
        "unique_linear_map_on_moving_section_span": True,
        "odd_section_linear_moment_vanishes": True,
    }.items():
        assert expected[key] == value


def main():
    certificate = json.loads(CERTIFICATE_PATH.read_text())
    assert certificate["schema"] == "c414-b3-depth-profile-v2"
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
    replay_h3_linearization(certificate)
    print("C414 independent B3/H3 section-depth replay OK")


if __name__ == "__main__":
    main()
