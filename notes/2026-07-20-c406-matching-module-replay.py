#!/usr/bin/env python3
"""Independent replay of the C406 harmonic and cubic-memory claims."""

from __future__ import annotations

import itertools
import json
import functools
import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
SCOUT = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
PRIMARY = json.loads((HERE / "2026-07-20-c406-matching-module.json").read_text())


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C378_REPLAY = load_module(
    "c406_c378_independent_replay", HERE / "2026-07-19-c378-clebsch-common-duality-replay.py"
)


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


def nullspace(rows, q):
    reduced, pivots = row_reduce(rows, q)
    width = len(rows[0]) if rows else 0
    free = [column for column in range(width) if column not in pivots]
    result = []
    for free_column in free:
        vector = [0] * width
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % q
        result.append(vector)
    return result


def matrix_inverse(matrix, q):
    size = len(matrix)
    augmented = [
        list(row) + [1 if row_index == column_index else 0 for column_index in range(size)]
        for row_index, row in enumerate(matrix)
    ]
    reduced, pivots = row_reduce(augmented, q)
    assert pivots[:size] == list(range(size))
    return [row[size:] for row in reduced]


def matrix_product(left, right, q):
    return [
        [sum(a * b for a, b in zip(row, column)) % q for column in zip(*right)]
        for row in left
    ]


def matrix_vector(matrix, vector, q):
    return [sum(a * b for a, b in zip(row, vector)) % q for row in matrix]


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    generators = list(generators) + [invert(generator) for generator in generators]
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(generator, element)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def group_generators(group):
    identity = tuple(range(len(next(iter(group)))))
    generators = []
    generated = {identity}
    for element in sorted(group):
        if element not in generated:
            generators.append(element)
            generated = generated_group(generators)
        if generated == group:
            break
    assert generated == group
    return generators


def symmetric_cube_action(matrix, q):
    dimension = len(matrix)
    basis = list(itertools.combinations_with_replacement(range(dimension), 3))
    basis_index = {indices: index for index, indices in enumerate(basis)}
    action = [[0] * len(basis) for _ in basis]
    for row, (i, j, k) in enumerate(basis):
        for left in range(dimension):
            for middle in range(dimension):
                for right in range(dimension):
                    column = basis_index[tuple(sorted((left, middle, right)))]
                    action[row][column] = (
                        action[row][column]
                        + matrix[i][left] * matrix[j][middle] * matrix[k][right]
                    ) % q
    return action


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
    products = []
    for matching in orbit:
        product = secant_product(matching, endpoints, q)
        products.append(product)
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
        sheet = {image_matching(element, min(orbit)) for element in psl}
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

        orbit_index = {matching: index for index, matching in enumerate(orbit)}
        _point_reduced, point_basis_indices = row_reduce(transpose(coordinates), q)
        assert len(point_basis_indices) == image_rank
        point_basis = transpose([coordinates[index] for index in point_basis_indices])
        point_basis_inverse = matrix_inverse(point_basis, q)
        base_index = orbit_index[base]

        def induced_action(element):
            action = [orbit_index[image_matching(element, matching)] for matching in orbit]
            moved_base = action[base_index]
            target_basis = transpose(
                [
                    [
                        (coordinates[action[index]][coordinate] - coordinates[moved_base][coordinate])
                        % q
                        for coordinate in range(image_rank)
                    ]
                    for index in point_basis_indices
                ]
            )
            matrix = matrix_product(target_basis, point_basis_inverse, q)
            assert all(
                matrix_vector(matrix, coordinates[index], q)
                == [
                    (coordinates[action[index]][coordinate] - coordinates[moved_base][coordinate])
                    % q
                    for coordinate in range(image_rank)
                ]
                for index in range(len(orbit))
            )
            return matrix

        psl_generators = group_generators(psl)
        relative_actions = [
            symmetric_cube_action(induced_action(element), q)
            for element in psl_generators + [min(pgl - psl)]
        ]
        cube_dimension = len(relative_actions[0])
        relative_equations = []
        for action_index, action in enumerate(relative_actions):
            eigenvalue = 1 if action_index < len(psl_generators) else -1 % q
            relative_equations.extend(
                [
                    [
                        (action[row][column] - (eigenvalue if row == column else 0)) % q
                        for column in range(cube_dimension)
                    ]
                    for row in range(cube_dimension)
                ]
            )
        relative_basis = nullspace(relative_equations, q)
        cubic = [
            sum(sign * power[index] for sign, power in zip(signs, [power_coordinates(vector, 3, q) for vector in coordinates]))
            % q
            for index in range(cube_dimension)
        ]
        assert all(
            sum(row[column] * cubic[column] for column in range(cube_dimension)) % q == 0
            for row in relative_equations
        )
        relative_record = primary_record["outer_sheet_sign"]["cubic_relative_invariant"]
        assert len(relative_basis) == relative_record["psl_fixed_outer_odd_dimension"] == 3
        assert cube_dimension == relative_record["ambient_symmetric_cube_dimension"]

        parent_generators = group_generators(stabilizer)
        covector_equations = []
        for action in map(induced_action, parent_generators):
            covector_equations.extend(
                [
                    [
                        (action[column][row] - (1 if row == column else 0)) % q
                        for column in range(image_rank)
                    ]
                    for row in range(image_rank)
                ]
            )
        covectors = nullspace(covector_equations, q)
        assert len(covectors) == 1
        covector = covectors[0]
        cube_basis = list(itertools.combinations_with_replacement(range(image_rank), 3))

        def contraction(tensor):
            values = dict(zip(cube_basis, tensor))
            return [
                [
                    sum(
                        values[tuple(sorted((row, column, index)))] * covector[index]
                        for index in range(image_rank)
                    )
                    % q
                    for column in range(image_rank)
                ]
                for row in range(image_rank)
            ]

        cube_values = dict(zip(cube_basis, cubic))
        second_moment = [
            [
                sum(vector[row] * vector[column] for vector in coordinates) % q
                for column in range(image_rank)
            ]
            for row in range(image_rank)
        ]
        contracted = contraction(cubic)
        scalar = next(
            contracted[row][column] * pow(second_moment[row][column], -1, q) % q
            for row in range(image_rank)
            for column in range(image_rank)
            if second_moment[row][column]
        )
        assert contracted == [[scalar * value % q for value in row] for row in second_moment]
        relative_contractions = [contraction(tensor) for tensor in relative_basis]
        proportional_equations = [
            [
                *[relative_contractions[index][row][column] for index in range(len(relative_basis))],
                -second_moment[row][column] % q,
            ]
            for row in range(image_rank)
            for column in range(row, image_rank)
        ]
        singular = []
        zero_vectors = 0
        for point_index, vector in enumerate(coordinates):
            if not any(vector):
                zero_vectors += 1
                continue
            gradient = [
                sum(
                    cube_values[tuple(sorted((row, left, right)))] * vector[left] * vector[right]
                    for left in range(image_rank)
                    for right in range(image_rank)
                )
                % q
                for row in range(image_rank)
            ]
            if not any(gradient):
                singular.append(point_index)
        polarization = primary_record["outer_sheet_sign"]["polarization"]
        assert matrix_rank(second_moment, q) == polarization["second_moment_rank"]
        assert matrix_rank(contracted, q) == polarization["invariant_covector_contraction_rank"]
        assert scalar == polarization["contraction_scalar"]
        assert len(nullspace(proportional_equations, q)) == polarization["proportional_contraction_solution_dimension"]
        assert singular == polarization["nonzero_quotient_points_singular_in_frozen_gauge"]
        assert zero_vectors == polarization["zero_quotient_vector_count"]

        if name == "H3":
            def normalize_projective(vector):
                pivot = next(value for value in vector if value % q)
                scale = pow(pivot, -1, q)
                return tuple(value * scale % q for value in vector)

            projective_points = sorted(
                {
                    normalize_projective(vector)
                    for vector in itertools.product(range(q), repeat=3)
                    if vector != (0, 0, 0)
                }
            )
            conic = [point for point in projective_points if sum(value * value for value in point) % q == 0]
            conic_base = conic[0]
            pencil = [
                line
                for line in projective_points
                if sum(left * right for left, right in zip(line, conic_base)) % q == 0
            ]
            first = pencil[0]

            def cross(left, right):
                return (
                    (left[1] * right[2] - left[2] * right[1]) % q,
                    (left[2] * right[0] - left[0] * right[2]) % q,
                    (left[0] * right[1] - left[1] * right[0]) % q,
                )

            second = next(line for line in pencil[1:] if cross(first, line) != (0, 0, 0))
            parameterized_conic = []
            for left, right in endpoints:
                line = normalize_projective(
                    tuple((left * first[index] + right * second[index]) % q for index in range(3))
                )
                incident = [
                    point
                    for point in conic
                    if sum(a * b for a, b in zip(line, point)) % q == 0
                ]
                parameterized_conic.append(
                    conic_base if len(incident) == 1 else next(point for point in incident if point != conic_base)
                )

            projectivity_rows = []
            for point_index, (point, (left, right)) in enumerate(zip(parameterized_conic[:5], endpoints[:5])):
                standard_point = (left * left % q, left * right % q, right * right % q)
                for output_coordinate in range(3):
                    row = [0] * 14
                    for input_coordinate in range(3):
                        row[3 * output_coordinate + input_coordinate] = standard_point[input_coordinate]
                    row[9 + point_index] = -point[output_coordinate] % q
                    projectivity_rows.append(row)
            projectivity_solution = nullspace(projectivity_rows, q)
            assert len(projectivity_solution) == 1
            standard_to_h3 = [
                projectivity_solution[0][3 * row : 3 * row + 3] for row in range(3)
            ]
            h3_to_standard = matrix_inverse(standard_to_h3, q)

            plus = C378_REPLAY.a5(8)
            minus = C378_REPLAY.a5(4)
            intersection = plus & minus
            common = C378_REPLAY.orbits(C378_REPLAY.linear(intersection))
            c378_certificate = json.loads(C378_REPLAY.CERT.read_text())
            representatives = [
                tuple(item["representative"])
                for item in c378_certificate["common_relation_metadata"]
            ]
            common = [next(cell for cell in common if representative in cell) for representative in representatives]
            relation_permutation = []
            for relation in common:
                image = {C378_REPLAY.mv(C378_REPLAY.J, vector) for vector in relation}
                relation_permutation.append(next(index for index, target in enumerate(common) if image == target))
            odd_pairs = [
                (index, image)
                for index, image in enumerate(relation_permutation)
                if index < image
            ]
            assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
            projective_relations = [
                sorted(
                    {
                        C378_REPLAY.normv(vector)
                        for vector in relation
                        if vector != (0, 0, 0)
                    }
                )
                for relation in common
            ]

            def product_vanishes(product, point):
                standard_point = matrix_vector(h3_to_standard, point, q)
                return (
                    sum(
                        coefficient
                        * pow(standard_point[0], exponent[0], q)
                        * pow(standard_point[1], exponent[1], q)
                        * pow(standard_point[2], exponent[2], q)
                        for exponent, coefficient in product.items()
                    )
                    % q
                    == 0
                )

            depth_profiles = []
            for product in products:
                zero_counts = [
                    sum(product_vanishes(product, point) for point in relation)
                    for relation in projective_relations
                ]
                depth_profiles.append(
                    tuple(zero_counts[left] - zero_counts[right] for left, right in odd_pairs)
                )

            conic_index = {point: index for index, point in enumerate(parameterized_conic)}
            j_point_permutation = tuple(
                conic_index[
                    normalize_projective(C378_REPLAY.mv(C378_REPLAY.J, point))
                ]
                for point in parameterized_conic
            )
            j_matching_permutation = [
                orbit_index[image_matching(j_point_permutation, matching)] for matching in orbit
            ]
            assert all(
                depth_profiles[j_matching_permutation[index]]
                == tuple(-value for value in depth_profiles[index])
                for index in range(len(orbit))
            )
            profile_fibres = {}
            for index, profile in enumerate(depth_profiles):
                profile_fibres.setdefault(profile, set()).add(index)
            sheet_indices = {
                index: int(orbit[index] not in sheet) for index in range(len(orbit))
            }
            assert all(len({sheet_indices[index] for index in fibre}) == 1 for fibre in profile_fibres.values())
            intersection_point_actions = [
                tuple(
                    conic_index[normalize_projective(C378_REPLAY.mv(matrix, point))]
                    for point in parameterized_conic
                )
                for matrix in intersection
            ]
            matching_orbits = []
            unseen = set(range(len(orbit)))
            while unseen:
                representative = min(unseen)
                matching_orbit = {
                    orbit_index[image_matching(action, orbit[representative])]
                    for action in intersection_point_actions
                }
                unseen -= matching_orbit
                matching_orbits.append(matching_orbit)
            assert {frozenset(fibre) for fibre in profile_fibres.values()} == {
                frozenset(matching_orbit) for matching_orbit in matching_orbits
            }
            bridge = primary_record["outer_sheet_sign"]["c378_depth_fourier_bridge"]
            assert standard_to_h3 == bridge["standard_to_h3_projectivity"]
            assert sorted(len(fibre) for fibre in profile_fibres.values()) == bridge["profile_fibre_sizes"]
            assert [
                {
                    "profile": list(profile),
                    "fibre_size": len(fibre),
                    "sheet_index": sheet_indices[min(fibre)],
                }
                for profile, fibre in sorted(profile_fibres.items())
            ] == bridge["profile_records"]
            positive_profiles = sorted(
                {
                    depth_profiles[index]
                    for index in range(len(orbit))
                    if sheet_indices[index] == 0
                }
            )
            assert matrix_rank([list(profile) for profile in positive_profiles], q) == 2
            compressed_moments = []
            for degree in (1, 2, 3):
                powers = [
                    power_coordinates([value % q for value in profile], degree, q)
                    for profile in depth_profiles
                ]
                moment = [
                    sum(sign * power[index] for sign, power in zip(signs, powers)) % q
                    for index in range(len(powers[0]))
                ]
                compressed_moments.append(any(moment))
            assert compressed_moments == [False, False, True]
            assert [record["nonzero"] for record in bridge["compressed_signed_moments"]] == compressed_moments
            singleton_indices = {
                next(iter(fibre)) for fibre in profile_fibres.values() if len(fibre) == 1
            }
            assert len(singleton_indices) == bridge["singleton_profile_fibres"] == 2
            assert orbit_index[base] in singleton_indices
            assert {j_matching_permutation[index] for index in singleton_indices} == singleton_indices


def main():
    primary_by_type = {record["type"]: record for record in PRIMARY["types"]}
    for scout_record in SCOUT["types"]:
        replay_type(scout_record, primary_by_type[scout_record["type"]])
    print("C406 Gate 2/3 independent replay OK")


if __name__ == "__main__":
    main()
