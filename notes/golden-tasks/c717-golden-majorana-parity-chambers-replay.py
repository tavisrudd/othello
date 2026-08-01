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

    incidence = Counter((sum(entry > 0 for entry in pattern), len(orders)) for pattern, orders in feasible.items())
    assert incidence == Counter({(2, 24): 15, (3, 108): 20, (4, 24): 15})

    chamber = {}
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
    print("replayed 860 chambers, connected diameter-10 adjacency, 64 Boolean controls, and 3125 identity points")


if __name__ == "__main__":
    main()
