#!/usr/bin/env python3
"""Size the nucleus-plus-four-Z3-orbits C201 family in PG(2,64)."""

from __future__ import annotations

import collections

import probe_c201_q64_baer as field


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
    omega = next(x for x in range(2, field.Q) if field.power(x, 3) == 1)
    matrix = ((field.mul(omega, omega), 0, 0), (0, omega, 0), (0, 0, 1))
    orbits = point_orbits(field.point_permutation(matrix))
    conic = {
        field.POINT_INDEX[(0, 0, 1)],
        *(field.POINT_INDEX[(1, t, field.mul(t, t))] for t in range(field.Q)),
    }
    nucleus = field.POINT_INDEX[(0, 1, 0)]
    outside = [orbit for orbit in orbits if len(orbit) == 3 and not set(orbit) & conic]
    legal = [orbit for orbit in outside if field.is_arc((nucleus,) + orbit)]

    degrees = [0] * len(legal)
    edges = 0
    for i, left in enumerate(legal):
        for j in range(i + 1, len(legal)):
            if field.is_arc((nucleus,) + left + legal[j]):
                edges += 1
                degrees[i] += 1
                degrees[j] += 1

    n = len(legal)
    minimum_degree = min(degrees)
    maximum_complement_degree = n - 1 - minimum_degree
    common_neighbor_lower = 2 * minimum_degree - (n - 2)
    induced_degree_lower = common_neighbor_lower - 1 - maximum_complement_degree
    induced_edges_lower = common_neighbor_lower * induced_degree_lower // 2
    pairwise_compatible_quadruples_lower = edges * induced_edges_lower // 6
    normalizer_order = 2 * (field.Q - 1) * 6  # split-torus normalizer times field automorphisms

    print(f"omega {omega} point_orbit_lengths {dict(sorted(collections.Counter(map(len, orbits)).items()))}")
    print(f"outside_three_orbits {len(outside)} legal_with_nucleus {n}")
    print(
        f"compatible_pairs {edges} degree_range {minimum_degree}..{max(degrees)} "
        f"common_neighbor_lower {common_neighbor_lower}"
    )
    print(f"pairwise_compatible_quadruples_lower {pairwise_compatible_quadruples_lower}")
    print(
        f"normalizer_order_bound {normalizer_order} "
        f"normalizer_quotient_lower {pairwise_compatible_quadruples_lower // normalizer_order}"
    )
    print("full_union_enumeration REJECTED: symbolic mixed-orbit constraints required")


if __name__ == "__main__":
    main()
