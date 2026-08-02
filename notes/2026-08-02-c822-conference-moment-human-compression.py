#!/usr/bin/env python3
"""Generate the four-representative C822 local-count certificate."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
from itertools import combinations, permutations
import json
import math
from pathlib import Path


ORDER = 26
ROOT = 25
PAIR_PROFILE = {5: 26000, 6: 497250, 7: 2171000, 8: 2585375}
PROFILE_AFFINE = {
    5: (0, 1, 0),
    6: (0, 0, 1),
    7: (26864500, -20, -6),
    8: (219189750, 65, 15),
    9: (1027130000, -95, -20),
    10: (2034201000, 74, 15),
    11: (1835593500, -30, -6),
    12: (573095250, 5, 1),
}

LATIN_NON_GROUP = (
    (0, 1, 2, 3, 4),
    (1, 0, 3, 4, 2),
    (2, 3, 4, 0, 1),
    (3, 4, 1, 2, 0),
    (4, 2, 0, 1, 3),
)
LATIN_CYCLIC = tuple(tuple((r + c) % 5 for c in range(5)) for r in range(5))

STEINER_NONCYCLIC = (
    (0, 1, 2), (0, 3, 4), (0, 5, 6), (0, 7, 8), (0, 9, 10),
    (0, 11, 12), (1, 3, 5), (1, 4, 7), (1, 6, 9), (1, 8, 11),
    (1, 10, 12), (2, 3, 8), (3, 7, 9), (3, 6, 12), (3, 10, 11),
    (4, 6, 8), (5, 8, 10), (2, 4, 10), (6, 7, 10), (2, 6, 11),
    (5, 7, 11), (2, 7, 12), (2, 5, 9), (4, 5, 12), (4, 9, 11),
    (8, 9, 12),
)
STEINER_CYCLIC = tuple(
    sorted((a + shift) % 13 for a in base)
    for base in ((0, 1, 4), (0, 2, 7))
    for shift in range(13)
)


def check_latin(square: tuple[tuple[int, ...], ...]) -> None:
    target = set(range(5))
    assert all(set(row) == target for row in square)
    assert all({square[r][c] for r in range(5)} == target for c in range(5))


def intercalates(square: tuple[tuple[int, ...], ...]) -> int:
    return sum(
        square[r][c] == square[rr][cc] and square[r][cc] == square[rr][c]
        for r, rr in combinations(range(5), 2)
        for c, cc in combinations(range(5), 2)
    )


def check_steiner(blocks: tuple[tuple[int, ...], ...]) -> None:
    assert len(blocks) == 26
    degrees = Counter(
        tuple(sorted(pair)) for block in blocks for pair in combinations(block, 2)
    )
    assert degrees == Counter({pair: 1 for pair in combinations(range(13), 2)})


def pasches(blocks: tuple[tuple[int, ...], ...]) -> int:
    answer = 0
    for chosen in combinations(blocks, 4):
        union = set().union(*(set(block) for block in chosen))
        if len(union) == 6 and all(sum(v in block for block in chosen) == 2 for v in union):
            answer += 1
    return answer


def latin_adjacency(square: tuple[tuple[int, ...], ...]) -> list[list[bool]]:
    adjacency = [[False] * ORDER for _ in range(ORDER)]
    for r, c in ((r, c) for r in range(5) for c in range(5)):
        u = 5 * r + c
        for rr, cc in ((rr, cc) for rr in range(5) for cc in range(5)):
            v = 5 * rr + cc
            adjacency[u][v] = u != v and (
                r == rr or c == cc or square[r][c] == square[rr][cc]
            )
    return adjacency


def steiner_adjacency(blocks: tuple[tuple[int, ...], ...]) -> list[list[bool]]:
    sets = [set(block) for block in blocks]
    return [
        [i != j and bool(sets[i] & sets[j]) for j in range(ORDER)]
        for i in range(ORDER)
    ]


def check_conference(adjacency: list[list[bool]]) -> None:
    seidel = [
        [0 if i == j else (-1 if adjacency[i][j] else 1) for j in range(ORDER)]
        for i in range(ORDER)
    ]
    for i in range(ORDER):
        for j in range(ORDER):
            value = sum(seidel[i][k] * seidel[k][j] for k in range(ORDER))
            assert value == (25 if i == j else 0)


def aligned_blocks(adjacency: list[list[bool]]) -> set[int]:
    answer: set[int] = set()
    triple_degrees: Counter[int] = Counter()
    for vertices in combinations(range(ORDER), 4):
        signs = {
            adjacency[a][b] ^ adjacency[a][c] ^ adjacency[b][c]
            for a, b, c in combinations(vertices, 3)
        }
        if len(signs) == 1:
            mask = sum(1 << v for v in vertices)
            answer.add(mask)
            for triple in combinations(vertices, 3):
                triple_degrees[sum(1 << v for v in triple)] += 1
    assert len(answer) == 3250
    assert len(triple_degrees) == math.comb(ORDER, 3)
    assert set(triple_degrees.values()) == {5}
    return answer


def pair_profile(blocks: set[int]) -> dict[int, int]:
    answer: Counter[int] = Counter()
    ordered = sorted(blocks)
    for i, first in enumerate(ordered):
        for second in ordered[i + 1 :]:
            answer[(first | second).bit_count()] += 1
    return dict(sorted(answer.items()))


def local_counts(blocks: set[int], split_root: bool) -> tuple[dict[str, dict[str, int]], dict[str, int]]:
    five: dict[str, Counter[int]] = {"all": Counter()}
    six = Counter()
    if split_root:
        five.update({"without_root": Counter(), "with_root": Counter()})
    for vertices in combinations(range(ORDER), 5):
        count = sum(
            sum(1 << v for v in four) in blocks for four in combinations(vertices, 4)
        )
        five["all"][count] += 1
        if split_root:
            five["with_root" if ROOT in vertices else "without_root"][count] += 1
    x6 = 0
    x6_without_root = 0
    x6_with_root = 0
    for vertices in combinations(range(ORDER), 6):
        inside = [
            sum(1 << v for v in four)
            for four in combinations(vertices, 4)
            if sum(1 << v for v in four) in blocks
        ]
        spanning = sum(
            (first | second | third).bit_count() == 6
            for first, second, third in combinations(inside, 3)
        )
        six[(len(inside), spanning)] += 1
        x6 += spanning
        if split_root:
            if ROOT in vertices:
                x6_with_root += spanning
            else:
                x6_without_root += spanning
    x5 = 10 * five["all"][5]
    five_json = {
        key: {str(count): multiplicity for count, multiplicity in sorted(hist.items())}
        for key, hist in five.items()
    }
    six_summary = {"total": x6}
    if split_root:
        six_summary.update(
            {"without_root": x6_without_root, "with_root": x6_with_root}
        )
    assert x5 == sum(
        math.comb(count, 3) * multiplicity
        for count, multiplicity in five["all"].items()
    )
    assert x6 == sum(spanning * multiplicity for (_, spanning), multiplicity in six.items())
    return five_json, six_summary


def inclusion_probability(size: int) -> Fraction:
    return Fraction(math.comb(ORDER - size, 13 - size), math.comb(ORDER, 13))


def profile_from_pivots(x5: int, x6: int) -> dict[int, int]:
    return {
        size: constant + coefficient5 * x5 + coefficient6 * x6
        for size, (constant, coefficient5, coefficient6) in PROFILE_AFFINE.items()
    }


def third_centered(profile: dict[int, int]) -> Fraction:
    mean = Fraction(3250) * inclusion_probability(4)
    factorial_two = sum(
        2 * count * inclusion_probability(size) for size, count in PAIR_PROFILE.items()
    )
    factorial_three = sum(
        6 * count * inclusion_probability(size) for size, count in profile.items()
    )
    raw_two = factorial_two + mean
    raw_three = factorial_three + 3 * factorial_two + mean
    return raw_three - 3 * mean * raw_two + 2 * mean**3


def record_latin(name: str, square: tuple[tuple[int, ...], ...]) -> dict[str, object]:
    check_latin(square)
    exceptional = intercalates(square)
    adjacency = latin_adjacency(square)
    check_conference(adjacency)
    blocks = aligned_blocks(adjacency)
    assert pair_profile(blocks) == PAIR_PROFILE
    five, six = local_counts(blocks, split_root=True)
    x5 = 10 * five["all"]["5"]
    x6 = six["total"]
    assert x5 == 7800 - 40 * exceptional
    assert x6 == 705250 - 896 * exceptional
    profile = profile_from_pivots(x5, x6)
    return {
        "name": name,
        "construction": "TD(3,5)",
        "intercalates": exceptional,
        "five_set_aligned_block_histogram": five,
        "six_set_spanning_triples": six,
        "x5": x5,
        "x6": x6,
        "third_centered_moment": str(third_centered(profile)),
    }


def record_steiner(name: str, system: tuple[tuple[int, ...], ...]) -> dict[str, object]:
    check_steiner(system)
    exceptional = pasches(system)
    adjacency = steiner_adjacency(system)
    check_conference(adjacency)
    blocks = aligned_blocks(adjacency)
    assert pair_profile(blocks) == PAIR_PROFILE
    five, six = local_counts(blocks, split_root=False)
    x5 = 10 * five["all"]["5"]
    x6 = six["total"]
    assert x5 == 8840 + 40 * exceptional
    assert x6 == 686322 - 504 * exceptional
    profile = profile_from_pivots(x5, x6)
    return {
        "name": name,
        "construction": "S(2,3,13)",
        "pasch_configurations": exceptional,
        "five_set_aligned_block_histogram": five,
        "six_set_spanning_triples": six,
        "x5": x5,
        "x6": x6,
        "third_centered_moment": str(third_centered(profile)),
    }


def generate() -> dict[str, object]:
    records = [
        record_latin("latin_non_group", LATIN_NON_GROUP),
        record_latin("latin_cyclic", LATIN_CYCLIC),
        record_steiner("steiner_noncyclic", STEINER_NONCYCLIC),
        record_steiner("steiner_cyclic", STEINER_CYCLIC),
    ]
    assert len({record["third_centered_moment"] for record in records}) == 4
    return {
        "schema": "c822-conference-moment-human-compression-v1",
        "order": ORDER,
        "aligned_design": "3-(26,4,5)",
        "pair_profile": {str(size): count for size, count in PAIR_PROFILE.items()},
        "profile_affine": {
            str(size): {
                "constant": constant,
                "x5": coefficient5,
                "x6": coefficient6,
            }
            for size, (constant, coefficient5, coefficient6) in PROFILE_AFFINE.items()
        },
        "representatives": records,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.write_text(json.dumps(generate(), indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
