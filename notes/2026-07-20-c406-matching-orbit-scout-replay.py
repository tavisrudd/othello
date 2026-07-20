#!/usr/bin/env python3
"""Independent permutation-only replay of the C406 Gate-1 certificate."""

from __future__ import annotations

import itertools
import json
from collections import Counter, deque
from pathlib import Path


CERT = Path(__file__).with_name("2026-07-20-c406-matching-orbit-scout.json")


def normalize_pair(pair, q):
    pivot = next(value % q for value in pair if value % q)
    scale = pow(pivot, -1, q)
    return tuple(value * scale % q for value in pair)


def mobius_group(q):
    points = tuple([(1, value) for value in range(q)] + [(0, 1)])
    point_index = {point: index for index, point in enumerate(points)}
    matrices = set()
    for entries in itertools.product(range(q), repeat=4):
        a, b, c, d = entries
        if (a * d - b * c) % q == 0:
            continue
        pivot = next(value for value in entries if value)
        scale = pow(pivot, -1, q)
        matrices.add(tuple(value * scale % q for value in entries))
    actions = {
        tuple(
            point_index[normalize_pair((a * x + b * y, c * x + d * y), q)]
            for x, y in points
        ): (a * d - b * c) % q
        for a, b, c, d in matrices
    }
    group = set(actions)
    squares = {value * value % q for value in range(1, q)}
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    assert len(group) == q * (q * q - 1)
    assert len(psl) * 2 == len(group)
    return points, group, psl


def matchings(indices):
    if not indices:
        yield ()
        return
    first = indices[0]
    for position in range(1, len(indices)):
        second = indices[position]
        remainder = indices[1:position] + indices[position + 1 :]
        for tail in matchings(remainder):
            yield ((first, second),) + tail


def act(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in matching))


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def closure(generators, degree):
    identity = tuple(range(degree))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            child = compose(current, generator)
            if child not in group:
                group.add(child)
                queue.append(child)
    return group


def subgroup_from_target_matching(full_group, matching, expected_order):
    stabilizer = {element for element in full_group if act(element, matching) == matching}
    assert len(stabilizer) == expected_order
    return stabilizer


def multiply(left, right, q):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % q
    return tuple(result)


def endpoint_product(points, q):
    result = (1,)
    for s, t in points:
        result = multiply(result, (t, -s), q)
    return result


def main():
    certificate = json.loads(CERT.read_text())
    assert certificate["schema"] == "c406-matching-orbit-scout-v1"
    expected_distributions = {
        "A3": Counter({(5, 24): 1, (10, 12): 1}),
        "B3": Counter({(14, 24): 1, (21, 16): 1, (28, 12): 1, (42, 8): 1}),
        "H3": Counter({
            (22, 60): 1,
            (55, 24): 2,
            (66, 20): 1,
            (110, 12): 3,
            (132, 10): 1,
            (165, 8): 3,
            (220, 6): 3,
            (330, 4): 8,
            (660, 2): 9,
        }),
    }
    for record in certificate["types"]:
        name = record["type"]
        q = record["field_order"]
        points, full_group, psl_group = mobius_group(q)
        all_matchings = tuple(matchings(tuple(range(q + 1))))
        unseen = set(all_matchings)
        distribution = Counter()
        target = None
        while unseen:
            representative = min(unseen)
            orbit = {act(element, representative) for element in full_group}
            unseen -= orbit
            stabilizer_order = len(full_group) // len(orbit)
            distribution[(len(orbit), stabilizer_order)] += 1
            if len(orbit) == record["target_orbit_size"]:
                assert target is None
                target = orbit
        assert distribution == expected_distributions[name]
        recorded_distribution = Counter(
            (item["orbit_size"], item["stabilizer_order"]) for item in record["all_orbits"]
        )
        assert distribution == recorded_distribution
        assert target is not None

        base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
        parent = subgroup_from_target_matching(full_group, base_matching, record["coxeter_parent_order"])
        fixed = [
            matching
            for matching in all_matchings
            if all(act(element, matching) == matching for element in parent)
        ]
        assert fixed == [base_matching]
        assert {act(element, base_matching) for element in full_group} == target

        unseen_target = set(target)
        sheet_sizes = []
        all_edges = set(itertools.combinations(range(q + 1), 2))
        while unseen_target:
            representative = min(unseen_target)
            sheet = {act(element, representative) for element in psl_group}
            unseen_target -= sheet
            edge_counts = Counter(edge for matching in sheet for edge in matching)
            assert set(edge_counts) == all_edges and set(edge_counts.values()) == {1}
            sheet_sizes.append(len(sheet))
        assert sorted(sheet_sizes) == record["psl_target_orbit_sizes"]
        assert record["psl_orbits_are_one_factorizations"] is True

        common = endpoint_product(points, q)
        expected = [0] * (q + 2)
        expected[1] = 1
        expected[q] = q - 1
        assert common == tuple(expected) == tuple(record["common_restricted_form"])
        assert len(all_matchings) == record["factorization_products_checked"]

        # A second construction finds a small generating set for the recorded stabilizer and
        # verifies that its orbit closure has the full recorded parent order.
        generators = []
        generated = closure(generators, q + 1)
        for element in sorted(parent):
            if element not in generated:
                generators.append(element)
                generated = closure(generators, q + 1)
            if generated == parent:
                break
        assert generated == parent

    assert certificate["gate_1_summary"]["gate_2_authorized_by_gate_1"] is True
    assert certificate["gate_1_summary"]["gate_2_executed"] is False
    print("C406 Gate 1 independent replay OK")


if __name__ == "__main__":
    main()
