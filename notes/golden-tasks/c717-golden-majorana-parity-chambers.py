#!/usr/bin/env python3
"""Generate the exact C717 Golden Majorana chamber certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "notes" / "golden-tasks" / "c717-golden-majorana-parity-chambers.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)
STANDARD_WITNESSES = (
    (-6, -4, -3, -2, 4, 5),
    (-6, -5, -2, -1, 0, 4),
    (-6, -5, -4, -3, -2, -1),
    (-6, -5, -3, -2, -1, 3),
)

# Ascending coefficients, followed by the characteristic-polynomial exponent.
GRAM_FACTORS = (
    ((0, 1), 2),
    ((-60, 1), 1),
    ((-40, 1), 5),
    ((-16, 1), 10),
    ((-14, 1), 16),
    ((-12, 1), 5),
    ((-10, 1), 16),
    ((-8, 1), 15),
    ((-4, 1), 5),
    ((432, -60, 1), 5),
    ((48, -20, 1), 5),
    ((80, -20, 1), 9),
    ((-4160, 960, -64, 1), 9),
)

# X_M = multiplier * (z_a + z_b)/2 in the frozen C707 orientation.
MATCHING_TO_PAIR = {
    ((0, 1), (2, 3), (4, 5)): (-1, (0, 1)),
    ((0, 1), (2, 4), (3, 5)): (+1, (2, 3)),
    ((0, 1), (2, 5), (3, 4)): (-1, (4, 5)),
    ((0, 2), (1, 3), (4, 5)): (+1, (2, 4)),
    ((0, 2), (1, 4), (3, 5)): (-1, (0, 5)),
    ((0, 2), (1, 5), (3, 4)): (+1, (1, 3)),
    ((0, 3), (1, 2), (4, 5)): (-1, (3, 5)),
    ((0, 3), (1, 4), (2, 5)): (+1, (1, 2)),
    ((0, 3), (1, 5), (2, 4)): (-1, (0, 4)),
    ((0, 4), (1, 2), (3, 5)): (+1, (1, 4)),
    ((0, 4), (1, 3), (2, 5)): (-1, (0, 3)),
    ((0, 4), (1, 5), (2, 3)): (+1, (2, 5)),
    ((0, 5), (1, 2), (3, 4)): (-1, (0, 2)),
    ((0, 5), (1, 3), (2, 4)): (+1, (1, 5)),
    ((0, 5), (1, 4), (2, 3)): (-1, (3, 4)),
}


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def total_key(total) -> tuple[tuple[tuple[int, int], ...], ...]:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def triangle_cubic(matrix) -> tuple[int, ...]:
    return tuple(matrix[i][j] * matrix[j][k] * matrix[k][i] for i, j, k in TRIPLES)


def permuted_matrix(permutation: tuple[int, ...], scalar: int):
    matrix = [[0] * 6 for _ in range(6)]
    for i in range(6):
        for j in range(6):
            matrix[permutation[i]][permutation[j]] = scalar * BASE_C[i][j]
    return tuple(tuple(row) for row in matrix)


def outer_systems():
    systems = {}
    for permutation in itertools.permutations(range(6)):
        key = total_key(
            tuple(
                tuple(sorted((permutation[i], permutation[j]))) for i, j in matching
            )
            for matching in BASE_TOTAL
        )
        matrix = permuted_matrix(permutation, parity(permutation))
        cubic = triangle_cubic(matrix)
        if key in systems:
            assert systems[key][0] == cubic
        else:
            systems[key] = (cubic, matrix)
    assert len(systems) == 6
    oriented = []
    for key in sorted(systems):
        cubic, matrix = systems[key]
        point = next(
            point
            for point in itertools.product((0, 1), repeat=6)
            if evaluate_cubics((cubic,), point)[0]
        )
        ratio = pfaffian(commutator(matrix, point), tuple(range(6))) // evaluate_cubics((cubic,), point)[0]
        assert ratio in (-4, 4)
        if ratio == -4:
            signs = (-1, 1, 1, 1, 1, 1)
            matrix = tuple(
                tuple(signs[i] * signs[j] * matrix[i][j] for j in range(6))
                for i in range(6)
            )
        oriented.append((cubic, matrix))
    return oriented


def polynomial_add(left, right):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, 0) + coefficient
        if result[exponent] == 0:
            del result[exponent]
    return result


def polynomial_multiply(left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            result[exponent] = result.get(exponent, 0) + ca * cb
    return {key: value for key, value in result.items() if value}


def coefficient_polynomial_multiply(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return tuple(result)


def root_power_sums(monic_ascending, count):
    degree = len(monic_ascending) - 1
    descending = tuple(reversed(monic_ascending))
    assert descending[0] == 1
    result = [degree]
    for power in range(1, count):
        value = 0
        upper = power - 1 if power <= degree else degree
        for index in range(1, upper + 1):
            value += descending[index] * result[power - index]
        if power <= degree:
            value += power * descending[power]
        result.append(-value)
    return tuple(result)


def cubic_polynomial(cubic):
    result = {}
    for coefficient, support in zip(cubic, TRIPLES):
        exponent = tuple(int(i in support) for i in range(6))
        result[exponent] = coefficient
    return result


def evaluate_cubics(cubics, point):
    monomials = tuple(point[i] * point[j] * point[k] for i, j, k in TRIPLES)
    return tuple(sum(a * b for a, b in zip(cubic, monomials)) for cubic in cubics)


def pfaffian(matrix, indices):
    if not indices:
        return 1
    first = indices[0]
    result = 0
    for position in range(1, len(indices)):
        other = indices[position]
        result += (
            (-1) ** (position + 1)
            * matrix[first][other]
            * pfaffian(matrix, indices[1:position] + indices[position + 1 :])
        )
    return result


def matrix_rank(matrix):
    work = [[Fraction(value) for value in row] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next((row for row in range(rank, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = work[rank][column]
        work[rank] = [value / scale for value in work[rank]]
        for row in range(len(work)):
            if row != rank and work[row][column]:
                scale = work[row][column]
                work[row] = [a - scale * b for a, b in zip(work[row], work[rank])]
        rank += 1
    return rank


def commutator(matrix, point):
    return tuple(
        tuple((point[i] - point[j]) * matrix[i][j] for j in range(6))
        for i in range(6)
    )


def bracket_sign(order, edge):
    rank = {label: index for index, label in enumerate(order)}
    return 1 if rank[edge[0]] > rank[edge[1]] else -1


def pair_sum_signs(order):
    result = {}
    for matching, (multiplier, pair) in MATCHING_TO_PAIR.items():
        matching_sign = 1
        for edge in matching:
            matching_sign *= bracket_sign(order, edge)
        result[pair] = multiplier * matching_sign
    assert len(result) == 15
    return result


def candidate_signs(order):
    pair_sign = pair_sum_signs(order)
    result = []
    for signs in itertools.product((-1, 1), repeat=6):
        if signs in ((-1,) * 6, (1,) * 6):
            continue
        if all(signs[i] != signs[j] or pair_sign[i, j] == signs[i] for i, j in pair_sign):
            result.append(signs)
    return tuple(result)


def permute_witness(order, witness):
    point = [0] * 6
    for rank, label in enumerate(order):
        point[label] = witness[rank]
    return tuple(point)


def sign_vector(values):
    assert all(values)
    return tuple(1 if value > 0 else -1 for value in values)


def cycle_type(permutation):
    unseen = set(range(6))
    cycles = []
    while unseen:
        start = min(unseen)
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            length += 1
            current = permutation[current]
        cycles.append(length)
    return tuple(sorted(cycles, reverse=True))


def permutation_product(left, right):
    return tuple(left[right[index]] for index in range(6))


class DisjointSet:
    def __init__(self, elements):
        self.parent = {element: element for element in elements}

    def root(self, element):
        while self.parent[element] != element:
            self.parent[element] = self.parent[self.parent[element]]
            element = self.parent[element]
        return element

    def join(self, left, right):
        left = self.root(left)
        right = self.root(right)
        if left != right:
            self.parent[right] = left


def collision_synthemes(cubics):
    result = {}
    for i, j in itertools.combinations(range(6), 2):
        restricted = []
        for cubic in cubics:
            coefficients = defaultdict(int)
            for coefficient, support in zip(cubic, TRIPLES):
                collapsed = tuple(sorted(i if value == j else value for value in support))
                coefficients[collapsed] += coefficient
            restricted.append({key: value for key, value in coefficients.items() if value})
        pairs = []
        for a, b in itertools.combinations(range(6), 2):
            keys = set(restricted[a]) | set(restricted[b])
            if all(restricted[a].get(key, 0) == -restricted[b].get(key, 0) for key in keys):
                pairs.append((a, b))
        assert len(pairs) == 3
        result[(i, j)] = tuple(pairs)
    return result


def build():
    systems = outer_systems()
    cubics = tuple(system[0] for system in systems)
    matrices = tuple(system[1] for system in systems)

    cubic_polynomials = tuple(cubic_polynomial(cubic) for cubic in cubics)
    linear_sum = {}
    cubic_sum = {}
    for polynomial in cubic_polynomials:
        linear_sum = polynomial_add(linear_sum, polynomial)
        cube = polynomial_multiply(polynomial_multiply(polynomial, polynomial), polynomial)
        cubic_sum = polynomial_add(cubic_sum, cube)
    assert not linear_sum
    assert not cubic_sum

    for cubic, matrix in systems:
        assert all(
            sum(matrix[i][k] * matrix[k][j] for k in range(6)) == 5 * int(i == j)
            for i in range(6)
            for j in range(6)
        )
        # A direct coefficient check of Pf[D_x,C] = 4 Z_C.
        samples = []
        for point in itertools.product((0, 1), repeat=6):
            alternating = commutator(matrix, point)
            samples.append(
                pfaffian(alternating, tuple(range(6))) == 4 * evaluate_cubics((cubic,), point)[0]
            )
        assert all(samples)

    collision = collision_synthemes(cubics)
    order_candidates = {}
    order_witnesses = {}
    incidence = Counter()
    witnesses = {}
    for order in itertools.permutations(range(6)):
        candidates = set(candidate_signs(order))
        realized = {}
        for witness in STANDARD_WITNESSES:
            point = permute_witness(order, witness)
            signs = sign_vector(evaluate_cubics(cubics, point))
            realized[signs] = point
        assert set(realized) == candidates
        assert sorted(Counter(sum(value > 0 for value in signs) for signs in candidates).values()) == [1, 3]
        order_candidates[order] = tuple(sorted(candidates))
        for signs, point in realized.items():
            incidence[signs] += 1
            witnesses.setdefault(signs, point)
            order_witnesses[(signs, order)] = point

    incidence_by_weight = Counter()
    for signs, count in incidence.items():
        incidence_by_weight[(sum(value > 0 for value in signs), count)] += 1
    assert incidence_by_weight == Counter({(2, 24): 15, (3, 108): 20, (4, 24): 15})

    chamber_of = {}
    component_orders = {}
    chamber_sizes_by_weight = Counter()
    components_per_sign = {}
    for signs in sorted(incidence):
        orders = {order for order, candidates in order_candidates.items() if signs in candidates}
        dsu = DisjointSet(orders)
        for order in orders:
            for index in range(5):
                edge = tuple(sorted((order[index], order[index + 1])))
                syntheme = collision[edge]
                if all(signs[a] == -signs[b] for a, b in syntheme):
                    neighbor = order[:index] + (order[index + 1], order[index]) + order[index + 2 :]
                    if neighbor in orders:
                        dsu.join(order, neighbor)
        groups = defaultdict(list)
        for order in orders:
            groups[dsu.root(order)].append(order)
        sizes = sorted(len(group) for group in groups.values())
        components_per_sign[signs] = sizes
        chamber_sizes_by_weight[(sum(value > 0 for value in signs), tuple(sizes))] += 1
        ordered_groups = sorted((tuple(sorted(group)) for group in groups.values()), key=lambda group: group[0])
        for component, group in enumerate(ordered_groups):
            component_orders[(signs, component)] = group
            for order in group:
                chamber_of[(signs, order)] = (signs, component)

    assert chamber_sizes_by_weight == Counter(
        {(2, (1,) * 24): 15, (3, (12, 12, 12, 12, 12, 12, 36)): 20, (4, (1,) * 24): 15}
    )

    adjacency = set()
    for order, candidates in order_candidates.items():
        unbalanced = [signs for signs in candidates if sum(value > 0 for value in signs) != 3]
        balanced = [signs for signs in candidates if sum(value > 0 for value in signs) == 3]
        assert len(unbalanced) == 1 and len(balanced) == 3
        center = unbalanced[0]
        for leaf in balanced:
            assert sum(a != b for a, b in zip(center, leaf)) == 1
            adjacency.add((chamber_of[(center, order)], chamber_of[(leaf, order)]))
    degrees = Counter()
    for left, right in adjacency:
        degrees[left] += 1
        degrees[right] += 1
    degree_distribution = Counter(degrees.values())
    assert degree_distribution == Counter({3: 720, 12: 120, 36: 20})
    assert len(adjacency) == 2160
    neighbors = defaultdict(set)
    for left, right in adjacency:
        neighbors[left].add(right)
        neighbors[right].add(left)
    distance_distribution = Counter()
    diameter = 0
    for start in neighbors:
        distances = {start: 0}
        frontier = [start]
        while frontier:
            current = frontier.pop(0)
            for neighbor in neighbors[current]:
                if neighbor not in distances:
                    distances[neighbor] = distances[current] + 1
                    frontier.append(neighbor)
        assert len(distances) == 860
        diameter = max(diameter, max(distances.values()))
        for finish, distance in distances.items():
            if repr(start) < repr(finish):
                distance_distribution[distance] += 1

    permutations = tuple(itertools.permutations(range(6)))

    def act(vertex, permutation):
        order = component_orders[vertex][0]
        point = order_witnesses[(vertex[0], order)]
        transformed = [0] * 6
        for old_label in range(6):
            transformed[permutation[old_label]] = point[old_label]
        transformed_order = tuple(permutation[label] for label in order)
        transformed_signs = sign_vector(evaluate_cubics(cubics, transformed))
        return chamber_of[(transformed_signs, transformed_order)]

    def antipode(vertex):
        order = component_orders[vertex][0]
        return chamber_of[(tuple(-value for value in vertex[0]), tuple(reversed(order)))]

    assert all(antipode(antipode(vertex)) == vertex for vertex in neighbors)
    assert {
        tuple(sorted((antipode(left), antipode(right)), key=repr)) for left, right in adjacency
    } == {tuple(sorted(edge, key=repr)) for edge in adjacency}

    unbalanced_base = min(
        (vertex for vertex in neighbors if len(neighbors[vertex]) == 3), key=repr
    )
    assert len({act(unbalanced_base, permutation) for permutation in permutations}) == 720
    neighbor_seeds = sorted(neighbors[unbalanced_base], key=lambda vertex: (len(neighbors[vertex]), repr(vertex)))
    coset_orbits = []
    balanced_orbits = []
    stabilizers = []
    for seed in neighbor_seeds:
        stabilizer = tuple(
            permutation for permutation in permutations if act(seed, permutation) == seed
        )
        orbit = {act(seed, permutation) for permutation in permutations}
        balanced_orbits.append(orbit)
        assert len(stabilizer) == len(neighbors[seed])
        assert {act(unbalanced_base, permutation) for permutation in stabilizer} == neighbors[seed]
        unused = set(range(6))
        point_orbits = []
        while unused:
            start = min(unused)
            point_orbit = {permutation[start] for permutation in stabilizer}
            point_orbits.append(tuple(sorted(point_orbit)))
            unused -= point_orbit
        cycle_types = Counter(cycle_type(permutation) for permutation in stabilizer)
        coset_orbits.append(
            {
                "chamber_degree": len(neighbors[seed]),
                "orbit_size": len(orbit),
                "stabilizer_order": len(stabilizer),
                "point_orbits": point_orbits,
                "cycle_types": {
                    ".".join(map(str, key)): value for key, value in sorted(cycle_types.items())
                },
            }
        )
        stabilizers.append(stabilizer)
    assert [(item["orbit_size"], item["stabilizer_order"]) for item in coset_orbits] == [
        (60, 12),
        (60, 12),
        (20, 36),
    ]
    assert not ({act(neighbor_seeds[0], p) for p in permutations} & {act(neighbor_seeds[1], p) for p in permutations})
    assert antipode(neighbor_seeds[0]) in {act(neighbor_seeds[1], p) for p in permutations}
    generators = tuple({permutation for stabilizer in stabilizers for permutation in stabilizer})
    identity = tuple(range(6))
    generated = {identity}
    word_length = {identity: 0}
    frontier = [identity]
    for current in frontier:
        for generator in generators:
            product = permutation_product(current, generator)
            if product not in generated:
                generated.add(product)
                word_length[product] = word_length[current] + 1
                frontier.append(product)
    assert len(generated) == 720
    assert max(word_length.values()) == 5
    farthest = sorted(permutation for permutation, length in word_length.items() if length == 5)
    assert len(farthest) == 7

    balanced_vertices = sorted(
        (vertex for vertex in neighbors if len(neighbors[vertex]) > 3), key=repr
    )
    gram = []
    for left in balanced_vertices:
        gram.append(
            [
                len(neighbors[left]) if left == right else len(neighbors[left] & neighbors[right])
                for right in balanced_vertices
            ]
        )
    sparse_gram = [tuple((column, value) for column, value in enumerate(row) if value) for row in gram]

    def gram_multiply(vector):
        return [sum(value * vector[column] for column, value in row) for row in sparse_gram]

    orbit_indicators = [
        [int(vertex in orbit) for vertex in balanced_vertices] for orbit in balanced_orbits
    ]
    orbit_images = [gram_multiply(indicator) for indicator in orbit_indicators]
    assert orbit_images[0] == orbit_images[1] == orbit_images[2]

    minimal_polynomial = (1,)
    for factor, _ in GRAM_FACTORS:
        minimal_polynomial = coefficient_polynomial_multiply(minimal_polynomial, factor)
    assert len(minimal_polynomial) - 1 == 18
    for basis in range(140):
        vector = [int(index == basis) for index in range(140)]
        for coefficient in reversed(minimal_polynomial[:-1]):
            vector = gram_multiply(vector)
            vector[basis] += coefficient
        assert not any(vector)

    moment_count = len(GRAM_FACTORS)
    traces = [140] + [0] * (moment_count - 1)
    for basis in range(140):
        vector = [int(index == basis) for index in range(140)]
        for power in range(1, moment_count):
            vector = gram_multiply(vector)
            traces[power] += vector[basis]
    factor_moments = [root_power_sums(factor, moment_count) for factor, _ in GRAM_FACTORS]
    assert matrix_rank([list(row) for row in zip(*factor_moments)]) == moment_count
    expected_traces = tuple(
        sum(exponent * moments[power] for moments, (_, exponent) in zip(factor_moments, GRAM_FACTORS))
        for power in range(moment_count)
    )
    assert tuple(traces) == expected_traces
    assert sum((len(factor) - 1) * exponent for factor, exponent in GRAM_FACTORS) == 140

    balanced_index = {vertex: index for index, vertex in enumerate(balanced_vertices)}
    action_maps = [
        tuple(balanced_index[act(vertex, permutation)] for vertex in balanced_vertices)
        for permutation in permutations
    ]
    standard_moments = []
    power_columns = [
        [int(row == column) for row in range(140)] for column in range(140)
    ]
    for power in range(6):
        character_sum = 0
        for permutation, action_map in zip(permutations, action_maps):
            standard_character = sum(permutation[index] == index for index in range(6)) - 1
            character_sum += standard_character * sum(
                power_columns[column][action_map[column]] for column in range(140)
            )
        assert character_sum % 720 == 0
        standard_moments.append(character_sum // 720)
        if power < 5:
            power_columns = [gram_multiply(column) for column in power_columns]
    standard_block = (1,)
    for factor in ((-4, 1), (432, -60, 1), (48, -20, 1)):
        standard_block = coefficient_polynomial_multiply(standard_block, factor)
    assert tuple(standard_moments) == root_power_sums(standard_block, 6), (
        standard_moments,
        root_power_sums(standard_block, 6),
    )

    boolean = Counter()
    boolean_examples = {}
    for point in itertools.product((-1, 1), repeat=6):
        values = evaluate_cubics(cubics, point)
        ranks = tuple(matrix_rank(commutator(matrix, point)) for matrix in matrices)
        key = (sum(value == 1 for value in point), sum(value == 0 for value in values), ranks)
        boolean[key] += 1
        boolean_examples.setdefault(key, (point, values))

    wall_witnesses = {
        "one": ((-3, -2, -1, 0, 2, Fraction(-16, 15))),
        "two": ((-3, -3, -1, 0, 3, 0)),
        "four": ((-3, -3, -2, -2, 0, 0)),
        "six_generic": ((-3, -3, -3, -3, -2, 0)),
        "six_rank_two": ((-3, -3, -3, -3, -3, 0)),
    }
    wall_data = {}
    for name, point in wall_witnesses.items():
        values = evaluate_cubics(cubics, point)
        ranks = tuple(matrix_rank(commutator(matrix, point)) for matrix in matrices)
        wall_data[name] = {
            "point": [str(value) for value in point],
            "pfaffian_quarters": [str(value) for value in values],
            "ranks": ranks,
        }
    assert sum(value == 0 for value in evaluate_cubics(cubics, wall_witnesses["one"])) == 1
    assert sum(value == 0 for value in evaluate_cubics(cubics, wall_witnesses["two"])) == 2
    assert sum(value == 0 for value in evaluate_cubics(cubics, wall_witnesses["four"])) == 4
    assert all(value == 0 for value in evaluate_cubics(cubics, wall_witnesses["six_generic"]))
    assert wall_data["six_generic"]["ranks"] == (4,) * 6
    assert wall_data["six_rank_two"]["ranks"] == (2,) * 6

    serialize_sign = lambda signs: "".join("+" if value > 0 else "-" for value in signs)
    return {
        "schema": "c717-golden-majorana-parity-chambers-v1",
        "frozen_conventions": {
            "base_conference": BASE_C,
            "triple_order": TRIPLES,
            "outer_cubics": cubics,
            "outer_conference_matrices": matrices,
            "pfaffian_rule": "Pf[D_x,C_T]=4 Z_T(x)",
        },
        "segre_identities": {
            "sum_Z": 0,
            "sum_Z_cubed": 0,
            "nonzero_sign_vectors_by_positive_count": {"2": 15, "3": 20, "4": 15},
        },
        "collision_synthemes": {
            f"{i}{j}": [f"{a}{b}" for a, b in pairs] for (i, j), pairs in sorted(collision.items())
        },
        "strict_order_census": {
            "orders": 720,
            "sign_regions_per_order": 4,
            "shape": "one unbalanced center adjacent to three balanced leaves",
            "incidences_by_positive_count": {"2": 360, "3": 2160, "4": 360},
            "orders_per_sign_vector": {"2": 24, "3": 108, "4": 24},
            "standard_order_witnesses": [
                {
                    "point": point,
                    "Z": evaluate_cubics(cubics, point),
                    "sign": serialize_sign(sign_vector(evaluate_cubics(cubics, point))),
                }
                for point in STANDARD_WITNESSES
            ],
        },
        "connected_chamber_census": {
            "total": 860,
            "unbalanced": {
                "sign_vectors": 30,
                "chambers_per_sign_vector": 24,
                "total": 720,
            },
            "balanced": {
                "sign_vectors": 20,
                "component_order_cone_sizes_per_sign": [36, 12, 12, 12, 12, 12, 12],
                "chambers_per_sign_vector": 7,
                "total": 140,
            },
        },
        "generic_adjacency": {
            "edges": len(adjacency),
            "degree_distribution": {str(degree): count for degree, count in sorted(degree_distribution.items())},
            "connected": True,
            "diameter": diameter,
            "unordered_pair_distance_distribution": {
                str(distance): count for distance, count in sorted(distance_distribution.items())
            },
        },
        "coset_compression": {
            "group": "S6",
            "unbalanced_orbit": {"size": 720, "stabilizer_order": 1},
            "balanced_neighbor_orbits": coset_orbits,
            "model": "S6 disjoint-union S6/H36 disjoint-union S6/K12+ disjoint-union S6/K12-, with g adjacent to its three containing left cosets",
            "subgroups_generate_S6": True,
            "subgroup_factor_length_distribution": {
                str(length): count for length, count in sorted(Counter(word_length.values()).items())
            },
            "subgroup_factor_width": 5,
            "seven_width_five_permutations": farthest,
            "antipode_exchanges_the_two_K12_orbits": True,
        },
        "balanced_incidence_spectrum": {
            "gram_size": 140,
            "rank": 138,
            "kernel": "span of the two differences among the three orbitwise all-ones vectors",
            "characteristic_factors_ascending": [
                {"coefficients": factor, "exponent": exponent} for factor, exponent in GRAM_FACTORS
            ],
            "minimal_polynomial_degree": 18,
            "verification": "exact squarefree annihilator plus 13 full-rank trace moments",
            "young_permutation_module": "M^(3,3) + 2 M^(3,2,1)",
            "specht_multiplicities": {
                "(6)": 3,
                "(5,1)": 5,
                "(4,2)": 5,
                "(4,1,1)": 2,
                "(3,3)": 3,
                "(3,2,1)": 2,
            },
            "specht_block_characteristic_polynomials_ascending": {
                "(6)": [0, 0, -60, 1],
                "(5,1)": standard_block,
                "(4,2)": coefficient_polynomial_multiply(
                    (80, -20, 1), (-4160, 960, -64, 1)
                ),
                "(4,1,1)": coefficient_polynomial_multiply((-16, 1), (-8, 1)),
                "(3,3)": coefficient_polynomial_multiply(
                    coefficient_polynomial_multiply((-40, 1), (-12, 1)), (-8, 1)
                ),
                "(3,2,1)": coefficient_polynomial_multiply((-14, 1), (-10, 1)),
            },
            "standard_block_verification": "exact S^(5,1) central-character moments through degree five",
        },
        "boolean_census": [
            {
                "plus_entries": key[0],
                "zero_amplitudes": key[1],
                "ranks": key[2],
                "count": count,
                "example_point": boolean_examples[key][0],
                "example_Z": boolean_examples[key][1],
            }
            for key, count in sorted(boolean.items(), key=lambda item: str(item[0]))
        ],
        "intersection_witnesses": wall_data,
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        print(f"checked {OUTPUT.relative_to(ROOT)} sha256={hashlib.sha256(payload).hexdigest()}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.relative_to(ROOT)} sha256={hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
