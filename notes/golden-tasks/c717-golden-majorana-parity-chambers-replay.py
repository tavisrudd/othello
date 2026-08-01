#!/usr/bin/env python3
"""Independent replay of the C717 real-chamber and rank census."""

from __future__ import annotations

import itertools
import json
from collections import Counter, defaultdict
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
CERTIFICATE = ROOT / "notes" / "golden-tasks" / "c717-golden-majorana-parity-chambers.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
WITNESSES = (
    (-6, -4, -3, -2, 4, 5),
    (-6, -5, -2, -1, 0, 4),
    (-6, -5, -4, -3, -2, -1),
    (-6, -5, -3, -2, -1, 3),
)
EXPECTED_GRAM_FACTORS = (
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


def values(cubics, point):
    products = [point[i] * point[j] * point[k] for i, j, k in TRIPLES]
    return tuple(sum(a * b for a, b in zip(row, products)) for row in cubics)


def signs(entries):
    if not all(entries):
        return None
    return tuple(1 if entry > 0 else -1 for entry in entries)


def assigned(order, witness):
    point = [0] * 6
    for index, label in enumerate(order):
        point[label] = witness[index]
    return tuple(point)


def rank(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    result = 0
    for column in range(6):
        pivot = next((row for row in range(result, 6) if work[row][column]), None)
        if pivot is None:
            continue
        work[result], work[pivot] = work[pivot], work[result]
        pivot_value = work[result][column]
        for j in range(column, 6):
            work[result][j] /= pivot_value
        for row in range(result + 1, 6):
            scale = work[row][column]
            if scale:
                for j in range(column, 6):
                    work[row][j] -= scale * work[result][j]
        result += 1
    return result


def rectangular_rank(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    row_count = len(work)
    column_count = len(work[0])
    pivot_row = 0
    for column in range(column_count):
        pivot = next((row for row in range(pivot_row, row_count) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        for j in range(column, column_count):
            work[pivot_row][j] /= pivot_value
        for row in range(row_count):
            if row != pivot_row and work[row][column]:
                scale = work[row][column]
                for j in range(column, column_count):
                    work[row][j] -= scale * work[pivot_row][j]
        pivot_row += 1
        if pivot_row == row_count:
            break
    return pivot_row


def multiply_polynomials(left, right):
    product = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            product[i + j] += a * b
    return tuple(product)


def power_sums(factor, count):
    degree = len(factor) - 1
    coefficients = tuple(reversed(factor))
    sums = [degree]
    for power in range(1, count):
        last = power - 1 if power <= degree else degree
        recurrence = sum(coefficients[index] * sums[power - index] for index in range(1, last + 1))
        if power <= degree:
            recurrence += power * coefficients[power]
        sums.append(-recurrence)
    return tuple(sums)


def commutator(conference, point):
    return [
        [(point[i] - point[j]) * conference[i][j] for j in range(6)]
        for i in range(6)
    ]


class UnionFind:
    def __init__(self, elements):
        self.parent = {element: element for element in elements}

    def find(self, element):
        trail = []
        while self.parent[element] != element:
            trail.append(element)
            element = self.parent[element]
        for old in trail:
            self.parent[old] = element
        return element

    def union(self, left, right):
        left, right = self.find(left), self.find(right)
        if left != right:
            self.parent[right] = left


def main():
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c717-golden-majorana-parity-chambers-v1"
    frozen = data["frozen_conventions"]
    cubics = tuple(tuple(row) for row in frozen["outer_cubics"])
    conferences = tuple(tuple(tuple(row) for row in matrix) for matrix in frozen["outer_conference_matrices"])
    collision = {
        tuple(map(int, edge)): tuple(tuple(map(int, pair)) for pair in pairs)
        for edge, pairs in data["collision_synthemes"].items()
    }

    # Directly evaluate transformed rational witnesses in all 720 strict orders.
    feasible = defaultdict(set)
    stars = {}
    occurrence_point = {}
    for order in itertools.permutations(range(6)):
        patterns = {signs(values(cubics, assigned(order, witness))) for witness in WITNESSES}
        assert None not in patterns and len(patterns) == 4
        weights = Counter(sum(entry > 0 for entry in pattern) for pattern in patterns)
        assert weights == Counter({3: 3, 2: 1}) or weights == Counter({3: 3, 4: 1})
        center = next(pattern for pattern in patterns if sum(entry > 0 for entry in pattern) != 3)
        leaves = tuple(pattern for pattern in patterns if pattern != center)
        assert all(sum(a != b for a, b in zip(center, leaf)) == 1 for leaf in leaves)
        stars[order] = (center, leaves)
        for pattern in patterns:
            feasible[pattern].add(order)
            occurrence_point[pattern, order] = next(
                assigned(order, witness)
                for witness in WITNESSES
                if signs(values(cubics, assigned(order, witness))) == pattern
            )

    incidence = Counter((sum(entry > 0 for entry in pattern), len(orders)) for pattern, orders in feasible.items())
    assert incidence == Counter({(2, 24): 15, (3, 108): 20, (4, 24): 15})

    chamber = {}
    chamber_orders = {}
    sizes_by_weight = Counter()
    for pattern, orders in feasible.items():
        union = UnionFind(orders)
        for order in orders:
            for index in range(5):
                edge = tuple(sorted((order[index], order[index + 1])))
                if all(pattern[a] == -pattern[b] for a, b in collision[edge]):
                    neighbor = order[:index] + (order[index + 1], order[index]) + order[index + 2 :]
                    if neighbor in orders:
                        union.union(order, neighbor)
        groups = defaultdict(list)
        for order in orders:
            groups[union.find(order)].append(order)
        ordered_groups = sorted((tuple(sorted(group)) for group in groups.values()), key=lambda group: group[0])
        sizes = tuple(sorted(len(group) for group in ordered_groups))
        sizes_by_weight[(sum(entry > 0 for entry in pattern), sizes)] += 1
        for number, group in enumerate(ordered_groups):
            chamber_orders[(pattern, number)] = group
            for order in group:
                chamber[pattern, order] = (pattern, number)
    assert sizes_by_weight == Counter(
        {(2, (1,) * 24): 15, (3, (12,) * 6 + (36,)): 20, (4, (1,) * 24): 15}
    )
    assert sum(count * len(sizes) for (_, sizes), count in sizes_by_weight.items()) == 860

    edges = set()
    for order, (center, leaves) in stars.items():
        for leaf in leaves:
            edges.add((chamber[center, order], chamber[leaf, order]))
    degrees = Counter()
    for left, right in edges:
        degrees[left] += 1
        degrees[right] += 1
    assert len(edges) == 2160
    assert Counter(degrees.values()) == Counter({3: 720, 12: 120, 36: 20})
    neighbors = defaultdict(set)
    for left, right in edges:
        neighbors[left].add(right)
        neighbors[right].add(left)
    diameter = 0
    for start in neighbors:
        distances = {start: 0}
        frontier = [start]
        for current in frontier:
            for neighbor in neighbors[current]:
                if neighbor not in distances:
                    distances[neighbor] = distances[current] + 1
                    frontier.append(neighbor)
        assert len(distances) == 860
        diameter = max(diameter, max(distances.values()))
    assert diameter == 10

    permutations = tuple(itertools.permutations(range(6)))

    def act(vertex, permutation):
        order = chamber_orders[vertex][0]
        point = occurrence_point[vertex[0], order]
        transformed = [0] * 6
        for old in range(6):
            transformed[permutation[old]] = point[old]
        new_order = tuple(permutation[label] for label in order)
        new_pattern = signs(values(cubics, transformed))
        return chamber[new_pattern, new_order]

    def antipode(vertex):
        order = chamber_orders[vertex][0]
        return chamber[tuple(-entry for entry in vertex[0]), tuple(reversed(order))]

    assert all(antipode(antipode(vertex)) == vertex for vertex in neighbors)
    assert {
        tuple(sorted((antipode(left), antipode(right)), key=repr)) for left, right in edges
    } == {tuple(sorted(edge, key=repr)) for edge in edges}

    base = min((vertex for vertex in neighbors if len(neighbors[vertex]) == 3), key=repr)
    assert len({act(base, permutation) for permutation in permutations}) == 720
    seed_data = []
    stabilizers = []
    seed_point_orbits = []
    neighbor_seeds = sorted(neighbors[base], key=lambda vertex: (len(neighbors[vertex]), repr(vertex)))
    for seed in neighbor_seeds:
        stabilizer = tuple(permutation for permutation in permutations if act(seed, permutation) == seed)
        orbit = {act(seed, permutation) for permutation in permutations}
        assert {act(base, permutation) for permutation in stabilizer} == neighbors[seed]
        unused = set(range(6))
        point_orbit_sizes = []
        point_orbits = []
        while unused:
            start = min(unused)
            point_orbit = {permutation[start] for permutation in stabilizer}
            point_orbit_sizes.append(len(point_orbit))
            point_orbits.append(tuple(sorted(point_orbit)))
            unused -= point_orbit
        seed_data.append((len(orbit), len(stabilizer), tuple(sorted(point_orbit_sizes))))
        stabilizers.append(stabilizer)
        seed_point_orbits.append(tuple(point_orbits))
    assert seed_data == [(60, 12, (1, 2, 3)), (60, 12, (1, 2, 3)), (20, 36, (3, 3))]
    balanced_orbits = [
        {act(seed, permutation) for permutation in permutations}
        for seed in neighbor_seeds
    ]
    assert not (balanced_orbits[0] & balanced_orbits[1])
    assert antipode(neighbor_seeds[0]) in balanced_orbits[1]

    def compose(left, right):
        return tuple(left[right[index]] for index in range(6))

    subgroup_generators = tuple({permutation for group in stabilizers for permutation in group})
    identity = tuple(range(6))
    generated = {identity}
    word_length = {identity: 0}
    frontier = [identity]
    for current in frontier:
        for generator in subgroup_generators:
            product = compose(current, generator)
            if product not in generated:
                generated.add(product)
                word_length[product] = word_length[current] + 1
                frontier.append(product)
    assert len(generated) == 720
    assert Counter(word_length.values()) == Counter({0: 1, 1: 50, 2: 180, 3: 334, 4: 148, 5: 7})

    # Independently certify the exact 140-by-140 balanced-incidence Gram spectrum.
    balanced = tuple(sorted((vertex for vertex in neighbors if len(neighbors[vertex]) > 3), key=repr))
    assert len(balanced) == 140
    gram = tuple(
        tuple(len(neighbors[left] & neighbors[right]) for right in balanced)
        for left in balanced
    )

    def gram_times(vector):
        return tuple(sum(entry * value for entry, value in zip(row, vector)) for row in gram)

    orbit_indicators = [
        tuple(int(vertex in orbit) for vertex in balanced) for orbit in balanced_orbits
    ]
    orbit_images = [gram_times(indicator) for indicator in orbit_indicators]
    assert orbit_images[0] == orbit_images[1] == orbit_images[2]

    annihilator = (1,)
    for factor, _ in EXPECTED_GRAM_FACTORS:
        annihilator = multiply_polynomials(annihilator, factor)
    assert len(annihilator) - 1 == 18
    for basis in range(140):
        vector = tuple(int(index == basis) for index in range(140))
        for coefficient in reversed(annihilator[:-1]):
            vector = list(gram_times(vector))
            vector[basis] += coefficient
            vector = tuple(vector)
        assert not any(vector)

    moment_count = len(EXPECTED_GRAM_FACTORS)
    traces = [140]
    columns = [[int(index == basis) for index in range(140)] for basis in range(140)]
    for _ in range(1, moment_count):
        columns = [gram_times(column) for column in columns]
        traces.append(sum(columns[index][index] for index in range(140)))
    factor_moments = [power_sums(factor, moment_count) for factor, _ in EXPECTED_GRAM_FACTORS]
    assert rectangular_rank(tuple(zip(*factor_moments))) == moment_count
    assert tuple(traces) == tuple(
        sum(exponent * moments[power] for moments, (_, exponent) in zip(factor_moments, EXPECTED_GRAM_FACTORS))
        for power in range(moment_count)
    )
    assert sum((len(factor) - 1) * exponent for factor, exponent in EXPECTED_GRAM_FACTORS) == 140

    balanced_index = {vertex: index for index, vertex in enumerate(balanced)}
    action_maps = [
        tuple(balanced_index[act(vertex, permutation)] for vertex in balanced)
        for permutation in permutations
    ]
    standard_moments = []
    power_columns = [tuple(int(row == column) for row in range(140)) for column in range(140)]
    for power in range(6):
        weighted_trace = 0
        for permutation, action_map in zip(permutations, action_maps):
            character = sum(permutation[index] == index for index in range(6)) - 1
            weighted_trace += character * sum(
                power_columns[column][action_map[column]] for column in range(140)
            )
        assert weighted_trace % 720 == 0
        standard_moments.append(weighted_trace // 720)
        if power < 5:
            power_columns = [gram_times(column) for column in power_columns]
    standard_block = (1,)
    for factor in ((-4, 1), (432, -60, 1), (48, -20, 1)):
        standard_block = multiply_polynomials(standard_block, factor)
    assert tuple(standard_moments) == power_sums(standard_block, 6)

    partition_maps = []
    for seed, base_blocks in zip(neighbor_seeds, seed_point_orbits):
        partition_map = {}
        for permutation in permutations:
            vertex = act(seed, permutation)
            blocks = tuple(
                tuple(sorted(permutation[label] for label in block)) for block in base_blocks
            )
            assert vertex not in partition_map or partition_map[vertex] == blocks
            partition_map[vertex] = blocks
        partition_maps.append(partition_map)
    standard_features = []
    for orbit, blocks, partition_map in zip(balanced_orbits, seed_point_orbits, partition_maps):
        chosen = (
            tuple(index for index, block in enumerate(blocks) if len(block) in (1, 2))
            if len(orbit) == 60
            else (0,)
        )
        for block_index in chosen:
            block_size = len(blocks[block_index])
            standard_features.append(
                tuple(
                    6 * int(0 in partition_map[vertex][block_index]) - block_size
                    if vertex in orbit
                    else 0
                    for vertex in balanced
                )
            )
    expected_standard_matrix = (
        (12, 0, 6, -4, 8),
        (0, 12, 0, 8, -4),
        (8, 0, 12, 0, 4),
        (-4, 6, 0, 12, -8),
        (24, -12, 12, -24, 36),
    )
    expected_antipode_matrix = (
        (0, 0, 0, 1, 0),
        (0, 0, 1, 0, 0),
        (0, 1, 0, 0, 0),
        (1, 0, 0, 0, 0),
        (0, 0, 0, 0, -1),
    )
    for column, feature in enumerate(standard_features):
        assert gram_times(feature) == tuple(
            sum(standard_features[row][entry] * expected_standard_matrix[row][column] for row in range(5))
            for entry in range(140)
        )
        antipode_feature = tuple(feature[balanced_index[antipode(vertex)]] for vertex in balanced)
        assert antipode_feature == tuple(
            sum(standard_features[row][entry] * expected_antipode_matrix[row][column] for row in range(5))
            for entry in range(140)
        )
    certificate_factors = tuple(
        (tuple(item["coefficients"]), item["exponent"])
        for item in data["balanced_incidence_spectrum"]["characteristic_factors_ascending"]
    )
    assert certificate_factors == EXPECTED_GRAM_FACTORS
    assert data["balanced_incidence_spectrum"]["rank"] == 138
    assert tuple(
        data["balanced_incidence_spectrum"]["specht_block_characteristic_polynomials_ascending"]["(5,1)"]
    ) == standard_block
    assert data["balanced_incidence_spectrum"]["standard_antipode_even_matrix"] == [[8, 6], [8, 12]]
    assert data["balanced_incidence_spectrum"]["standard_antipode_odd_matrix"] == [
        [16, -6, 8],
        [-8, 12, -4],
        [48, -24, 36],
    ]
    even_matrix = ((8, 6), (8, 12))
    odd_matrix = ((16, -6, 8), (-8, 12, -4), (48, -24, 36))
    intertwiner = ((1, 1), (0, -1), (4, 4))
    dark = (5, 2, -6)
    assert tuple(
        tuple(sum(odd_matrix[row][k] * intertwiner[k][column] for k in range(3)) for column in range(2))
        for row in range(3)
    ) == tuple(
        tuple(3 * sum(intertwiner[row][k] * even_matrix[k][column] for k in range(2)) for column in range(2))
        for row in range(3)
    )
    gluing = tuple((intertwiner[row][0], intertwiner[row][1], dark[row]) for row in range(3))
    determinant = (
        gluing[0][0] * (gluing[1][1] * gluing[2][2] - gluing[1][2] * gluing[2][1])
        - gluing[0][1] * (gluing[1][0] * gluing[2][2] - gluing[1][2] * gluing[2][0])
        + gluing[0][2] * (gluing[1][0] * gluing[2][1] - gluing[1][1] * gluing[2][0])
    )
    assert determinant == data["balanced_incidence_spectrum"]["intertwiner_plus_dark_line_index"] == 26
    assert all((6 * intertwiner[row][0] + 2 * intertwiner[row][1] + dark[row]) % 13 == 0 for row in range(3))

    # A second direct implementation checks all 64 Boolean controls and ranks.
    boolean = Counter()
    for point in itertools.product((-1, 1), repeat=6):
        amplitudes = values(cubics, point)
        ranks = tuple(rank(commutator(conference, point)) for conference in conferences)
        boolean[(sum(entry == 1 for entry in point), sum(entry == 0 for entry in amplitudes), ranks)] += 1
    expected_counts = {0: 1, 1: 6, 2: 15, 3: 20, 4: 15, 5: 6, 6: 1}
    assert {weight: count for (weight, _, _), count in boolean.items()} == expected_counts
    for (weight, zero_count, ranks), count in boolean.items():
        if weight in (0, 6):
            assert zero_count == 6 and ranks == (0,) * 6
        elif weight in (1, 5):
            assert zero_count == 6 and ranks == (2,) * 6
        elif weight in (2, 4):
            assert zero_count == 6 and ranks == (4,) * 6
        else:
            assert zero_count == 0 and ranks == (6,) * 6 and count == 20

    # Exhaust a separate exact integer box as a drift detector for the identities.
    checked = 0
    for first_five in itertools.product(range(-2, 3), repeat=5):
        point = first_five + (0,)
        amplitudes = values(cubics, point)
        assert sum(amplitudes) == 0
        assert sum(entry**3 for entry in amplitudes) == 0
        checked += 1
    assert checked == 3125
    print("replayed 860 chambers, index-26 sqrt(13) intertwiner, 64 Boolean controls, and 3125 identity points")


if __name__ == "__main__":
    main()
