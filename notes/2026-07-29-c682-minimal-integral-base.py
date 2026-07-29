#!/usr/bin/env python3
"""Exact arithmetic certificate for the C682 minimal integral base."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c682-minimal-integral-base.json"
INVERSE_CERTIFICATE = HERE / "2026-07-26-c682-transvectant-inverse.json"
BRIDGE_CERTIFICATE = HERE / "2026-07-28-c682-corrected-bridge-mod-1331.json"


def falling(n: int, r: int) -> int:
    if n < r:
        return 0
    return math.factorial(n) // math.factorial(n - r)


def factorization(value: int) -> dict[str, int]:
    value = abs(value)
    factors: dict[str, int] = {}
    prime = 2
    while prime * prime <= value:
        while value % prime == 0:
            factors[str(prime)] = factors.get(str(prime), 0) + 1
            value //= prime
        prime += 1
    if value > 1:
        factors[str(value)] = factors.get(str(value), 0) + 1
    return factors


def determinant(matrix: list[list[int]]) -> int:
    """Fraction-free Bareiss determinant."""
    if not matrix:
        return 1
    work = [row[:] for row in matrix]
    sign = 1
    previous = 1
    size = len(work)
    for column in range(size - 1):
        pivot = next(
            (row for row in range(column, size) if work[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        pivot_value = work[column][column]
        for row in range(column + 1, size):
            for target in range(column + 1, size):
                numerator = (
                    work[row][target] * pivot_value
                    - work[row][column] * work[column][target]
                )
                assert numerator % previous == 0
                work[row][target] = numerator // previous
        previous = pivot_value
    return sign * work[-1][-1]


def rank_modulo(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [(entry * inverse) % prime for entry in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (entry - scale * pivot_entry) % prime
                for entry, pivot_entry in zip(work[index], work[row])
            ]
        row += 1
    return row


def raw_third_matrix(dodecic: list[int]) -> list[list[int]]:
    matrix = [[0] * 7 for _ in range(13)]
    for output_y in range(13):
        for input_y in range(7):
            total = 0
            for index in range(4):
                dodecic_index = output_y - input_y + 3
                if not 0 <= dodecic_index <= 12:
                    continue
                total += (
                    (-1) ** index
                    * math.comb(3, index)
                    * falling(6 - input_y, 3 - index)
                    * falling(input_y, index)
                    * dodecic[dodecic_index]
                    * falling(12 - dodecic_index, index)
                    * falling(dodecic_index, 3 - index)
                )
            matrix[output_y][input_y] = total
    return matrix


def elementary_dodecic_tensor() -> tuple[list[list[list[int]]], list[int]]:
    # L_12^(11) has basis e_0,e_1,11e_2,...,11e_10,e_11,e_12.
    scales = [1, 1] + [11] * 9 + [1, 1]
    raw_directions = [
        raw_third_matrix(
            [scale if index == direction else 0 for index in range(13)]
        )
        for direction, scale in enumerate(scales)
    ]
    content = math.gcd(
        *(
            abs(entry)
            for matrix in raw_directions
            for row in matrix
            for entry in row
        )
    )
    assert content == 2640
    return (
        [
            [[entry // content for entry in row] for row in matrix]
            for matrix in raw_directions
        ],
        scales,
    )


def lattice_stability(scales: list[int]) -> dict[str, bool]:
    # Upper and lower unipotent coactions in the monomial basis.
    upper = all(
        (
            scales[source] * math.comb(12 - source, target - source)
        )
        % scales[target]
        == 0
        for source in range(13)
        for target in range(source, 13)
    )
    lower = all(
        (scales[source] * math.comb(source, target)) % scales[target] == 0
        for source in range(13)
        for target in range(source + 1)
    )
    assert upper and lower
    return {"upper_unipotent": upper, "lower_unipotent": lower}


def specialize(
    tensor: list[list[list[int]]],
    dodecic: list[int],
) -> list[list[int]]:
    return [
        [
            sum(
                dodecic[direction] * tensor[direction][output][column]
                for direction in range(13)
            )
            for column in range(7)
        ]
        for output in range(13)
    ]


def maximal_minor_gcd(matrix: list[list[int]], rank: int) -> int:
    divisor = 0
    for rows in itertools.combinations(range(len(matrix)), rank):
        for columns in itertools.combinations(range(len(matrix[0])), rank):
            minor = determinant(
                [[matrix[row][column] for column in columns] for row in rows]
            )
            divisor = math.gcd(divisor, abs(minor))
    return divisor


def all_larger_minors_vanish(matrix: list[list[int]], size: int) -> bool:
    return all(
        determinant(
            [[matrix[row][column] for column in columns] for row in rows]
        )
        == 0
        for rows in itertools.combinations(range(len(matrix)), size)
        for columns in itertools.combinations(range(len(matrix[0])), size)
    )


def annihilator_equations(
    tensor: list[list[list[int]]],
    plane: list[list[int]],
) -> list[list[int]]:
    return [
        [
            sum(
                tensor[direction][output][column] * vector[column]
                for column in range(7)
            )
            for direction in range(13)
        ]
        for vector in plane
        for output in range(13)
    ]


def apolar_data() -> dict[str, object]:
    # Divide the factorial apolar form by its content 12.
    weights = [
        (-1) ** index
        * math.factorial(index)
        * math.factorial(6 - index)
        // 12
        for index in range(7)
    ]
    determinant_value = math.prod(abs(weight) for weight in weights)
    ranks = {
        str(prime): sum(weight % prime != 0 for weight in weights)
        for prime in [2, 3, 5, 7, 11, 23]
    }
    # For q=XY, q^2 Sym^2 uses coordinates 2,3,4.  In characteristic
    # three the middle apolar equation vanishes, so its orthogonal has
    # dimension five rather than four.
    tangent_orthogonal_dimensions = {
        str(prime): 7
        - sum(weights[index] % prime != 0 for index in [2, 3, 4])
        for prime in [3, 7]
    }
    assert weights == [60, -10, 4, -3, 4, -10, 60]
    assert determinant_value == 17280000
    assert ranks == {"2": 1, "3": 4, "5": 3, "7": 7, "11": 7, "23": 7}
    assert tangent_orthogonal_dimensions == {"3": 5, "7": 4}
    return {
        "primitive_antidiagonal_weights": weights,
        "determinant": determinant_value,
        "determinant_factorization": factorization(determinant_value),
        "modular_ranks": ranks,
        "xy_tangent_orthogonal_dimensions": tangent_orthogonal_dimensions,
    }


def cross_gram_data() -> dict[str, object]:
    denominator = 820125
    center = 54781
    half_difference = 24288
    norm_numerator = center * center - 5 * half_difference * half_difference
    polynomial_discriminant = (
        20 * denominator * denominator * half_difference * half_difference
    )
    separator_collision_primes = sorted(
        set(factorization(2 * half_difference))
        - {"2", "3", "5"},
        key=int,
    )
    assert separator_collision_primes == ["11", "23"]
    assert factorization(denominator) == {"3": 8, "5": 3}
    assert factorization(norm_numerator) == {"71": 2, "101": 2}
    return {
        "relation": "(820125*x-54781)^2=5*24288^2",
        "denominator": denominator,
        "denominator_factorization": factorization(denominator),
        "center": center,
        "center_factorization": factorization(center),
        "half_difference": half_difference,
        "half_difference_factorization": factorization(half_difference),
        "norm_numerator": norm_numerator,
        "norm_numerator_factorization": factorization(norm_numerator),
        "quadratic_polynomial_discriminant": polynomial_discriminant,
        "quadratic_polynomial_discriminant_factorization": factorization(
            polynomial_discriminant
        ),
        "collisions_after_inverting_30": separator_collision_primes,
        "zero_value_primes_not_discriminant_primes": [71, 101],
        "golden_cover_discriminant": 20,
    }


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def certificate() -> dict[str, object]:
    tensor, scales = elementary_dodecic_tensor()
    representatives = [
        {
            "name": "open_icosahedral",
            "dodecic_in_elementary_basis": [0, 1]
            + [0] * 4
            + [1]
            + [0] * 4
            + [-1, 0],
            "kernel_plane": [
                [0, 0, 0, 1, 0, 0, 0],
                [1, 0, 0, 0, 0, 3, 0],
                [0, 3, 0, 0, 0, 0, -1],
            ],
        },
        {
            "name": "divisor_boundary",
            "dodecic_in_elementary_basis": [0, 1] + [0] * 11,
            "kernel_plane": [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0],
            ],
        },
        {
            "name": "closed_boundary",
            "dodecic_in_elementary_basis": [1] + [0] * 12,
            "kernel_plane": [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0, 0, 0],
            ],
        },
    ]
    forward_rows = []
    annihilator_rows = []
    audit_primes = [2, 3, 5, 7, 11, 13, 23]
    for representative in representatives:
        matrix = specialize(
            tensor,
            representative["dodecic_in_elementary_basis"],
        )
        minor_gcd = maximal_minor_gcd(matrix, 4)
        assert all_larger_minors_vanish(matrix, 5)
        equations = annihilator_equations(
            tensor,
            representative["kernel_plane"],
        )
        forward_rows.append(
            {
                "name": representative["name"],
                "rank_four_minor_gcd": minor_gcd,
                "rank_four_minor_gcd_factorization": factorization(minor_gcd),
                "all_rank_five_minors_zero": True,
                "modular_ranks": {
                    str(prime): rank_modulo(matrix, prime)
                    for prime in audit_primes
                },
            }
        )
        annihilator_rows.append(
            {
                "name": representative["name"],
                "characteristic_zero_rank": 12,
                "modular_ranks": {
                    str(prime): rank_modulo(equations, prime)
                    for prime in audit_primes
                },
            }
        )
    assert [row["rank_four_minor_gcd"] for row in forward_rows] == [
        25,
        5400,
        64800,
    ]
    assert all(
        row["modular_ranks"][str(prime)] == 4
        for row in forward_rows
        for prime in [7, 11, 13, 23]
    )
    assert [row["modular_ranks"]["7"] for row in annihilator_rows] == [
        12,
        11,
        11,
    ]
    with BRIDGE_CERTIFICATE.open(encoding="utf-8") as source:
        bridge = json.load(source)
    assert bridge["prime"] == 11
    assert bridge["operator_rank_mod_11"] == 4
    assert bridge["operator_flat_rank_through_mod_121"]
    return {
        "schema": "c682-minimal-integral-base-v1",
        "bases": {
            "mukai_umemura_geometry": "Z[1/10]",
            "operator_polar_normalized_incidence": "Z[1/30]",
            "literal_cross_gram_scalar_separator": "Z[1/7590]",
        },
        "bad_primes": {
            "structural_for_combined_normalized_package": [2, 3, 5],
            "cross_gram_scalar_collisions_not_bad_for_normalization": [11, 23],
            "presentation_artifact_not_bad": [7],
        },
        "elementary_dodecic_lattice": {
            "basis_scales_against_monomials": scales,
            "description": "e0,e1,11e2,...,11e10,e11,e12",
            "sl2_stability": lattice_stability(scales),
            "primitive_tensor_content_before_division": 2640,
            "open_klein_coordinates": [0, 1]
            + [0] * 4
            + [1]
            + [0] * 4
            + [-1, 0],
        },
        "forward_operator_orbit_rows": forward_rows,
        "raw_annihilator_equation_rows": annihilator_rows,
        "apolar_polarity": apolar_data(),
        "cross_gram": cross_gram_data(),
        "prior_certificate_checks": {
            "transvectant_inverse_json_sha256": sha256(INVERSE_CERTIFICATE),
            "corrected_bridge_json_sha256": sha256(BRIDGE_CERTIFICATE),
            "corrected_bridge_prime": bridge["prime"],
            "corrected_bridge_rank_mod_11": bridge["operator_rank_mod_11"],
            "corrected_bridge_flat_through_mod_121": bridge[
                "operator_flat_rank_through_mod_121"
            ],
        },
        "trust_boundary": [
            "The exact computation proves lattice stability, primitive integrality, orbit-representative determinantal ranks, apolar degeneracy, and separator collision primes.",
            "The Z[1/10] Mukai-Umemura model and nonexistence in characteristics 2 and 5 are imported from Ito-Kanemitsu-Takamatsu-Tanaka, Lemma 5.4 and Theorem 5.2.",
            "Flat closure or normalization, rather than the kernel of the reduced annihilator matrix, selects the boundary inverse line in characteristic 7.",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 minimal integral base certificate")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
