#!/usr/bin/env python3
"""Extract and check the three local subgroup seeds in C379's conceptual proof."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPLAY = HERE / "2026-07-19-c379-clebsch-deep-hole-extension-replay.py"
OUTPUT = HERE / "2026-07-19-c379-one-factorization-seeds.json"


def load_replay():
    spec = importlib.util.spec_from_file_location("c379_replay", REPLAY)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {REPLAY}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def element_order(replay, matrix):
    power = replay.I
    for order in range(1, 61):
        power = replay.normm(replay.mm(power, matrix))
        if power == replay.I:
            return order
    raise AssertionError("projective element order exceeded 60")


def encode_matching(matching):
    return [[list(point) for point in sorted(edge)] for edge in sorted(matching, key=lambda edge: tuple(sorted(edge)))]


def subgroup_metadata(replay, subgroup):
    spectrum = Counter(element_order(replay, matrix) for matrix in subgroup)
    return {
        "intersection_order": len(subgroup),
        "element_order_histogram": {str(order): count for order, count in sorted(spectrum.items())},
    }


def canonical_hash(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def build_certificate():
    replay = load_replay()
    plus = replay.six_points(8)
    conic = frozenset(point for point in replay.projective_points() if replay.dot(point, point) == 0)
    parent_a5 = replay.a5(8)
    full_group = replay.closure(list(parent_a5) + [replay.J])
    psl = replay.closure([replay.commutator(matrix, replay.J) for matrix in full_group])
    assert len(parent_a5) == 60 and len(psl) == 660 and len(full_group) == 1320
    assert parent_a5 < psl < full_group

    arcs = {replay.image(matrix, plus) for matrix in full_group}
    matchings = {arc: replay.obstruction_matching(arc, conic) for arc in arcs}
    base = matchings[plus]
    plus_sheet_arcs = frozenset(replay.image(matrix, plus) for matrix in psl)
    minus_sheet_arcs = frozenset(arcs - plus_sheet_arcs)
    assert len(plus_sheet_arcs) == len(minus_sheet_arcs) == 11
    plus_sheet = frozenset(matchings[arc] for arc in plus_sheet_arcs)
    minus_sheet = frozenset(matchings[arc] for arc in minus_sheet_arcs)

    def root_fibres(parent):
        fibres = []
        for omitted in sorted(parent):
            rows = [replay.conic_row(point) for point in sorted(parent - {omitted})]
            kernel = replay.nullspace(rows, 6)
            assert len(kernel) == 1
            coefficients = replay.normalize(kernel[0])
            edge = frozenset(
                point for point in conic if replay.dot(coefficients, replay.conic_row(point)) == 0
            )
            assert len(edge) == 2
            fibres.append((omitted, edge))
        assert frozenset(edge for _, edge in fibres) == matchings[parent]
        return fibres

    def resolution_records(sheet_arcs):
        records = []
        for parent in sorted(sheet_arcs, key=lambda arc: tuple(sorted(arc))):
            for omitted, edge in root_fibres(parent):
                records.append(
                    {
                        "edge": [list(point) for point in sorted(edge)],
                        "omitted_parent_point": list(omitted),
                        "parent": [list(point) for point in sorted(parent)],
                    }
                )
        records.sort(key=lambda record: (record["edge"], record["parent"], record["omitted_parent_point"]))
        assert len(records) == 66
        assert len({tuple(tuple(point) for point in record["edge"]) for record in records}) == 66
        return records

    plus_resolution = resolution_records(plus_sheet_arcs)
    minus_resolution = resolution_records(minus_sheet_arcs)
    plus_resolution_set = {
        (
            frozenset(map(tuple, record["parent"])),
            tuple(record["omitted_parent_point"]),
            frozenset(map(tuple, record["edge"])),
        )
        for record in plus_resolution
    }
    minus_resolution_set = {
        (
            frozenset(map(tuple, record["parent"])),
            tuple(record["omitted_parent_point"]),
            frozenset(map(tuple, record["edge"])),
        )
        for record in minus_resolution
    }
    assert {
        (
            replay.image(replay.J, parent),
            replay.normalize(replay.mv(replay.J, omitted)),
            frozenset(replay.normalize(replay.mv(replay.J, point)) for point in edge),
        )
        for parent, omitted, edge in plus_resolution_set
    } == minus_resolution_set

    def stabilizer(matching):
        return {matrix for matrix in psl if replay.act_on_matching(matrix, matching) == matching}

    assert stabilizer(base) == parent_a5

    edge = min((candidate for matching in plus_sheet for candidate in matching), key=lambda item: tuple(sorted(item)))
    edge_orbit = {
        frozenset(replay.normalize(replay.mv(matrix, point)) for point in edge) for matrix in psl
    }
    assert len(edge_orbit) == 66

    for sheet in (plus_sheet, minus_sheet):
        multiplicities = Counter(edge for matching in sheet for edge in matching)
        assert len(multiplicities) == 66 and set(multiplicities.values()) == {1}

    cross_seeds = {}
    for matching in sorted(minus_sheet, key=replay.matching_key):
        intersection = parent_a5 & stabilizer(matching)
        orbit_size = len(parent_a5) // len(intersection)
        assert orbit_size in (5, 6)
        cross_seeds.setdefault(
            orbit_size,
            {
                "matching": encode_matching(matching),
                "shared_edges_with_base": len(base & matching),
                "suborbit_size": orbit_size,
                **subgroup_metadata(replay, intersection),
            },
        )
    assert set(cross_seeds) == {5, 6}
    assert cross_seeds[5]["element_order_histogram"] == {"1": 1, "2": 3, "3": 8}
    assert cross_seeds[6]["element_order_histogram"] == {"1": 1, "2": 5, "5": 4}
    assert cross_seeds[5]["shared_edges_with_base"] == 0
    assert cross_seeds[6]["shared_edges_with_base"] == 1

    same_matching = min(plus_sheet - {base}, key=replay.matching_key)
    same_intersection = parent_a5 & stabilizer(same_matching)
    same_seed = {
        "matching": encode_matching(same_matching),
        "shared_edges_with_base": len(base & same_matching),
        "suborbit_size": len(parent_a5) // len(same_intersection),
        **subgroup_metadata(replay, same_intersection),
    }
    assert same_seed["suborbit_size"] == 10
    assert same_seed["element_order_histogram"] == {"1": 1, "2": 3, "3": 2}
    assert same_seed["shared_edges_with_base"] == 0

    ordered_plus = sorted(plus_sheet, key=replay.matching_key)
    golden_share = [
        [int(len(left & replay.act_on_matching(replay.J, right)) == 1) for right in ordered_plus]
        for left in ordered_plus
    ]
    assert golden_share == [list(row) for row in zip(*golden_share)]
    assert {sum(row) for row in golden_share} == {6}
    golden_disjoint = [[1 - value for value in row] for row in golden_share]
    share_absolute_points = sum(golden_share[index][index] for index in range(11))
    disjoint_absolute_points = sum(golden_disjoint[index][index] for index in range(11))
    assert share_absolute_points + disjoint_absolute_points == 11

    return {
        "schema": "othello.c379.one_factorization_seeds.v1",
        "field_order": 11,
        "conventions": {
            "base_parent": "tau=8",
            "conic": "X^2+Y^2+Z^2=0",
            "matrix_action": "left action on normalized projective column vectors",
            "matching_order": "lexicographic in normalized F_11 triples",
        },
        "group_orders": {"A5": 60, "PSL2_11": 660, "PGL2_11": 1320},
        "base_matching": encode_matching(base),
        "base_root_map": [
            {"omitted_parent_point": list(omitted), "edge": [list(point) for point in sorted(edge)]}
            for omitted, edge in root_fibres(plus)
        ],
        "edge_orbit_size": len(edge_orbit),
        "cross_sheet_seeds": {
            "orbit_5_A4": cross_seeds[5],
            "orbit_6_D10": cross_seeds[6],
        },
        "same_sheet_seed": same_seed,
        "root_resolutions": {
            "record_counts": [len(plus_resolution), len(minus_resolution)],
            "edge_multiplicities_per_sheet": [1, 1],
            "golden_J_exchanges_labelled_resolutions": True,
            "tau8_canonical_sha256": canonical_hash(plus_resolution),
            "tau4_canonical_sha256": canonical_hash(minus_resolution),
        },
        "golden_polarity": {
            "share_edge_incidence_is_symmetric": True,
            "share_edge_absolute_point_count": share_absolute_points,
            "disjointness_absolute_point_count": disjoint_absolute_points,
        },
    }


def canonical_bytes(certificate):
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(generated)
        return
    tracked = OUTPUT.read_bytes()
    if tracked != generated:
        raise SystemExit(f"stale certificate: regenerate with {Path(__file__).name} --write")
    print("C379 conceptual seeds: OK")


if __name__ == "__main__":
    main()
