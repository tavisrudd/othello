#!/usr/bin/env python3
"""Generate the C691 cubic/golden two-graph compatibility certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from fractions import Fraction
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


Polynomial = dict[tuple[int, ...], Fraction]


def polynomial_add(left: Polynomial, right: Polynomial) -> Polynomial:
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, Fraction(0)) + coefficient
        if result[monomial] == 0:
            del result[monomial]
    return result


def polynomial_scale(polynomial: Polynomial, scalar: Fraction) -> Polynomial:
    return {
        monomial: scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_monomial_multiply(
    polynomial: Polynomial, exponent: tuple[int, ...], scalar: Fraction
) -> Polynomial:
    return {
        tuple(a + b for a, b in zip(monomial, exponent)): scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_reduce(polynomial: Polynomial, basis: list[Polynomial]) -> Polynomial:
    remainder: Polynomial = {}
    work = dict(polynomial)
    while work:
        leading = max(work)
        coefficient = work[leading]
        divisor = next(
            (
                candidate
                for candidate in basis
                if all(a <= b for a, b in zip(max(candidate), leading))
            ),
            None,
        )
        if divisor is None:
            remainder[leading] = coefficient
            del work[leading]
            continue
        divisor_leading = max(divisor)
        exponent = tuple(a - b for a, b in zip(leading, divisor_leading))
        scalar = coefficient / divisor[divisor_leading]
        work = polynomial_add(
            work, polynomial_scale(polynomial_monomial_multiply(divisor, exponent, 1), -scalar)
        )
    return remainder


def reduced_groebner_basis(generators: list[Polynomial]) -> list[Polynomial]:
    basis = [polynomial_scale(g, 1 / g[max(g)]) for g in generators if g]
    basis = list({tuple(sorted(polynomial.items())): polynomial for polynomial in basis}.values())
    pairs = list(itertools.combinations(range(len(basis)), 2))
    while pairs:
        i, j = pairs.pop(0)
        left_leading = max(basis[i])
        right_leading = max(basis[j])
        lcm = tuple(max(a, b) for a, b in zip(left_leading, right_leading))
        left_multiplier = tuple(a - b for a, b in zip(lcm, left_leading))
        right_multiplier = tuple(a - b for a, b in zip(lcm, right_leading))
        s_polynomial = polynomial_add(
            polynomial_monomial_multiply(basis[i], left_multiplier, 1),
            polynomial_monomial_multiply(basis[j], right_multiplier, -1),
        )
        remainder = polynomial_reduce(s_polynomial, basis)
        if remainder:
            remainder = polynomial_scale(remainder, 1 / remainder[max(remainder)])
            if tuple(sorted(remainder.items())) in {
                tuple(sorted(polynomial.items())) for polynomial in basis
            }:
                continue
            new_index = len(basis)
            pairs.extend((old_index, new_index) for old_index in range(new_index))
            basis.append(remainder)
    reduced = []
    for i, polynomial in enumerate(basis):
        remainder = polynomial_reduce(
            polynomial, [candidate for j, candidate in enumerate(basis) if i != j]
        )
        if remainder:
            reduced.append(polynomial_scale(remainder, 1 / remainder[max(remainder)]))
    unique = {tuple(sorted(polynomial.items())): polynomial for polynomial in reduced}
    return sorted(unique.values(), key=lambda polynomial: max(polynomial), reverse=True)


def chart_gradient_polynomials(
    signs: dict[tuple[int, int, int], int], chart: int
) -> list[Polynomial]:
    """Gradient after x_0=0, later y's=0, and y_chart=1."""
    variables = chart
    result = []
    for derivative in range(1, 6):
        polynomial: Polynomial = {}
        for triple, sign in signs.items():
            if derivative not in triple or 0 in triple:
                continue
            factors = [vertex - 1 for vertex in triple if vertex != derivative]
            if any(factor > chart for factor in factors):
                continue
            exponent = [0] * variables
            for factor in factors:
                if factor < chart:
                    exponent[factor] += 1
            monomial = tuple(exponent)
            polynomial[monomial] = polynomial.get(monomial, Fraction(0)) + sign
        result.append({monomial: value for monomial, value in polynomial.items() if value})
    return result


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
        scale = rows[rank][column]
        rows[rank] = [value / scale for value in rows[rank]]
        for row in range(len(rows)):
            if row != rank and rows[row][column]:
                scale = rows[row][column]
                rows[row] = [
                    value - scale * pivot_value
                    for value, pivot_value in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank


def serialize_polynomial(polynomial: Polynomial) -> list[dict[str, object]]:
    return [
        {
            "exponents": list(monomial),
            "coefficient": (
                int(coefficient)
                if coefficient.denominator == 1
                else f"{coefficient.numerator}/{coefficient.denominator}"
            ),
        }
        for monomial, coefficient in sorted(polynomial.items(), reverse=True)
    ]


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


def gauge_key(matrix: list[list[int]]) -> tuple[int, ...]:
    return tuple(
        matrix[i][j]
        for i in range(len(matrix))
        for j in range(i + 1, len(matrix))
    )


def canonical_switching_key(matrix: list[list[int]]) -> tuple[int, ...]:
    n = len(matrix)
    keys = []
    for permutation in itertools.permutations(range(n)):
        permuted = [
            [matrix[permutation[i]][permutation[j]] for j in range(n)]
            for i in range(n)
        ]
        signs = [1] + [permuted[0][i] for i in range(1, n)]
        switched = [
            [signs[i] * signs[j] * permuted[i][j] for j in range(n)]
            for i in range(n)
        ]
        keys.append(gauge_key(switched))
    return min(keys)


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

    gauge_solutions = []
    free_edges = list(itertools.combinations(range(1, n), 2))
    for bits in range(1 << len(free_edges)):
        candidate = [[0] * n for _ in range(n)]
        for i in range(1, n):
            candidate[0][i] = candidate[i][0] = 1
        for bit, (i, j) in enumerate(free_edges):
            value = 1 if (bits >> bit) & 1 else -1
            candidate[i][j] = candidate[j][i] = value
        if matrix_product(candidate, candidate) == [
            [5 * int(i == j) for j in range(n)] for i in range(n)
        ]:
            gauge_solutions.append(candidate)
    assert len(gauge_solutions) == 12
    assert len({canonical_switching_key(matrix) for matrix in gauge_solutions}) == 1
    for candidate in gauge_solutions:
        positive_degrees = [
            sum(candidate[i][j] == 1 for j in range(1, n) if j != i)
            for i in range(1, n)
        ]
        assert positive_degrees == [2] * 5

    # Intrinsic projective geometry of the cubic on Q^6/Q*1.  The six
    # displayed representatives are the vertices of its projective frame.
    nodes = [
        [-5 if coordinate == vertex else 1 for coordinate in range(n)]
        for vertex in range(n)
    ]

    def cubic_value(point: list[int]) -> int:
        return sum(
            sign * point[i] * point[j] * point[k]
            for (i, j, k), sign in continuation_triangle.items()
        )

    def cubic_gradient(point: list[int]) -> list[int]:
        gradient = [0] * n
        for (i, j, k), sign in continuation_triangle.items():
            gradient[i] += sign * point[j] * point[k]
            gradient[j] += sign * point[i] * point[k]
            gradient[k] += sign * point[i] * point[j]
        return gradient

    def cubic_hessian(point: list[int]) -> list[list[int]]:
        hessian = [[0] * n for _ in range(n)]
        for (i, j, k), sign in continuation_triangle.items():
            hessian[i][j] += sign * point[k]
            hessian[j][i] += sign * point[k]
            hessian[i][k] += sign * point[j]
            hessian[k][i] += sign * point[j]
            hessian[j][k] += sign * point[i]
            hessian[k][j] += sign * point[i]
        return hessian

    assert all(sum(point) == 0 for point in nodes)
    assert all(cubic_value(point) == 0 for point in nodes)
    assert all(cubic_gradient(point) == [0] * n for point in nodes)
    hessian_ranks = [rational_rank(cubic_hessian(point)) for point in nodes]
    assert hessian_ranks == [4] * n

    # Cover projective four-space after translation gauge x_0=0 by the five
    # charts in which the last nonzero y-coordinate is one.  Exact Buchberger
    # reduction gives one coordinate point in each chart and, in the last
    # chart, the additional all-ones point.
    chart_bases = [
        reduced_groebner_basis(
            chart_gradient_polynomials(continuation_triangle, chart)
        )
        for chart in range(5)
    ]

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
        "schema": "c691-cubic-golden-two-graph-v2",
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
            "conference_equivalence": (
                "pair-sum vanishing iff B^2=5I after two-graph gauge reconstruction"
            ),
        },
        "uniqueness_upgrade": {
            "gauge": "B_0i=1",
            "free_edge_sign_assignments_checked": 1 << len(free_edges),
            "balanced_conference_solutions": len(gauge_solutions),
            "positive_graph_on_remaining_five_vertices": "a 5-cycle",
            "labelled_five_cycles": 12,
            "switching_isomorphism_classes": 1,
            "conclusion": (
                "the balanced oriented cubic forces the unique six-vertex "
                "conference two-graph and its golden operator"
            ),
        },
        "projective_geometry_upgrade": {
            "ambient": "P(Q^6/Q*1)=P^4",
            "singular_points_sum_zero_representatives": nodes,
            "singular_point_count": len(nodes),
            "singular_chart_reduced_groebner_bases": [
                [serialize_polynomial(polynomial) for polynomial in basis]
                for basis in chart_bases
            ],
            "chart_order": (
                "x_0=0; in chart r, y_r=1 and y_s=0 for s>r, "
                "with y_r=x_{r+1}"
            ),
            "hessian_ranks_on_Q6": hessian_ranks,
            "projective_singularity_type": "six ordinary double points",
            "full_projective_automorphism_group_order": len(line_automorphisms),
            "automorphism_argument": (
                "the complete singular locus is a projective frame, so every "
                "projective automorphism permutes it; the cubic-line "
                "stabilizer among those permutations has order 120"
            ),
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
