#!/usr/bin/env python3
"""Recover the Paper-IV geometry from the low shells of its frame metacode."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ORBIT_TOOL = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.py"
ORBIT_CERT = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json"
CODE_CERT = ROOT / "notes/2026-08-04-c682-paper-iv-frame-metacode.json"
TRACKED = ROOT / "notes/2026-08-04-c682-paper-iv-metacode-geometry.json"
FRAME = 91


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def decode_word(record: dict[str, object]) -> int:
    lanes = [int(value, 16) for value in record["words_le"]]
    return sum(lane << (64 * index) for index, lane in enumerate(lanes))


def permute_word(word: int, permutation: tuple[int, ...]) -> int:
    answer = 0
    while word:
        bit = word & -word
        answer |= 1 << permutation[bit.bit_length() - 1]
        word ^= bit
    return answer


def encode_support(support, point_index) -> int:
    return sum(1 << point_index[point] for point in support)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    orbit_tool = load(ORBIT_TOOL, "c682_orbit_correspondence")
    source = orbit_tool.load_source()
    orbit_cert = json.loads(ORBIT_CERT.read_text())
    code_cert = json.loads(CODE_CERT.read_text())
    assert code_cert["low_shell_ceiling"] >= 38

    group = tuple(source.projective_group())
    points = tuple(source.internal_points())
    point_index = {point: index for index, point in enumerate(points)}
    left = orbit_tool.transformed_orbit(source, group, source.REPRESENTATIVES[0])
    right = orbit_tool.transformed_orbit(source, group, source.REPRESENTATIVES[1])
    assert len(group) == 2184 and len(points) == 78
    assert len(left) == len(right) == FRAME
    left_index = {support: index for index, support in enumerate(left)}
    right_index = {support: index for index, support in enumerate(right)}

    frame_permutations = []
    point_permutations = []
    for element in group:
        left_permutation = tuple(
            left_index[tuple(sorted(source.act_quadratic(element, point) for point in support))]
            for support in left
        )
        right_permutation = tuple(
            right_index[tuple(sorted(source.act_quadratic(element, point) for point in support))]
            for support in right
        )
        frame_permutations.append(
            left_permutation + tuple(FRAME + index for index in right_permutation)
        )
        point_permutations.append(
            tuple(point_index[source.act_quadratic(element, point)] for point in points)
        )

    low_shells: dict[int, set[int]] = {}
    for record in code_cert["low_shell_words"]:
        low_shells.setdefault(record["weight"], set()).add(decode_word(record))
    assert {weight: len(words) for weight, words in low_shells.items()} == {28: 78, 38: 2184}

    columns = tuple(
        sum(int(lane, 16) << (64 * index) for index, lane in enumerate(words))
        for words in orbit_cert["correspondence"]["paired_coordinate_column_words_le"]
    )
    assert len(set(columns)) == 78 and set(columns) == low_shells[28]
    minimum_shell_span_dimension = source.binary_rank(list(columns))
    assert minimum_shell_span_dimension == 36

    for frame_permutation, point_permutation in zip(frame_permutations, point_permutations):
        for point, column in enumerate(columns):
            assert permute_word(column, frame_permutation) == columns[point_permutation[point]]

    minimum_seed = min(low_shells[28])
    minimum_orbit = {
        permute_word(minimum_seed, permutation) for permutation in frame_permutations
    }
    minimum_stabilizer = [
        element
        for element, permutation in zip(group, frame_permutations)
        if permute_word(minimum_seed, permutation) == minimum_seed
    ]
    minimum_profile = Counter(source.projective_order(element) for element in minimum_stabilizer)
    assert minimum_orbit == low_shells[28]
    assert len(minimum_stabilizer) == 28
    assert minimum_profile == {1: 1, 2: 15, 7: 6, 14: 6}

    unseen = set(low_shells[38])
    next_orbits = []
    while unseen:
        seed = min(unseen)
        orbit = {permute_word(seed, permutation) for permutation in frame_permutations}
        assert orbit <= low_shells[38]
        stabilizer = [
            element
            for element, permutation in zip(group, frame_permutations)
            if permute_word(seed, permutation) == seed
        ]
        profile = Counter(source.projective_order(element) for element in stabilizer)
        assert len(orbit) * len(stabilizer) == len(group)
        next_orbits.append(
            {
                "size": len(orbit),
                "stabilizer_order": len(stabilizer),
                "stabilizer_element_order_profile": dict(sorted(profile.items())),
            }
        )
        unseen.difference_update(orbit)
    next_orbits.sort(key=lambda record: (record["size"], record["stabilizer_order"]))

    reconstructed_left = tuple(
        sum(((column >> row) & 1) << point for point, column in enumerate(columns))
        for row in range(FRAME)
    )
    reconstructed_right = tuple(
        sum(((column >> (FRAME + row)) & 1) << point for point, column in enumerate(columns))
        for row in range(FRAME)
    )
    original_left = tuple(encode_support(support, point_index) for support in left)
    original_right = tuple(encode_support(support, point_index) for support in right)
    assert reconstructed_left == original_left
    assert reconstructed_right == original_right
    assert {row.bit_count() for row in reconstructed_left + reconstructed_right} == {12}
    assert source.binary_rank(list(reconstructed_left)) == 36
    assert source.binary_rank(list(reconstructed_right)) == 36

    incidence_columns = source.incidence_columns(list(points), source.passant_lines())
    assert all(
        source.xor_all(
            tuple(incidence_columns[index] for index in range(78) if row >> index & 1)
        )
        == 0
        for row in reconstructed_left + reconstructed_right
    )

    result = {
        "schema": "c682-paper-iv-metacode-geometry-v1",
        "field_order": 13,
        "group": "PGL(2,13)",
        "group_order": len(group),
        "metacode": {"length": 182, "dimension": 37, "minimum_distance": 28},
        "minimum_shell": {
            "weight": 28,
            "size": len(minimum_orbit),
            "orbit_count": 1,
            "stabilizer_order": len(minimum_stabilizer),
            "stabilizer": "D28",
            "stabilizer_element_order_profile": dict(sorted(minimum_profile.items())),
            "homogeneous_space": "PGL(2,13)/D28",
            "equals_paired_coordinate_columns": True,
            "equivariant_coordinate_recovery": True,
            "span_parameters": [182, 36, 28],
        },
        "next_shell": {
            "weight": 38,
            "size": len(low_shells[38]),
            "orbit_count": len(next_orbits),
            "orbits": next_orbits,
            "regular_group_orbit": len(next_orbits) == 1
            and next_orbits[0]["stabilizer_order"] == 1,
        },
        "reconstruction": {
            "left_support_family_size": len(reconstructed_left),
            "right_support_family_size": len(reconstructed_right),
            "support_weight": 12,
            "left_binary_rank": source.binary_rank(list(reconstructed_left)),
            "right_binary_rank": source.binary_rank(list(reconstructed_right)),
            "left_exactly_original_octahedral_orbit": True,
            "right_exactly_original_toric_orbit": True,
            "all_rows_have_zero_passant_syndrome": True,
            "paper_iv_minimum_geometry_replay": True,
        },
        "trusted_inputs": [
            "notes/2026-08-04-c682-paper-iv-orbit-correspondence.py",
            "notes/2026-08-04-c682-paper-iv-orbit-correspondence.json",
            "notes/2026-08-04-c682-paper-iv-frame-metacode.json",
            "papers/q13-passant-code/verification/verify_minimum_geometry.py",
        ],
    }
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    print(encoded, end="")
    if args.output:
        args.output.write_text(encoded)
    if args.check:
        assert args.check.read_text() == encoded


if __name__ == "__main__":
    main()
