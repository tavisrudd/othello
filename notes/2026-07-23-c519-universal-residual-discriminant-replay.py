#!/usr/bin/env python3
"""Independent, SymPy-free replay for the C519 obstruction certificate."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-23-c519-universal-residual-discriminant.json"


def rank_mod2(matrix: list[list[int]]) -> int:
    rows = [sum((x & 1) << j for j, x in enumerate(row)) for row in matrix]
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next((i for i in range(rank, len(rows)) if rows[i] & (1 << column)), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for i in range(len(rows)):
            if i != rank and rows[i] & (1 << column):
                rows[i] ^= rows[rank]
        rank += 1
    return rank


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c519-universal-residual-discriminant-v1"

    for prime in (2, 3, 5, 7):
        for A in range(prime):
            for B in range(prime):
                for C in range(prime):
                    for D in range(prime):
                        determinant = B * D - C * C
                        ns = A * D - B * C
                        nu = A * C - B * B
                        residual = ns * ns - 4 * determinant * nu
                        assert A * determinant - B * ns + C * nu == 0
                        assert B * determinant - C * ns + D * nu == 0
                        integral = (
                            A * A * D * D
                            - 6 * A * B * C * D
                            - 3 * B * B * C * C
                            + 4 * A * C * C * C
                            + 4 * B * B * B * D
                        )
                        assert (residual - integral) % prime == 0
                        cubic_b = 3 * B
                        cubic_c = 3 * C
                        ordinary = (
                            cubic_b**2 * cubic_c**2
                            - 4 * A * cubic_c**3
                            - 4 * cubic_b**3 * D
                            - 27 * A**2 * D**2
                            + 18 * A * cubic_b * cubic_c * D
                        )
                        assert (ordinary + 27 * integral) % prime == 0
                        if prime == 2:
                            assert (integral - (A * D + B * C) ** 2) % 2 == 0
                        if prime == 3:
                            discr_a = (C * C - B * D) ** 3
                            assert discr_a % 3 == (C**6 - B**3 * D**3) % 3

    witnesses = data["characteristic_two"]["generic_outside_frozen_carriers"]
    specialization = data["characteristic_two"]["artin_schreier_nontrivial_specialization"]
    assert specialization["class"] == "1/A"
    assert [item["rank"] for item in witnesses] == [3, 4, 4, 4]
    for item in witnesses:
        assert rank_mod2(item["contraction_matrix_rows"]) == item["rank"]
        assert rank_mod2(item["middle_catalecticant_rows"]) == 3
        assert item["outside_frozen_char2_nucleus"]
        assert any(item["ns_upper_triangular_coefficients"])

    print("C519 replay OK: 4 prime fields, 4 generic carrier-separation witnesses")


if __name__ == "__main__":
    main()
