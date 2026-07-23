#!/usr/bin/env python3
"""Independent replay of the C493 q=5 oriented-matching claims."""

from __future__ import annotations

import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-23-c493-q5-a4-near-miss.json"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
UNIVERSE = set(range(6))


def load_c406():
    spec = importlib.util.spec_from_file_location("c406_for_c493_replay", C406_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def matchings(points):
    if not points:
        return {()}
    first = min(points)
    answer = set()
    for second in points - {first}:
        edge = (first, second)
        for tail in matchings(points - {first, second}):
            answer.add(tuple(sorted((edge,) + tail)))
    return answer


def image(perm, matching):
    return tuple(
        sorted(tuple(sorted((perm[a], perm[b]))) for a, b in matching)
    )


def four_set(matching):
    answer = set()
    for choices in itertools.product((0, 1), repeat=3):
        chosen = {matching[i][choices[i]] for i in range(3)}
        answer.add(min(tuple(sorted(chosen)), tuple(sorted(UNIVERSE - chosen))))
    return tuple(sorted(answer))


def odd(permutation):
    return (
        sum(
            permutation[i] > permutation[j]
            for i in range(4)
            for j in range(i + 1, 4)
        )
        % 2
    )


def action(perm, point):
    matching, sign = point
    target = image(perm, matching)
    source_four = four_set(matching)
    target_four = four_set(target)
    induced = []
    for triangle in source_four:
        moved = {perm[x] for x in triangle}
        representative = min(
            tuple(sorted(moved)), tuple(sorted(UNIVERSE - moved))
        )
        induced.append(target_four.index(representative))
    return target, sign ^ odd(induced)


def orbit(group, point):
    return {action(g, point) for g in group}


def partition(group, points):
    remaining = set(points)
    sizes = []
    while remaining:
        part = orbit(group, min(remaining))
        sizes.append(len(part))
        remaining -= part
    return sorted(sizes)


def main():
    c406 = load_c406()
    _, parameters = c406.C399.conic_parameterization(5)
    group, psl = c406.full_pgl(5, parameters)
    psl = set(psl)

    all_matchings = matchings(set(range(6)))
    matching_parts = []
    remaining = set(all_matchings)
    while remaining:
        part = {image(g, min(remaining)) for g in group}
        matching_parts.append(part)
        remaining -= part
    assert sorted(map(len, matching_parts)) == [5, 10]

    special = next(part for part in matching_parts if len(part) == 5)
    x = (min(special), 0)
    avatar = orbit(group, x)
    plus = orbit(psl, x)
    assert len(avatar) == 10 and len(plus) == 5
    assert {matching for matching, _ in avatar} == special
    assert all(sum(point[0] == matching for point in avatar) == 2 for matching in special)

    h_group = {g for g in group if action(g, x) == x}
    n_group = {g for g in group if image(g, x[0]) == x[0]}
    assert (len(h_group), len(n_group), len(n_group & psl)) == (12, 24, 12)
    assert h_group == n_group & psl
    assert partition(n_group, avatar) == [2, 8]

    outer_involutions = [
        g
        for g in group
        if g not in psl and all(g[g[i]] == i for i in range(6))
    ]
    pair_rows = {}
    for swap in outer_involutions:
        y = action(swap, x)
        if action(swap, y) != x:
            continue
        k_group = {g for g in h_group if action(g, y) == y}
        key = "same" if y[0] == x[0] else "distinct"
        pair_rows.setdefault(key, set()).add(
            (len(k_group), tuple(partition(k_group, avatar)))
        )
    assert pair_rows == {
        "same": {(12, (1, 1, 4, 4))},
        "distinct": {(3, (1, 1, 1, 1, 3, 3))},
    }

    cert = json.loads(CERTIFICATE.read_text())
    assert cert["decorated_avatar"]["size"] == len(avatar)
    assert cert["groups"]["normalizer_N_order"] == len(n_group)
    assert cert["normalizer_pair"]["K_orbit_sizes"] == [1, 1, 4, 4]
    assert cert["transverse_pair"]["K_orbit_sizes"] == [1, 1, 1, 1, 3, 3]
    print("C493 independent replay OK")


if __name__ == "__main__":
    main()
