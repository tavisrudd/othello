#!/usr/bin/env python3
"""Independent replay for the C513 algebraic certificate."""

import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = HERE / "2026-07-23-c513-prs-redundancy-eight.json"


def rank_mod_p(rows, p):
    rows = [[x % p for x in row] for row in rows]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (i for i in range(rank, len(rows)) if rows[i][column] != 0),
            None,
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], -1, p)
        rows[rank] = [(inverse * x) % p for x in rows[rank]]
        for i in range(len(rows)):
            if i == rank or rows[i][column] == 0:
                continue
            scale = rows[i][column]
            rows[i] = [
                (x - scale * y) % p for x, y in zip(rows[i], rows[rank])
            ]
        rank += 1
    return rank


def contraction_kernel_dimension(support, p):
    rows = []
    support = set(support)
    for offset in (0, 1):
        for j in range(7):
            if j in support:
                continue
            row = [0] * 8
            row[offset + j] = 1
            rows.append(row)
    return 8 - rank_mod_p(rows, p)


def main():
    data = json.loads(DATA.read_text())
    assert data["schema"] == "c513-prs-redundancy-eight-v1"

    lower = data["lower_cover"]
    assert lower["total_deletion_degree"] == 12 + 3 * 6 == 30
    exact_bound = math.floor((1 + math.sqrt(31)) ** 2) + 1
    assert lower["c512_closed_integer_bound"] == exact_bound == 44
    assert lower["first_prime_power_at_least_c512_bound"] == 47
    assert lower["exact_normalization_inequality_first_integer"] == 42
    assert 42 + 1 - 2 * math.sqrt(42) > 30
    assert 41 + 1 - 2 * math.sqrt(41) <= 30
    assert lower["first_prime_power_at_least_exact_inequality"] == 43

    top = data["top_level"]
    assert top["collision_degree"] == 5 * (6 - 4) == 10
    assert top["total_transverse_collision_budget"] == 3 + 1 + 10 == 14

    rows = [
        [1 if i == j else 0 for i in range(8)]
        for j in (0, 1, 2, 4, 5, 6, 1, 2, 3, 5, 6, 7)
    ]
    assert 8 - rank_mod_p(rows, 2) == 0
    assert contraction_kernel_dimension([3], 2) == 0
    assert contraction_kernel_dimension([1, 2, 4, 5], 3) == 2
    assert contraction_kernel_dimension([2, 3, 4], 5) == 2

    modular = data["modular_disposition"]
    assert modular["characteristic3_lift_support"] == [2, 5]
    assert modular["characteristic5_lift_support"] == [3, 4]
    split = modular["characteristic5_universal_split_sextic_coefficients"]
    assert split == [0, -1, 0, 0, 0, 1, 0]
    assert all(split[i] == 0 for i in (2, 3, 4))

    # The characteristic-three witness uses pairs ±a, ±b, ±c on the reciprocal
    # root side.  A nonsingular conic has q+1 points; the nine forbidden
    # coordinate/equality lines contribute at most 18 points.
    assert modular["characteristic3_conic_bad_point_bound"] == 9 * 2
    assert 27 + 1 > modular["characteristic3_conic_bad_point_bound"]

    assert data["persistent"]["tangent_cocycle_coefficient"] == 7
    fusion = data["persistent"]["sigma_pgamma_fusion_when_7_divides_q_plus_1"]
    assert set(fusion) == {
        "p_congruent_to_plus_or_minus_1_mod_7",
        "p_otherwise",
    }
    expected_cycles = {
        str(p): [1, 1, 1] if p in (1, 6) else [3] for p in range(1, 7)
    }
    assert (
        data["persistent"]["sigma_nonzero_class_cycle_lengths_by_p_mod_7"]
        == expected_cycles
    )
    print("C513 independent replay: PASS")


if __name__ == "__main__":
    main()
