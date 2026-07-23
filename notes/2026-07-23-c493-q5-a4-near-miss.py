#!/usr/bin/env python3
"""C493: exact q=5/A4 near-miss certificate.

Run from /home/tavis/src/othello:
    python3 notes/2026-07-23-c493-q5-a4-near-miss.py --check
    python3 notes/2026-07-23-c493-q5-a4-near-miss.py --write
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
Q = 5
POINTS = frozenset(range(Q + 1))


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


C406 = load_module("c406_for_c493", C406_PATH)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def all_matchings(points):
    points = tuple(points)
    if not points:
        return [()]
    first = points[0]
    result = []
    for index in range(1, len(points)):
        second = points[index]
        rest = points[1:index] + points[index + 1 :]
        for tail in all_matchings(rest):
            edge = (min(first, second), max(first, second))
            result.append(tuple(sorted((edge,) + tail)))
    return sorted(result)


def matching_image(perm, matching):
    return tuple(
        sorted((min(perm[a], perm[b]), max(perm[a], perm[b])) for a, b in matching)
    )


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(perm):
    result = [0] * len(perm)
    for i, value in enumerate(perm):
        result[value] = i
    return tuple(result)


def canonical_transversal(subset):
    subset = tuple(sorted(subset))
    complement = tuple(sorted(POINTS - set(subset)))
    return min(subset, complement)


def complementary_triangle_pairs(matching):
    """The four choices of one endpoint per edge, modulo complementation."""
    return tuple(
        sorted(
            {
                canonical_transversal(matching[i][bit] for i, bit in enumerate(bits))
                for bits in itertools.product((0, 1), repeat=3)
            }
        )
    )


def permutation_parity(perm):
    inversions = sum(
        perm[i] > perm[j]
        for i in range(len(perm))
        for j in range(i + 1, len(perm))
    )
    return inversions % 2


def transversal_permutation(perm, matching):
    target_matching = matching_image(perm, matching)
    source_four = complementary_triangle_pairs(matching)
    target_four = complementary_triangle_pairs(target_matching)
    return tuple(
        target_four.index(canonical_transversal(perm[x] for x in transversal))
        for transversal in source_four
    )


def oriented_image(perm, decorated):
    """Transport an orientation of the four complementary triangle pairs."""
    matching, orientation = decorated
    target_matching = matching_image(perm, matching)
    induced = transversal_permutation(perm, matching)
    return target_matching, orientation ^ permutation_parity(induced)


def is_involution(perm):
    return all(perm[perm[i]] == i for i in range(len(perm)))


def orbits(group, objects, action):
    unseen = set(objects)
    answer = []
    while unseen:
        base = min(unseen)
        orbit = {action(g, base) for g in group}
        answer.append(frozenset(orbit))
        unseen -= orbit
    return sorted(answer, key=lambda orbit: (len(orbit), sorted(orbit)))


def profile_fibres(avatar, plus_sheet, x, y):
    x_edges = set(x[0])
    y_edges = set(y[0])
    buckets = {}
    for z in avatar:
        profile = (
            "+" if z in plus_sheet else "-",
            len(set(z[0]) & x_edges),
            len(set(z[0]) & y_edges),
        )
        buckets.setdefault(profile, set()).add(z)
    return {frozenset(fibre) for fibre in buckets.values()}


def pair_record(group, avatar, plus_sheet, x, swap):
    y = oriented_image(swap, x)
    stabilizer_x = {g for g in group if oriented_image(g, x) == x}
    k_group = {g for g in stabilizer_x if oriented_image(g, y) == y}
    k_orbits = set(orbits(k_group, avatar, oriented_image))
    fibres = profile_fibres(avatar, plus_sheet, x, y)
    return {
        "mate": [list(map(list, y[0])), y[1]],
        "same_underlying_matching": y[0] == x[0],
        "K_order": len(k_group),
        "K_orbit_sizes": sorted(map(len, k_orbits)),
        "middle_strata": len(k_orbits),
        "profile_fibre_sizes": sorted(map(len, fibres)),
        "profile_fibres_equal_K_orbits": fibres == k_orbits,
    }


def build_certificate():
    conic, parameters = C406.C399.conic_parameterization(Q)
    group, psl = C406.full_pgl(Q, parameters)
    group = tuple(group)
    psl = frozenset(psl)

    matchings = all_matchings(range(Q + 1))
    matching_orbits = orbits(group, matchings, matching_image)
    assert sorted(map(len, matching_orbits)) == [5, 10]
    special_orbit = next(orbit for orbit in matching_orbits if len(orbit) == 5)
    ordinary_orbit = next(orbit for orbit in matching_orbits if len(orbit) == 10)
    base_matching = min(special_orbit)
    x = (base_matching, 0)

    assert len(complementary_triangle_pairs(base_matching)) == 4
    avatar = frozenset(oriented_image(g, x) for g in group)
    plus_sheet = frozenset(oriented_image(g, x) for g in psl)
    minus_sheet = avatar - plus_sheet
    assert len(avatar) == 10
    assert len(plus_sheet) == len(minus_sheet) == 5
    assert Counter(matching for matching, _ in avatar) == Counter(
        {matching: 2 for matching in special_orbit}
    )
    sheet_sign = {z: 0 if z in plus_sheet else 1 for z in avatar}
    assert len({(z[0], sheet_sign[z]) for z in avatar}) == len(avatar)
    assert all(
        sheet_sign[oriented_image(g, z)] == (sheet_sign[z] ^ (g not in psl))
        for g in group
        for z in avatar
    )

    h_group = frozenset(g for g in group if oriented_image(g, x) == x)
    normalizer_avatar = frozenset(
        g
        for g in group
        if {
            compose(compose(g, h), inverse(g))
            for h in h_group
        }
        == h_group
    )
    matching_stabilizer = frozenset(
        g for g in group if matching_image(g, base_matching) == base_matching
    )
    assert len(h_group) == 12
    assert h_group <= psl
    assert matching_stabilizer == normalizer_avatar
    assert len(normalizer_avatar) == 24
    assert normalizer_avatar & psl == h_group
    transversal_action = {
        transversal_permutation(g, base_matching) for g in matching_stabilizer
    }
    assert len(transversal_action) == 24
    assert {
        g
        for g in matching_stabilizer
        if permutation_parity(transversal_permutation(g, base_matching)) == 0
    } == h_group
    normalizer_orbit_sizes = sorted(
        map(len, orbits(normalizer_avatar, avatar, oriented_image))
    )
    assert normalizer_orbit_sizes == [2, 8]

    outer_involutions = [
        g for g in group if g not in psl and is_involution(g)
    ]
    swaps = [
        g
        for g in outer_involutions
        if oriented_image(g, oriented_image(g, x)) == x
    ]
    same_fibre_swaps = [
        g for g in swaps if oriented_image(g, x)[0] == base_matching
    ]
    distinct_fibre_swaps = [
        g for g in swaps if oriented_image(g, x)[0] != base_matching
    ]
    assert same_fibre_swaps and distinct_fibre_swaps
    normalizer_record = pair_record(
        group, avatar, plus_sheet, x, min(same_fibre_swaps)
    )
    transverse_record = pair_record(
        group, avatar, plus_sheet, x, min(distinct_fibre_swaps)
    )
    assert normalizer_record["K_order"] == 12
    assert normalizer_record["K_orbit_sizes"] == [1, 1, 4, 4]
    assert transverse_record["K_order"] == 3
    assert transverse_record["K_orbit_sizes"] == [1, 1, 1, 1, 3, 3]
    assert normalizer_record["profile_fibres_equal_K_orbits"]
    assert transverse_record["profile_fibres_equal_K_orbits"]

    opposite_h_orbits = orbits(h_group, minus_sheet, oriented_image)
    assert sorted(map(len, opposite_h_orbits)) == [1, 4]
    opposite_components = sorted(opposite_h_orbits, key=lambda orbit: len(orbit))
    stabilizers = [
        frozenset(g for g in h_group if oriented_image(g, min(component)) == min(component))
        for component in opposite_components
    ]
    mackey_matrix = [
        [len(orbits(stabilizer, component, oriented_image)) for component in opposite_components]
        for stabilizer in stabilizers
    ]
    assert mackey_matrix == [[1, 1], [1, 2]]

    undecorated = []
    for orbit in matching_orbits:
        base = min(orbit)
        stabilizer = frozenset(g for g in group if matching_image(g, base) == base)
        undecorated.append(
            {
                "orbit_size": len(orbit),
                "G_stabilizer_order": len(stabilizer),
                "PSL_stabilizer_order": len(stabilizer & psl),
            }
        )

    return {
        "schema": "c493-q5-a4-near-miss-v1",
        "input": {
            "q": Q,
            "points": Q + 1,
            "c406_script_sha256": sha256(C406_PATH),
        },
        "groups": {
            "PGL2_order": len(group),
            "PSL2_order": len(psl),
            "oriented_point_stabilizer_H_order": len(h_group),
            "normalizer_N_order": len(normalizer_avatar),
            "normalizer_quotient_order": len(normalizer_avatar) // len(h_group),
            "H_is_PSL_intersection_of_N": normalizer_avatar & psl == h_group,
            "N_action_on_four_transversal_pairs_order": len(transversal_action),
            "orientation_kernel_is_H": True,
            "N_orbit_sizes_on_oriented_avatar": normalizer_orbit_sizes,
        },
        "undecorated_matchings": sorted(undecorated, key=lambda row: row["orbit_size"]),
        "decorated_avatar": {
            "description": "special matching plus an orientation of its four complementary triangle pairs",
            "size": len(avatar),
            "PSL_sheet_sizes": sorted([len(plus_sheet), len(minus_sheet)]),
            "forgetful_base_size": len(special_orbit),
            "forgetful_fibre_sizes": sorted(
                Counter(matching for matching, _ in avatar).values()
            ),
            "each_sheet_maps_bijectively_to_undecorated_base": (
                len({matching for matching, _ in plus_sheet}) == len(special_orbit)
                and len({matching for matching, _ in minus_sheet}) == len(special_orbit)
            ),
            "oriented_cover_is_gauge_equivalent_to_PGL_over_PSL_sign": True,
            "diagonal_product_G_set": "G/N x G/PSL",
        },
        "opposite_sheet_H_component_sizes": sorted(map(len, opposite_h_orbits)),
        "mackey_matrix": mackey_matrix,
        "mackey_row_sums": [sum(row) for row in mackey_matrix],
        "outer_involution_swaps": {
            "same_fibre_count": len(same_fibre_swaps),
            "distinct_fibre_count": len(distinct_fibre_swaps),
            "distinct_mate_count": len(
                {oriented_image(g, x) for g in distinct_fibre_swaps}
            ),
        },
        "normalizer_pair": normalizer_record,
        "transverse_pair": transverse_record,
        "conclusions": {
            "ten_point_decorated_avatar_exists": True,
            "stabilizer_class_sheet_readout_is_fused": True,
            "canonical_max_K_lattice": [10, 4, 2, 1],
            "transverse_pair_lattice": [10, 6, 2, 1],
            "six_stratum_level_is_pair_type_dependent": True,
        },
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(certificate)
        print(f"wrote {OUTPUT}")
    else:
        if not OUTPUT.exists():
            raise SystemExit(f"missing certificate: {OUTPUT}")
        if OUTPUT.read_bytes() != certificate:
            raise SystemExit("certificate is stale; run with --write")
        print("C493 certificate OK")


if __name__ == "__main__":
    main()
