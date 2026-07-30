#!/usr/bin/env python3
"""Generate the C691 cubic/golden two-graph compatibility certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
C690 = ROOT / "notes" / "2026-07-29-c690-rigidity-fingerprints.json"
C682 = ROOT / "notes" / "2026-07-26-c682-transvectant-bridge.json"
OUTPUT = ROOT / "notes" / "2026-07-29-c691-cubic-golden-two-graph.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matrix_product(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant(
            [
                row[:column] + row[column + 1 :]
                for row in matrix[1:]
            ]
        )
        for column in range(len(matrix))
    )


def triangle_signs(matrix: list[list[int]]) -> dict[tuple[int, int, int], int]:
    return {
        triple: matrix[triple[0]][triple[1]]
        * matrix[triple[1]][triple[2]]
        * matrix[triple[2]][triple[0]]
        for triple in itertools.combinations(range(len(matrix)), 3)
    }


def permute_triple(
    permutation: tuple[int, ...], triple: tuple[int, int, int]
) -> tuple[int, int, int]:
    return tuple(sorted(permutation[i] for i in triple))


def rank_mod_two(matrix: list[list[int]]) -> int:
    rows = [
        sum((entry % 2) << column for column, entry in enumerate(row))
        for row in matrix
    ]
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next((i for i in range(rank, len(rows)) if (rows[i] >> column) & 1), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(len(rows)):
            if i != rank and (rows[i] >> column) & 1:
                rows[i] ^= rows[rank]
        rank += 1
    return rank


def build() -> dict[str, object]:
    c690 = json.loads(C690.read_text())
    c682 = json.loads(C682.read_text())
    comparison = c690["twelve_point_kill_test"]["paper_I"][
        "direct_c682_axis_lattice_comparison"
    ]
    conference = comparison["c682_conference_matrix"]
    continuation = comparison["continuation_signed_operator"]
    permutation = comparison["permutation_zero_based"]
    axis_signs = comparison["axis_signs"]
    n = 6

    assert all(
        continuation[i][j]
        == axis_signs[i]
        * axis_signs[j]
        * conference[permutation[i]][permutation[j]]
        for i in range(n)
        for j in range(n)
    )
    assert all(continuation[i][i] == 0 for i in range(n))
    assert all(
        continuation[i][j] == continuation[j][i]
        and (i == j or continuation[i][j] in (-1, 1))
        for i in range(n)
        for j in range(n)
    )
    square = matrix_product(continuation, continuation)
    assert square == [[5 * int(i == j) for j in range(n)] for i in range(n)]

    support_terms = c682["icosahedral_marking"]["support_orientation_cubic_terms"]
    support_sign = {
        tuple(record["support"]): record["coefficient"] for record in support_terms
    }
    assert len(support_sign) == 20 and set(support_sign.values()) == {-1, 1}

    continuation_triangle = triangle_signs(continuation)
    transported_triangle = {
        tuple(sorted(permutation[i] for i in triple)): sign
        for triple, sign in continuation_triangle.items()
    }
    assert transported_triangle == support_sign

    complement_checks = {
        triple: support_sign[triple]
        == -support_sign[tuple(i for i in range(n) if i not in triple)]
        for triple in support_sign
    }
    assert all(complement_checks.values())
    four_point_cocycle = {
        quadruple: tuple(
            support_sign[tuple(sorted(triple))]
            for triple in itertools.combinations(quadruple, 3)
        )
        for quadruple in itertools.combinations(range(n), 4)
    }
    assert all(
        product[0] * product[1] * product[2] * product[3] == 1
        for product in four_point_cocycle.values()
    )

    # Gauge reconstruction: set every edge from vertex zero to +1.  The
    # remaining edge signs are then exactly the triangle signs through zero.
    gauge = [[0] * n for _ in range(n)]
    for i in range(1, n):
        gauge[0][i] = gauge[i][0] = 1
    for i in range(1, n):
        for j in range(i + 1, n):
            value = continuation_triangle[(0, i, j)]
            gauge[i][j] = gauge[j][i] = value
    switching = [1] + [continuation[0][i] for i in range(1, n)]
    assert all(
        gauge[i][j] == switching[i] * switching[j] * continuation[i][j]
        for i in range(n)
        for j in range(n)
    )
    assert triangle_signs(gauge) == continuation_triangle

    permutations = tuple(itertools.permutations(range(n)))
    oriented_automorphisms = []
    line_automorphisms = []
    sign_character: dict[tuple[int, ...], int] = {}
    for candidate in permutations:
        ratios = {
            support_sign[permute_triple(candidate, triple)] * sign
            for triple, sign in support_sign.items()
        }
        if len(ratios) != 1:
            continue
        character = next(iter(ratios))
        line_automorphisms.append(candidate)
        sign_character[candidate] = character
        if character == 1:
            oriented_automorphisms.append(candidate)
    assert len(oriented_automorphisms) == 60
    assert len(line_automorphisms) == 120
    assert sum(value == -1 for value in sign_character.values()) == 60

    orbit = {
        permute_triple(candidate, (0, 1, 2))
        for candidate in oriented_automorphisms
    }
    assert len(orbit) == 10
    assert orbit in (
        {triple for triple, sign in support_sign.items() if sign == 1},
        {triple for triple, sign in support_sign.items() if sign == -1},
    )

    negated = [[-entry for entry in row] for row in continuation]
    assert triangle_signs(negated) == {
        triple: -sign for triple, sign in continuation_triangle.items()
    }

    principal_minor_distributions = {}
    for size in range(n + 1):
        values = [
            determinant(
                [[continuation[i][j] for j in subset] for i in subset]
            )
            for subset in itertools.combinations(range(n), size)
        ]
        principal_minor_distributions[str(size)] = {
            str(value): values.count(value) for value in sorted(set(values))
        }
    assert principal_minor_distributions == {
        "0": {"1": 1},
        "1": {"0": 6},
        "2": {"-1": 15},
        "3": {"-2": 10, "2": 10},
        "4": {"5": 15},
        "5": {"0": 6},
        "6": {"-125": 1},
    }
    assert all(
        determinant(
            [[continuation[i][j] for j in triple] for i in triple]
        )
        == 2 * continuation_triangle[triple]
        for triple in itertools.combinations(range(n), 3)
    )

    pair_sums = {
        (i, j): sum(
            support_sign[tuple(sorted((i, j, k)))]
            for k in range(n)
            if k not in (i, j)
        )
        for i, j in itertools.combinations(range(n), 2)
    }
    vertex_sums = {
        i: sum(
            support_sign[tuple(sorted((i, j, k)))]
            for j, k in itertools.combinations(
                [vertex for vertex in range(n) if vertex != i], 2
            )
        )
        for i in range(n)
    }
    total_sum = sum(support_sign.values())
    assert set(pair_sums.values()) == {0}
    assert set(vertex_sums.values()) == {0}
    assert total_sum == 0

    reduction = [[entry % 2 for entry in row] for row in continuation]
    nilpotent = [
        [(reduction[i][j] + int(i == j)) % 2 for j in range(n)]
        for i in range(n)
    ]
    nilpotent_square = matrix_product(nilpotent, nilpotent)
    assert all(entry % 2 == 0 for row in nilpotent_square for entry in row)
    assert rank_mod_two(nilpotent) == 1
    assert {coefficient % 2 for coefficient in support_sign.values()} == {1}
    mod_two_cubic_automorphisms = len(permutations)

    return {
        "schema": "c691-cubic-golden-two-graph-v1",
        "inputs": [
            {
                "path": str(path.relative_to(ROOT)),
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (C690, C682)
        ],
        "representation_comparison": {
            "oriented_cubic_automorphism_group_order": len(oriented_automorphisms),
            "cubic_line_automorphism_group_order": len(line_automorphisms),
            "outer_sign_fibre_sizes": {
                "+1": sum(value == 1 for value in sign_character.values()),
                "-1": sum(value == -1 for value in sign_character.values()),
            },
            "oriented_triple_orbit_sizes": [10, 10],
            "interpretation": "A5 kernel inside the outer S5 normalizer",
        },
        "coordinate_replay": {
            "continuation_signed_operator": continuation,
            "continuation_square": "B^2=5I",
            "axis_permutation_zero_based": permutation,
            "axis_switching_signs": axis_signs,
            "support_triangle_signs": [
                {"support": list(triple), "coefficient": support_sign[triple]}
                for triple in sorted(support_sign)
            ],
            "triangle_product_identity": (
                "c_ijk=B_ij*B_jk*B_ki after the displayed axis permutation"
            ),
            "all_twenty_coefficients_match": transported_triangle == support_sign,
            "complement_negates": all(complement_checks.values()),
            "four_point_two_graph_products": sorted(
                {
                    product[0] * product[1] * product[2] * product[3]
                    for product in four_point_cocycle.values()
                }
            ),
        },
        "inverse_reconstruction": {
            "gauge": "B_0i=1; B_ij=c_0ij for 0<i<j",
            "gauge_matrix": gauge,
            "switching_from_continuation_matrix": switching,
            "reconstructed_up_to_axis_switching": True,
        },
        "torsor_compatibility": {
            "orbital_exchange": "B maps to -B",
            "cubic_exchange": "c maps to -c",
            "map": "B maps to (B_ij*B_jk*B_ki)_{i<j<k}",
            "inverse": "the two-graph signs reconstruct the switching class of B",
            "verdict": "canonical compatibility",
        },
        "determinantal_upgrade": {
            "principal_minor_distributions_by_size": principal_minor_distributions,
            "three_by_three_minor": "det(B_{ijk})=2*c_ijk",
            "diagonal_pencil_identity": (
                "det(B+diag(x))=e6(x)-e4(x)+5*e2(x)-125-2*C_B(x)"
            ),
            "homogenized_identity": (
                "F_B(x,z)=det(z*B+diag(x))="
                "e6-z^2*e4+5*z^4*e2-125*z^6-2*z^3*C_B"
            ),
            "golden_conjugation_odd_part": (
                "F_B(x,z)-F_B(x,-z)=-4*z^3*C_B(x)"
            ),
            "complementary_minor_mechanism": (
                "Jacobi identity with det(B)=-125 and B^{-1}=B/5"
            ),
            "sole_nonsymmetric_term": "-2*C_B(x)",
        },
        "moment_upgrade": {
            "pair_sums": sorted(set(pair_sums.values())),
            "vertex_sums": sorted(set(vertex_sums.values())),
            "total_sum": total_sum,
            "derivation": (
                "sum_k c_ijk=B_ij*(B^2)_ij=0 for i!=j; "
                "lower sums follow"
            ),
            "translation_identity": "C_B(x+t*1)=C_B(x)",
            "natural_module": "Q^6/Q*1, equivalently the augmentation five-space",
            "first_nonzero_signed_moment_degree": 3,
        },
        "mod_2_closeout": {
            "triangle_coefficients": [1],
            "cubic_automorphism_group_order": mod_two_cubic_automorphisms,
            "symmetry_jump": "A5 to S6",
            "nilpotent": "N=B-I=B+I in characteristic 2",
            "nilpotent_rank": rank_mod_two(nilpotent),
            "nilpotent_square_zero": True,
            "interpretation": (
                "the cubic term -2*C_B vanishes in the diagonal determinant; "
                "orientation collapse is the cubic shadow of the "
                "Z[sqrt(5)] conductor-two defect"
            ),
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        raise SystemExit("choose exactly one of --write or --check")
    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")
    elif not OUTPUT.exists() or OUTPUT.read_bytes() != payload:
        raise SystemExit(f"stale certificate: {OUTPUT}")
    else:
        print("C691 cubic/golden two-graph: OK")


if __name__ == "__main__":
    main()
