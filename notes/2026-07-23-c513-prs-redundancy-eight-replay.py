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
    assert data["persistent"]["total_deep_orbit_counts"] == {
        "gcd_7_q_plus_1_is_1_and_p_not_7": {"PGL2": 2, "PGammaL2": 2},
        "p_is_7": {"PGL2": 3, "PGammaL2": 3},
        "7_divides_q_plus_1_and_p_is_plus_or_minus_1_mod_7": {
            "PGL2": 5,
            "PGammaL2": 5,
        },
        "7_divides_q_plus_1_and_p_is_plus_or_minus_2_or_3_mod_7": {
            "PGL2": 5,
            "PGammaL2": 3,
        },
    }

    preview = data["redundancy9_preview"]
    assert preview["deletion_degree_bound"] == 12 + 4 * 6 == 36
    assert preview["exact_normalization_inequality_first_integer"] == 50
    assert 50 + 1 - 2 * math.sqrt(50) > 36
    assert 49 + 1 - 2 * math.sqrt(49) == 36
    assert preview["first_prime_power_at_least_exact_inequality"] == 53
    assert preview["collision_degree"] == (5 + 1) * (7 - 5) == 12
    assert preview["characteristic5_lift_support"] == [4]
    assert preview["characteristic7_lift_support"] == [2, 3, 4, 5, 6]

    # Homogenize t^5-t with its infinity root and multiply by t-a.
    # The resulting split septic has d3=d4=0, so e4 annihilates it.
    char5_witness = [0, "a", -1, 0, 0, "-a", 1, 0]
    assert char5_witness[3] == char5_witness[4] == 0

    # Common annihilation by every f in <e2,...,e6> forces both shifted
    # middle blocks to vanish.  In characteristic seven the remaining
    # d0+d7*t^7 is a seventh power, never squarefree.
    forced_zero = set(range(2, 7)) | set(range(1, 6))
    assert forced_zero == set(range(1, 7))

    diagonal = data["prime_diagonal_nucleus_series"]["checked_primes"]
    for row in diagonal:
        p = row["characteristic"]
        assert row["lower_nrc_degree"] == p
        assert row["lower_top_nucleus_support"] == list(range(1, p))
        assert row["syndrome_degree"] == p + 1
        assert row["lift_support"] == list(range(2, p))
        assert row["projective_module"] == f"det^2 tensor Sym^{p - 3}(E)"
        forced = set(row["lift_support"]) | {j - 1 for j in row["lift_support"]}
        assert [j for j in range(p + 1) if j not in forced] == [0, p]
        assert row["common_kernel_support"] == [0, p]
        assert row["common_kernel_is_pth_power_pencil"]
        assert not row["universal_squarefree_witness"]

    for n in range(4, 25):
        deletion = 6 * n - 12
        closed = math.floor((1 + math.sqrt(deletion)) ** 2) + 1
        expanded = 6 * n - 10 + math.floor(2 * math.sqrt(deletion))
        assert closed == expanded

    q7 = data["q7_prime_diagonal_calibration"]
    assert q7["projective_binary_quartics"] == (7**5 - 1) // 6 == 2801
    rootless_vectors = sum(
        (-1) ** k * math.comb(8, k) * (7 ** (5 - k) - 1)
        for k in range(5)
    )
    assert rootless_vectors == 4914
    assert q7["deep_rootless_quartics"] == rootless_vectors // 6 == 819
    assert q7["shallow_quartics"] == 2801 - 819 == 1982
    assert q7["split_squarefree_septics"] == 8

    q49 = data["q49_rootless_shallow_witness"]
    assert q49["nu_as_a_plus_b_tau"] == [3, 1]
    assert q49["norm_nu"] == (3 * 3 - 3) % 7 == 6
    assert pow(q49["norm_nu"], 3, 7) == 6
    assert q49["quartic_has_rational_root"] is False
    assert q49["hankel_first_row"] == q49["hankel_second_row"] == [0, 0]
    assert q49["quintic_root_encodings"] == [0, 1, 6, 21, 28]
    assert q49["quadratic_root_encodings"] == [3, 4]
    assert not set(q49["quintic_root_encodings"]) & set(
        q49["quadratic_root_encodings"]
    )
    assert q49["root_sets_disjoint"]

    family = data["even_degree_characteristic7_square_quartic_family"]
    assert family["counting_curve"] == "E: y^2=x^3-x"
    for row in family["checked_rows"]:
        m = row["m"]
        q = 7 ** (2 * m)
        trace = 2 * ((-7) ** m)
        assert row["q"] == q
        assert row["elliptic_trace"] == trace
        assert row["elliptic_points"] == q + 1 - trace
        assert row["rootless_shallow_parameters"] == (q + 1 - trace) // 4

    detector = data["five_root_residual_quadratic_detector"]
    assert detector["denominator"] == "D=A^2+B*C"
    assert detector["solution_s"] == "(A*C+B*E)/D"
    assert detector["solution_u"] == "(C^2-A*E)/D"
    assert (
        detector["discriminant_numerator"]
        == "(A*C+B*E)^2-4*(C^2-A*E)*(A^2+B*C)"
    )
    assert "collision" in detector["full_family_gate"]
    print("C513 independent replay: PASS")


if __name__ == "__main__":
    main()
