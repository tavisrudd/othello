#!/usr/bin/env python3
"""C201: order-13 nonsplit-torus orbits relative to the standard q=64 conic."""

from __future__ import annotations

import collections
import itertools

import probe_c201_q64_baer as field


def p1_action(t: int) -> tuple[int, ...]:
    p1 = [(0, 1)] + [(1, x) for x in range(field.Q)]
    index = {p: i for i, p in enumerate(p1)}
    answer = []
    for s, u in p1:
        image = (u, s ^ field.mul(t, u))
        answer.append(index[field.normalize(image)])
    return tuple(answer)


def permutation_order(permutation: tuple[int, ...]) -> int:
    current = tuple(range(len(permutation)))
    identity = current
    for order in range(1, 100):
        current = tuple(permutation[current[i]] for i in range(len(permutation)))
        if current == identity:
            return order
    raise AssertionError("unexpected permutation order")


def point_orbits(permutation: tuple[int, ...]) -> list[tuple[int, ...]]:
    unseen = set(range(len(permutation)))
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = []
        point = seed
        while point not in orbit:
            orbit.append(point)
            point = permutation[point]
        answer.append(tuple(orbit))
        unseen -= set(orbit)
    return answer


def main() -> None:
    parameter = next(t for t in range(1, field.Q) if permutation_order(p1_action(t)) == 13)
    matrix = field.conic_matrix(0, 1, 1, parameter)
    action = field.point_permutation(matrix)
    assert permutation_order(action) == 13
    orbits = point_orbits(action)

    conic = {
        field.POINT_INDEX[(0, 0, 1)],
        *(field.POINT_INDEX[(1, t, field.mul(t, t))] for t in range(field.Q)),
    }
    conic_orbits = [orbit for orbit in orbits if set(orbit) <= conic]
    outside_orbits = [orbit for orbit in orbits if len(orbit) == 13 and not set(orbit) & conic]
    arc_orbits = [orbit for orbit in outside_orbits if field.is_arc(orbit)]
    nucleus = next(orbit[0] for orbit in orbits if len(orbit) == 1)
    assert nucleus not in conic
    assert all(
        all(field.determinant(a, b, nucleus) for a, b in itertools.combinations(orbit, 2))
        for orbit in arc_orbits
    )
    profiles = [field.profile(orbit) for orbit in arc_orbits]

    expected = {
        "rank": 6,
        "nullity": 0,
        "uncovered_size": 1041,
        "spectrum_0_to_6": (1041, 1560, 1326, 208, 0, 0, 13),
        "scaled_defect": 6552,
        "forced_hit_count": 0,
    }
    assert all(profile == expected for profile in profiles)
    assert all(profile["uncovered_size"] > len(conic) for profile in profiles)

    invariance = field.point_permutation(((1, 2, 4), (0, 1, 8), (0, 0, 1)))
    for orbit, profile in zip(arc_orbits, profiles):
        transformed = tuple(reversed([invariance[x] for x in orbit]))
        assert field.profile(transformed) == profile

    print(f"torus_parameter {parameter} action_order {permutation_order(action)} nucleus {nucleus}")
    print(f"point_orbit_lengths {dict(sorted(collections.Counter(map(len, orbits)).items()))}")
    print(
        f"conic_orbits {len(conic_orbits)} outside_orbits {len(outside_orbits)} "
        f"outside_arc_orbits {len(arc_orbits)}"
    )
    print(f"common_profile {expected}")
    print("relative_complete 0")
    print("invariance_check PASS: fixed projectivity plus relabeling on every arc orbit")


if __name__ == "__main__":
    main()
