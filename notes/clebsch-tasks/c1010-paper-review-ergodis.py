#!/usr/bin/env python3
"""Exact q=13 one-bit reconstruction checks and bounded curve arithmetic."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path


Q = 13
RELATIONS = (0, 1, 3, 9, 10, 12)
OBSERVABLE_ATOMS = ((0,), (1, 3), (9,), (10,), (12,))


def projective_points(q: int) -> list[tuple[int, int, int]]:
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


def internal_points(q: int) -> list[tuple[int, int, int]]:
    squares = {value * value % q for value in range(1, q)}
    return [
        point
        for point in projective_points(q)
        if (point[1] * point[1] - point[0] * point[2]) % q
        not in squares | {0}
    ]


def rho(
    q: int,
    first: tuple[int, int, int],
    second: tuple[int, int, int],
) -> int:
    x, y, z = first
    u, v, w = second
    delta_first = (y * y - x * z) % q
    delta_second = (v * v - u * w) % q
    beta = (2 * y * v - x * w - z * u) % q
    return beta * beta * pow(delta_first * delta_second, -1, q) % q


def coherent_refinement(colors: list[list[int]]) -> list[list[int]]:
    size = len(colors)
    signatures = []
    for first in range(size):
        for second in range(size):
            counts = Counter(
                (colors[first][middle], colors[middle][second])
                for middle in range(size)
            )
            signatures.append(
                (colors[first][second], tuple(sorted(counts.items())))
            )
    labels = {
        signature: label
        for label, signature in enumerate(sorted(set(signatures)))
    }
    return [
        [labels[signatures[first * size + second]] for second in range(size)]
        for first in range(size)
    ]


def binary_rank(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for original in rows:
        row = original
        while row:
            pivot = row.bit_length() - 1
            if pivot in pivots:
                row ^= pivots[pivot]
            else:
                pivots[pivot] = row
                break
    return len(pivots)


def binary_multiply(first: list[int], second: list[int]) -> list[int]:
    result = []
    for support in first:
        row = 0
        while support:
            bit = support & -support
            row ^= second[bit.bit_length() - 1]
            support ^= bit
        result.append(row)
    return result


def relation_rows(
    points: list[tuple[int, int, int]], labels: set[int]
) -> list[int]:
    return [
        sum(
            1 << second
            for second in range(len(points))
            if first != second
            and rho(Q, points[first], points[second]) in labels
        )
        for first in range(len(points))
    ]


def q13_one_bit_certificate() -> dict[str, object]:
    points = internal_points(Q)
    assert len(points) == 78
    relation = [
        [
            -1 if first == second else rho(Q, points[first], points[second])
            for second in range(78)
        ]
        for first in range(78)
    ]

    parity_labels = {10, 12}
    parity = [
        [
            first != second and relation[first][second] in parity_labels
            for second in range(78)
        ]
        for first in range(78)
    ]
    signatures: dict[str, dict[str, object]] = {}
    seen = set()
    for label in RELATIONS:
        common = {
            sum(
                parity[first][middle] and parity[middle][second]
                for middle in range(78)
            )
            for first in range(78)
            for second in range(first)
            if relation[first][second] == label
        }
        assert len(common) == 1
        signature = (label in parity_labels, next(iter(common)))
        assert signature not in seen
        seen.add(signature)
        signatures[str(label)] = {
            "adjacent": signature[0],
            "common_neighbors": signature[1],
        }

    a_zero = relation_rows(points, {0})
    parity_rows = relation_rows(points, parity_labels)
    assert binary_rank(a_zero) == 42
    assert binary_rank(parity_rows) == 36
    assert binary_multiply(a_zero, parity_rows) == [0] * 78

    fusion_rows = []
    for mask in range(1, 16):
        selected_atoms = [
            atom for index, atom in enumerate(OBSERVABLE_ATOMS) if mask >> index & 1
        ]
        selected = {label for atom in selected_atoms for label in atom}
        colors = [
            [
                2
                if first == second
                else int(relation[first][second] in selected)
                for second in range(78)
            ]
            for first in range(78)
        ]
        color_counts = []
        for _ in range(4):
            color_counts.append(len({entry for row in colors for entry in row}))
            colors = coherent_refinement(colors)
        assert 7 in color_counts
        relation_colors = {
            label: {
                colors[first][second]
                for first in range(78)
                for second in range(first)
                if relation[first][second] == label
            }
            for label in RELATIONS
        }
        full = all(len(value) == 1 for value in relation_colors.values()) and len(
            {next(iter(value)) for value in relation_colors.values()}
        ) == 6
        assert full
        fusion_rows.append(
            {
                "canonical_mask": mask,
                "selected_concurrence_values": [
                    (8, 6, 12, 7, 9)[index]
                    for index in range(5)
                    if mask >> index & 1
                ],
                "color_counts_first_four_rounds": color_counts,
                "full_elliptic_scheme_recovered": full,
            }
        )

    return {
        "vertices": 78,
        "parity_graph_valency": 28,
        "parity_relation_labels": [10, 12],
        "parity_pair_signatures": signatures,
        "parity_graph_binary_rank": 36,
        "rho_zero_graph_binary_rank": 42,
        "rho_zero_times_parity_is_zero": True,
        "parity_graph_binary_image": "K=ker(A_0)",
        "observable_predicates_checked_up_to_complement": 15,
        "all_nonconstant_predicates_recover_full_scheme": True,
        "fusion_rows": fusion_rows,
    }


def beta(k: int) -> int:
    r = k // 2
    choose_two = k * (k - 1) // 2
    choose_four = k * (k - 1) * (k - 2) * (k - 3) // 24
    return choose_two - k + 6 * choose_four // r


def available_beta(k: int) -> int:
    """Use the sharp concurrence-spectrum constant at six points."""
    return 44 if k == 6 else beta(k)


def arithmetic_genus(degree: int) -> int:
    return (degree - 1) * (degree - 2) // 2


def floor_two_sqrt(q: int) -> int:
    value = 0
    while (value + 1) * (value + 1) <= 4 * q:
        value += 1
    return value


def irreducible_obstruction(k: int, degree: int, q: int) -> int:
    """Genus-free necessary-inequality left side."""
    return (
        q * q
        - (k * (k - 1) // 2) * q
        + available_beta(k)
        - arithmetic_genus(degree) * floor_two_sqrt(q)
    )


def curve_arithmetic_certificate() -> dict[str, object]:
    assert beta(6) == 39
    assert available_beta(6) == 44
    rows = []
    for degree in range(1, 11):
        admitted = [
            q
            for q in range(2, 1001)
            if irreducible_obstruction(6, degree, q) <= 0
        ]
        rows.append(
            {
                "degree": degree,
                "arithmetic_genus": arithmetic_genus(degree),
                "largest_integer_q_through_1000_not_excluded": max(admitted, default=None),
            }
        )
    assert irreducible_obstruction(6, 2, 11) <= 0
    assert irreducible_obstruction(6, 2, 12) > 0
    assert irreducible_obstruction(6, 3, 11) <= 0
    assert irreducible_obstruction(6, 3, 12) > 0
    assert all(
        irreducible_obstruction(6, degree, q) > 0
        for degree in (2, 3)
        for q in range(12, 1001)
    )
    return {
        "necessary_inequality_genus_free": (
            "q^2-N*q+beta_k-pi_d*floor(2*sqrt(q)) <= 0"
        ),
        "six_arc_sharp_beta": 44,
        "six_arc_degree_at_most_three_integer_cutoff": 11,
        "bounded_check_range": "2<=q<=1000, 1<=degree<=10",
        "degree_rows": rows,
    }


def compute() -> dict[str, object]:
    return {
        "schema": "c1010-paper-review-ergodis-v1",
        "q13_one_bit_reconstruction": q13_one_bit_certificate(),
        "irreducible_curve_envelope": curve_arithmetic_certificate(),
        "ergodis_control": {
            "presentation_hash": "e3c60f9c6afdeb89b1ae12a20dc572e1a52a5a08c42b609574f516daebdf7961",
            "power_generation_rows": 15,
            "ceiling_unavoidable_errors": 0,
            "evolve_candidates": 794,
            "evolve_perfect": 0,
            "evolve_best_correct": 10,
            "synthesize_error": (
                "plan result sort does not match its declared output"
            ),
        },
    }


def render(value: dict[str, object]) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    output = render(compute())
    if arguments.write:
        arguments.write.write_text(output, encoding="utf-8")
    elif arguments.check:
        assert arguments.check.read_text(encoding="utf-8") == output
        print("C1010 paper-review certificate: PASS")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
