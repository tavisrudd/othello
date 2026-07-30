#!/usr/bin/env python3
"""Independent direct replay of the C691 triangle-product identity."""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import combinations
from itertools import product as cartesian_product
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-29-c691-cubic-golden-two-graph.json"
C690 = ROOT / "notes" / "2026-07-29-c690-rigidity-fingerprints.json"
C682 = ROOT / "notes" / "2026-07-26-c682-transvectant-bridge.json"


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1) ** j
        * matrix[0][j]
        * determinant([row[:j] + row[j + 1 :] for row in matrix[1:]])
        for j in range(len(matrix))
    )


def rational_rank(matrix: list[list[int]]) -> int:
    rows = [[Fraction(value) for value in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column]), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        pivot_value = rows[rank][column]
        rows[rank] = [value / pivot_value for value in rows[rank]]
        for row in range(len(rows)):
            if row != rank and rows[row][column]:
                multiplier = rows[row][column]
                rows[row] = [
                    value - multiplier * reduced
                    for value, reduced in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", nargs="?", type=Path, default=CERTIFICATE)
    args = parser.parse_args()
    data = json.loads(args.certificate.read_text())
    if data["schema"] != "c691-cubic-golden-two-graph-v2":
        raise AssertionError("unexpected schema")
    c690 = json.loads(C690.read_text())
    c682 = json.loads(C682.read_text())
    comparison = c690["twelve_point_kill_test"]["paper_I"][
        "direct_c682_axis_lattice_comparison"
    ]
    matrix = comparison["continuation_signed_operator"]
    permutation = comparison["permutation_zero_based"]
    expected = {
        tuple(record["support"]): record["coefficient"]
        for record in c682["icosahedral_marking"]["support_orientation_cubic_terms"]
    }
    actual = {}
    for triple in combinations(range(6), 3):
        transported = tuple(sorted(permutation[i] for i in triple))
        actual[transported] = (
            matrix[triple[0]][triple[1]]
            * matrix[triple[1]][triple[2]]
            * matrix[triple[2]][triple[0]]
        )
    if actual != expected:
        raise AssertionError("triangle-product identity failed")

    gauge = [[0] * 6 for _ in range(6)]
    for i in range(1, 6):
        gauge[0][i] = gauge[i][0] = 1
    for i, j in combinations(range(1, 6), 2):
        gauge[i][j] = gauge[j][i] = (
            matrix[0][i] * matrix[i][j] * matrix[j][0]
        )
    for triple in combinations(range(6), 3):
        product = (
            gauge[triple[0]][triple[1]]
            * gauge[triple[1]][triple[2]]
            * gauge[triple[2]][triple[0]]
        )
        source = tuple(sorted(permutation[i] for i in triple))
        if product != expected[source]:
            raise AssertionError("inverse gauge reconstruction failed")
    if gauge != data["inverse_reconstruction"]["gauge_matrix"]:
        raise AssertionError("stored gauge matrix mismatch")
    distributions = {}
    for size in range(7):
        values = [
            determinant([[matrix[i][j] for j in subset] for i in subset])
            for subset in combinations(range(6), size)
        ]
        distributions[str(size)] = {
            str(value): values.count(value) for value in sorted(set(values))
        }
    if (
        distributions
        != data["determinantal_upgrade"]["principal_minor_distributions_by_size"]
    ):
        raise AssertionError("principal-minor distribution mismatch")
    pair_sums = {
        sum(
            expected[tuple(sorted((i, j, k)))]
            for k in range(6)
            if k not in (i, j)
        )
        for i, j in combinations(range(6), 2)
    }
    if pair_sums != {0}:
        raise AssertionError("signed pair moments do not vanish")
    free_edges = list(combinations(range(1, 6), 2))
    balanced = 0
    for bits in range(1 << len(free_edges)):
        candidate = [[0] * 6 for _ in range(6)]
        for i in range(1, 6):
            candidate[0][i] = candidate[i][0] = 1
        for bit, (i, j) in enumerate(free_edges):
            value = 1 if (bits >> bit) & 1 else -1
            candidate[i][j] = candidate[j][i] = value
        square = [
            [
                sum(candidate[i][k] * candidate[k][j] for k in range(6))
                for j in range(6)
            ]
            for i in range(6)
        ]
        balanced += square == [
            [5 * int(i == j) for j in range(6)] for i in range(6)
        ]
    if balanced != 12:
        raise AssertionError("balanced gauge census mismatch")

    gauge_signs = {
        triple: gauge[triple[0]][triple[1]]
        * gauge[triple[1]][triple[2]]
        * gauge[triple[2]][triple[0]]
        for triple in combinations(range(6), 3)
    }

    def gradient(point: list[int]) -> list[int]:
        result = [0] * 6
        for (i, j, k), sign in gauge_signs.items():
            result[i] += sign * point[j] * point[k]
            result[j] += sign * point[i] * point[k]
            result[k] += sign * point[i] * point[j]
        return result

    def hessian(point: list[int]) -> list[list[int]]:
        result = [[0] * 6 for _ in range(6)]
        for (i, j, k), sign in gauge_signs.items():
            for a, b, c in (
                (i, j, k),
                (j, i, k),
                (i, k, j),
                (k, i, j),
                (j, k, i),
                (k, j, i),
            ):
                result[a][b] += sign * point[c]
        return result

    nodes = [
        [-5 if coordinate == vertex else 1 for coordinate in range(6)]
        for vertex in range(6)
    ]
    if any(gradient(point) != [0] * 6 for point in nodes):
        raise AssertionError("displayed projective frame is not singular")
    if [rational_rank(hessian(point)) for point in nodes] != [4] * 6:
        raise AssertionError("a displayed singularity is not an ordinary node")

    finite_field_singular_counts = {}
    for prime in (7, 11):
        singular = 0
        for last_nonzero in range(5):
            for prefix in cartesian_product(range(prime), repeat=last_nonzero):
                point = [0, *prefix, 1, *([0] * (4 - last_nonzero))]
                singular += all(value % prime == 0 for value in gradient(point)[1:])
        finite_field_singular_counts[str(prime)] = singular
    if set(finite_field_singular_counts.values()) != {6}:
        raise AssertionError("finite-field singular-locus replay mismatch")

    print(
        json.dumps(
            {
                "triangle_coefficients_checked": len(actual),
                "forward_identity": True,
                "inverse_gauge_identity": True,
                "principal_minor_sizes_checked": 7,
                "signed_pair_moments": sorted(pair_sums),
                "balanced_gauge_solutions": balanced,
                "ordinary_nodes": len(nodes),
                "finite_field_singular_counts": finite_field_singular_counts,
                "full_projective_automorphism_group_order": data[
                    "projective_geometry_upgrade"
                ]["full_projective_automorphism_group_order"],
                "orbital_negation_degree": 3,
            },
            sort_keys=True,
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    main()
