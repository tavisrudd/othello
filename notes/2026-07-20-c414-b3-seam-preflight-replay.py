#!/usr/bin/env python3
"""Independent matching-only replay of the q=7 B3 seam preflight."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERT = json.loads((ROOT / "2026-07-20-c414-b3-seam-preflight.json").read_text())
SOURCE = json.loads((ROOT / "2026-07-20-c406-matching-orbit-scout.json").read_text())
Q = 7


def normalize_pair(pair):
    pivot = next(value % Q for value in pair if value % Q)
    inverse = pow(pivot, -1, Q)
    return tuple(value * inverse % Q for value in pair)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(permutation):
    result = [0] * len(permutation)
    for index, image in enumerate(permutation):
        result[image] = index
    return tuple(result)


def conjugate(permutation, subgroup):
    inv = inverse(permutation)
    return frozenset(compose(compose(permutation, element), inv) for element in subgroup)


def mobius_group():
    points = tuple([(1, value) for value in range(Q)] + [(0, 1)])
    point_index = {point: index for index, point in enumerate(points)}
    actions = {}
    for entries in itertools.product(range(Q), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % Q
        if not determinant:
            continue
        pivot = next(value for value in entries if value)
        if pivot != 1:
            continue
        permutation = tuple(
            point_index[normalize_pair((a * x + b * y, c * x + d * y))]
            for x, y in points
        )
        actions[permutation] = determinant
    squares = {1, 2, 4}
    full = set(actions)
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    assert len(full) == 336 and len(psl) == 168
    return full, psl


def act(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def stabilizer(group, matching):
    return {element for element in group if act(element, matching) == matching}


def permutation_order(permutation):
    identity = tuple(range(Q + 1))
    power = identity
    for order in range(1, 25):
        power = compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError


def point_orbits(group):
    unseen = set(range(Q + 1))
    sizes = []
    while unseen:
        seed = min(unseen)
        orbit = {element[seed] for element in group}
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def main():
    assert CERT["schema"] == "c414-b3-seam-preflight-v1"
    b3 = next(record for record in SOURCE["types"] if record["type"] == "B3")
    base_matching = tuple(tuple(edge) for edge in b3["coxeter_invariant_matching"])
    assert [list(edge) for edge in base_matching] == CERT["base_matching"]

    full, psl = mobius_group()
    parent = stabilizer(full, base_matching)
    assert len(parent) == 24 and parent <= psl
    same_matchings = {act(element, base_matching) for element in psl}
    opposite_matchings = {act(element, base_matching) for element in full - psl}
    assert len(same_matchings) == len(opposite_matchings) == 7
    assert not (same_matchings & opposite_matchings)

    seam_counts = Counter()
    for matching in opposite_matchings:
        other = stabilizer(full, matching)
        common = parent & other
        order_counts = Counter(permutation_order(element) for element in common)
        overlap = len(set(base_matching) & set(matching))
        endpoint_orbits = point_orbits(common)
        if len(common) == 6:
            assert order_counts == {1: 1, 2: 3, 3: 2}
            assert overlap == 1 and endpoint_orbits == [2, 6]
            seam_counts["S3"] += 1
        elif len(common) == 8:
            assert order_counts == {1: 1, 2: 5, 4: 2}
            assert overlap == 0 and endpoint_orbits == [8]
            seam_counts["D8"] += 1
        else:
            raise AssertionError
    assert seam_counts == CERT["opposite_seam_type_counts"] == {"S3": 4, "D8": 3}

    opposite_parents = {frozenset(stabilizer(full, matching)) for matching in opposite_matchings}
    orbit_summary = []
    while opposite_parents:
        seed = min(opposite_parents, key=lambda group: sorted(group))
        orbit = {conjugate(element, seed) for element in parent}
        opposite_parents -= orbit
        orbit_summary.append((len(orbit), len(parent & set(seed))))
    assert sorted(orbit_summary) == [(3, 8), (4, 6)]
    print("C414 independent q=7 B3 seam preflight replay OK")


if __name__ == "__main__":
    main()
