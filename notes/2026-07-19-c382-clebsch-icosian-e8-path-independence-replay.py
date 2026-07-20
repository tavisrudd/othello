#!/usr/bin/env python3
"""Independent direct-enumeration replay for C382; imports no C382 code."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
import sys
from collections import deque
from pathlib import Path

CERT = Path(__file__).with_name("2026-07-19-c382-clebsch-icosian-e8-path-independence.json")
C379_REPLAY = Path(__file__).with_name("2026-07-19-c379-clebsch-deep-hole-extension-replay.py")
C379_REPLAY_SHA256 = "515d45ee2a30a9381c446c035ff7cea7ae4c919faa1a3d3db205ee40a6e522f8"


def mul(p, q):
    return tuple(p[q[i]] for i in range(5))


def inv(p):
    return tuple(p.index(i) for i in range(5))


def even(p):
    return sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5)) % 2 == 0


def order(p):
    x = tuple(range(5))
    for n in range(1, 7):
        x = mul(p, x)
        if x == tuple(range(5)):
            return n
    raise AssertionError


def sylow_five_character():
    a5 = tuple(p for p in itertools.permutations(range(5)) if even(p))
    cyclic = set()
    for g in a5:
        if order(g) == 5:
            subgroup = frozenset(
                tuple(range(5)) if exponent == 0 else power(g, exponent)
                for exponent in range(5)
            )
            cyclic.add(subgroup)
    assert len(cyclic) == 6
    result = {}
    for n in (1, 2, 3, 5):
        counts = set()
        for g in a5:
            if order(g) != n:
                continue
            gi = inv(g)
            counts.add(sum(frozenset(mul(mul(g, h), gi) for h in subgroup) == subgroup for subgroup in cyclic))
        assert len(counts) == 1
        result[str(n)] = counts.pop()
    return result


def power(g, exponent):
    result = tuple(range(5))
    for _ in range(exponent):
        result = mul(g, result)
    return result


def d8_data():
    roots = set()
    for support in itertools.combinations(range(8), 2):
        for signs in itertools.product((-1, 1), repeat=2):
            root = [0] * 8
            for index, sign in zip(support, signs):
                root[index] = sign
            roots.add(tuple(root))
    pairs = {
        frozenset((a, b)) for a in roots for b in roots
        if a < b and sum(x * y for x, y in zip(a, b)) == -1
    }
    generators = []
    for i in range(7):
        generators.append((tuple(i + 1 if j == i else i if j == i + 1 else j for j in range(8)), (1,) * 8))
    generators.append((tuple(range(8)), (-1, -1, 1, 1, 1, 1, 1, 1)))

    def act(root, generator):
        permutation, signs = generator
        image = [0] * 8
        for i in range(8):
            image[permutation[i]] = signs[i] * root[i]
        return tuple(image)

    seed = next(iter(pairs))
    seen = {seed}
    queue = deque([seed])
    while queue:
        pair = queue.popleft()
        for generator in generators:
            image = frozenset(act(root, generator) for root in pair)
            if image not in seen:
                seen.add(image)
                queue.append(image)
    assert seen == pairs
    return len(roots), len(pairs)


def geometric_fibre_character():
    assert hashlib.sha256(C379_REPLAY.read_bytes()).hexdigest() == C379_REPLAY_SHA256
    spec = importlib.util.spec_from_file_location("c379_replay_for_c382", C379_REPLAY)
    assert spec and spec.loader
    geometry = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = geometry
    spec.loader.exec_module(geometry)
    parent = frozenset(geometry.six_points(8))
    a5 = geometry.a5(8)
    plane = geometry.projective_points()
    conic = frozenset(point for point in plane if geometry.dot(point, point) == 0)
    pair = min(geometry.obstruction_matching(parent, conic), key=lambda item: tuple(sorted(item)))
    stabilizer = [
        matrix for matrix in a5
        if frozenset(geometry.normalize(geometry.mv(matrix, point)) for point in pair) == pair
    ]
    assert len(stabilizer) == 10

    def projective_order(matrix):
        value = geometry.I
        for result in range(1, 11):
            value = geometry.normm(geometry.mm(value, matrix))
            if value == geometry.I:
                return result
        raise AssertionError("projective order exceeds D10")

    result = {}
    for element_order in (1, 2, 5):
        traces = {
            sum(geometry.normalize(geometry.mv(matrix, point)) == point for point in parent | pair)
            for matrix in stabilizer if projective_order(matrix) == element_order
        }
        assert len(traces) == 1
        result[str(element_order)] = traces.pop()
    return result


def main():
    certificate = json.loads(CERT.read_text())
    root_count, pair_count = d8_data()
    pair_character = sylow_five_character()
    fibre_character = geometric_fibre_character()
    assert (root_count, pair_count) == (112, 1344)
    assert pair_character == {"1": 6, "2": 2, "3": 0, "5": 1}
    assert fibre_character == {"1": 8, "2": 2, "5": 3}

    # Independent representation-ring calculation using the A5 character table.
    irreducibles = {
        "1": (1, 1, 1, 1, 1),
        "3": (3, -1, 0, "phi", "phi'"),
        "3'": (3, -1, 0, "phi'", "phi"),
        "5": (5, 1, -1, 0, 0),
    }
    assert tuple(3 * irreducibles["1"][i] + irreducibles["5"][i] for i in range(3)) == (8, 4, 2)
    assert tuple(2 * irreducibles["1"][i] + irreducibles["3"][i] + irreducibles["3'"][i] for i in range(3)) == (8, 0, 2)
    assert certificate["marked_d8"]["root_count"] == root_count
    assert certificate["marked_d8"]["unordered_a2_marking_orbit_size"] == pair_count
    assert certificate["c381_family"]["a5_pair_character_by_order"] == pair_character
    assert certificate["c381_family"]["single_fibre_d10_rational_character_by_order"] == fibre_character
    assert certificate["icosian_actions"]["conjugation"]["restricted_d10_character_by_order"] == {"1": 8, "2": 0, "5": 3}
    assert certificate["forced_fixed_child_trivialization"]["rational_e8_character_by_class"]["2"] == 4
    assert certificate["icosian_actions"]["conjugation"]["rational_character_by_class"]["2"] == 0
    assert certificate["gate"]["verdict"] == "RED_CATEGORY_MISMATCH"
    print("C382 independent replay: D8 orbit and A5 character obstruction verified")


if __name__ == "__main__":
    main()
