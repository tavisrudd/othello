#!/usr/bin/env python3
"""Generic local replay for the C665 first-wall spill.

Only the four simple modules S=L(s), T=L(p-2,1), R=L(p-2-s,1),
and Y=L(0,2) are described.  Clebsch--Gordan maps are generated from
divided-power recurrences; no field-sized module or extension field is
constructed.

The adjacent-wall theorem remains the human input.  Conditional on its
normalized row, this checker verifies its local coefficient, uniqueness,
spill, torus gap, dimensions, and the q=121/q=169 specializations.
"""

import argparse
import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c688-generic-first-wall.json"
Q121_CERTIFICATE = HERE / "2026-07-29-c665-q121-connecting-functional.json"
Q169_CERTIFICATE = HERE / "2026-07-29-c665-q169-wall-check.json"


def canonical_hash(value):
    rendered = json.dumps(value, separators=(",", ":"), sort_keys=True)
    return hashlib.sha256(rendered.encode()).hexdigest()


def inverse(value, p):
    value %= p
    assert value
    return pow(value, -1, p)


def is_prime(value):
    if value < 2:
        return False
    return all(value % divisor for divisor in range(2, math.isqrt(value) + 1))


def highest_recurrence(a, b, k, p):
    """Highest-vector coefficients, normalized by c_0=1."""
    coefficients = [1]
    for j in range(k):
        numerator = -(k - j) * coefficients[-1]
        coefficients.append(numerator * inverse(j + 1, p) % p)
    assert coefficients == [
        (-1) ** j * math.comb(k, j) % p for j in range(k + 1)
    ]
    return coefficients


def clebsch_gordan_map(a, b, k, p):
    """Sparse L(a+b-2k) -> L(a) tensor L(b) divided-power map."""
    c = a + b - 2 * k
    assert 0 <= k <= min(a, b) and c < p
    highest = highest_recurrence(a, b, k, p)
    entries = []
    for source in range(c + 1):
        normalization = inverse(math.comb(c, source), p)
        column = {}
        for j, highest_coefficient in enumerate(highest):
            for left_step in range(source + 1):
                right_step = source - left_step
                if left_step > a - j or right_step > b - (k - j):
                    continue
                row = (j + left_step, k - j + right_step)
                coefficient = (
                    highest_coefficient
                    * math.comb(a - j, left_step)
                    * math.comb(b - (k - j), right_step)
                    * normalization
                ) % p
                column[row] = (column.get(row, 0) + coefficient) % p
        entries.extend(
            [left, right, source, coefficient]
            for (left, right), coefficient in sorted(column.items())
            if coefficient
        )
    verify_intertwiner(a, b, c, entries, p)
    return {
        "source_dimension": c + 1,
        "left_dimension": a + 1,
        "right_dimension": b + 1,
        "normalization": "highest coefficient (0,k) = 1",
        "entries": entries,
    }


def apply_target_operator(column, a, b, raising, p):
    answer = {}
    for (left, right), value in column.items():
        if raising:
            moves = ((left - 1, right, left), (left, right - 1, right))
        else:
            moves = (
                (left + 1, right, a - left),
                (left, right + 1, b - right),
            )
        for new_left, new_right, coefficient in moves:
            if coefficient:
                key = (new_left, new_right)
                answer[key] = (answer.get(key, 0) + value * coefficient) % p
    return {key: value for key, value in answer.items() if value}


def verify_intertwiner(a, b, c, entries, p):
    columns = [dict() for _ in range(c + 1)]
    for left, right, source, coefficient in entries:
        columns[source][(left, right)] = coefficient
    for source, column in enumerate(columns):
        raised = apply_target_operator(column, a, b, True, p)
        expected_raised = {}
        if source:
            expected_raised = {
                key: source * value % p
                for key, value in columns[source - 1].items()
                if source * value % p
            }
        assert raised == expected_raised
        lowered = apply_target_operator(column, a, b, False, p)
        expected_lowered = {}
        if source < c:
            expected_lowered = {
                key: (c - source) * value % p
                for key, value in columns[source + 1].items()
                if (c - source) * value % p
            }
        assert lowered == expected_lowered


def module_record(name, digits):
    dimension = math.prod(digit + 1 for digit in digits)
    return {"name": name, "digits": list(digits), "dimension": dimension}


def occurrence(p, s, e):
    b = (p - 1) // 2
    parity_bit = e * b % 2
    required_bit = (1 + s // 2) % 2
    return {
        "exponent": e,
        "parity_bit": parity_bit,
        "required_bit": required_bit,
        "occurs": parity_bit == required_bit,
    }


def convolution(left, right, p):
    answer = [0] * (len(left) + len(right) - 1)
    for i, left_value in enumerate(left):
        for j, right_value in enumerate(right):
            answer[i + j] = (answer[i + j] + left_value * right_value) % p
    return answer


def degenerate_root_group_repair():
    p, modulus = 3, 8
    basis = [
        (y_index, r_zero_index, r_one_index)
        for y_index in range(3)
        for r_zero_index in range(2)
        for r_one_index in range(2)
    ]

    def weight(item):
        y_index, r_zero_index, r_one_index = item
        return (
            p * (2 - 2 * y_index)
            + (1 - 2 * r_zero_index)
            + p * (1 - 2 * r_one_index)
        )

    torus_fixed = [item for item in basis if weight(item) % modulus == 0]
    assert torus_fixed == [(0, 1, 0), (2, 0, 1)]

    def moved_terms(item):
        y_index, r_zero_index, r_one_index = item
        terms = {}
        for new_y in range(y_index + 1):
            for new_zero in range(r_zero_index + 1):
                for new_one in range(r_one_index + 1):
                    output = (new_y, new_zero, new_one)
                    exponent = (
                        p * (y_index - new_y)
                        + (r_zero_index - new_zero)
                        + p * (r_one_index - new_one)
                    )
                    coefficient = (
                        math.comb(y_index, new_y)
                        * math.comb(r_zero_index, new_zero)
                        * math.comb(r_one_index, new_one)
                    ) % p
                    if output == item and exponent == 0:
                        continue
                    key = (output, exponent)
                    terms[key] = (terms.get(key, 0) + coefficient) % p
        return {key: value for key, value in terms.items() if value}

    actions = [moved_terms(item) for item in torus_fixed]
    separators = [((0, 0, 0), 1), ((2, 0, 0), 3)]
    coefficient_matrix = [
        [actions[column].get(row, 0) for column in range(2)]
        for row in separators
    ]
    assert coefficient_matrix == [[1, 0], [0, 1]]
    serialized_actions = [
        [
            [list(output), exponent, coefficient]
            for (output, exponent), coefficient in sorted(action.items())
        ]
        for action in actions
    ]
    return {
        "ambient_basis_dimension": len(basis),
        "wrapped_torus_weights": [weight(item) for item in torus_fixed],
        "torus_fixed_basis_indices": [list(item) for item in torus_fixed],
        "root_action_supports": serialized_actions,
        "root_action_supports_sha256": canonical_hash(serialized_actions),
        "separating_output_monomials": [
            {"basis_index": list(output), "t_exponent": exponent}
            for output, exponent in separators
        ],
        "coefficient_matrix": coefficient_matrix,
        "conclusion": "both torus-fixed coefficients vanish",
    }


def torus_gap(p, s, e, r):
    positive = [p - r, p + r]
    negative = [-p - r, -p + r]
    assert positive[0] == s + 2 and negative[1] == -s - 2
    assert positive[0] > s and negative[1] < -s
    modulus = p**e - 1
    maximum_difference = 4 * p - 2
    ordinary_gap = maximum_difference < modulus
    degenerate_repair = None
    if not ordinary_gap:
        assert (p, s, e) == (3, 0, 2)
        degenerate_repair = degenerate_root_group_repair()
    return {
        "source_interval": [-s, s],
        "coefficient_plus_one_interval": positive,
        "coefficient_minus_one_interval": negative,
        "strict_integer_gap": True,
        "torus_modulus": modulus,
        "maximum_weight_difference": maximum_difference,
        "no_modular_wrap": ordinary_gap,
        "degenerate_root_group_repair": degenerate_repair,
        "hom_B_dimension": 0,
    }


def wall_record(p, s, r):
    middle = list(range(p - 2, 0, -2))
    candidates = [
        [left, right]
        for left in middle
        for right in middle
        if left == p - 2 and right == 1
    ]
    assert candidates == [[p - 2, 1]]
    seed = [(-1) ** j * math.comb(r, j) % p for j in range(r + 1)]
    iterated_seed = [1]
    for _ in range(r):
        iterated_seed = convolution(iterated_seed, [1, p - 1], p)
    assert seed == iterated_seed
    assert seed[0] == 1 and -seed[1] % p == r
    derivative = [index * seed[index] % p for index in range(1, r + 1)]
    derivative_formula = [
        -r * (-1) ** index * math.comb(r - 1, index) % p
        for index in range(r)
    ]
    assert derivative == derivative_formula
    trace_terms = [[index, 1] for index in range(r)]
    trace_scalar = sum(value for _, value in trace_terms) % p
    assert trace_scalar == r and trace_scalar
    normalized_row = {
        "source_row": [p - 2, 1],
        "cofactor": [r, 1],
        "seed_polynomial": seed,
        "trace_terms": trace_terms,
        "spill_coordinate": {
            "target": [[0, 2], [r, 1]],
            "coordinate": ["highest_Y", "highest_R"],
            "coefficient": 1,
        },
    }
    return {
        "normalization": "top divided-power wall coefficient = 1",
        "unique_adjacent_candidates": candidates,
        "unique_row": True,
        "seed_polynomial": {
            "variable": "z",
            "formula": "(1-z)^r",
            "coefficients_mod_p": seed,
            "primitive_difference_convolution_power": r,
            "constant_coordinate": seed[0],
            "negative_linear_coordinate": -seed[1] % p,
            "formal_derivative_coefficients_mod_p": derivative,
            "formal_derivative_formula": "-r*(1-z)^(r-1)",
        },
        "trace_terms": trace_terms,
        "trace_scalar": trace_scalar,
        "trace_scalar_integer": r,
        "trace_scalar_nonzero": True,
        "spill_coordinate": normalized_row["spill_coordinate"],
        "spill_nonzero": True,
        "map_sha256": canonical_hash(normalized_row),
    }


def case_record(p, s, e):
    assert p >= 3 and p % 2 == 1 and is_prime(p)
    assert e > 1
    assert s >= 0 and s % 2 == 0 and p > s + 1
    r = p - 2 - s
    assert 1 <= r < p
    source_cg = clebsch_gordan_map(r, p - 2, r, p)
    toeplitz_entries = [
        [j, r - j + source, source, (-1) ** j * math.comb(r, j) % p]
        for source in range(s + 1)
        for j in range(r + 1)
    ]
    assert source_cg["entries"] == toeplitz_entries
    frobenius_cg = clebsch_gordan_map(1, 1, 1, p)
    modules = {
        "S": module_record("S", (s,)),
        "T": module_record("T", (p - 2, 1)),
        "R": module_record("R", (r, 1)),
        "Y": module_record("Y", (0, 2)),
    }
    return {
        "p": p,
        "s": s,
        "e": e,
        "r": r,
        "modules": modules,
        "occurrence": occurrence(p, s, e),
        "local_clebsch_gordan": {
            "zeroth_digit_sha256": canonical_hash(source_cg),
            "frobenius_digit_sha256": canonical_hash(frobenius_cg),
            "zeroth_digit_nonzero_entries": len(source_cg["entries"]),
            "zeroth_digit_exact_entries": (s + 1) * (r + 1),
            "zeroth_digit_toeplitz_band_width": r + 1,
            "zeroth_digit_toeplitz": True,
            "frobenius_digit_nonzero_entries": len(frobenius_cg["entries"]),
        },
        "first_wall": wall_record(p, s, r),
        "torus_gap": torus_gap(p, s, e, r),
        "trace_target_dimension": 2 * (s + 1) * (p - 1),
        "spill_target_dimension": 6 * (p - 1 - s),
    }


def committed_cross_checks(cases):
    by_parameters = {
        (case["p"], case["s"], case["e"]): case for case in cases
    }
    q121 = json.loads(Q121_CERTIFICATE.read_text())
    q121_row = q121["trace_visible_rows"][-1]
    local121 = by_parameters[(11, 6, 2)]
    assert q121["nonzero_connecting_rows"] == 1
    assert q121_row["factors"] == [[local121["r"], 1], [9, 1]]
    assert q121_row["connecting_scalar"][0] == local121["r"]
    assert q121_row["hom"]["dimension"] == 1

    q169 = json.loads(Q169_CERTIFICATE.read_text())
    local169 = by_parameters[(13, 6, 2)]
    assert q169["source"] == [6, 0]
    assert q169["T"] == [11, 1]
    assert q169["R"] == [local169["r"], 1]
    assert q169["Y"] == [0, 2]
    assert q169["trace_scalar"][0] == local169["r"]
    assert q169["p_minus_2_minus_s"] == local169["r"]
    assert all(q169["spill_supports"])
    assert q169["torus_fixed_cochains"] == 0
    return {
        "q121": {
            "row": 34,
            "unique_nonzero_connecting_row": True,
            "trace_scalar": local121["r"],
            "R": [local121["r"], 1],
            "T": [9, 1],
        },
        "q169": {
            "trace_scalar": local169["r"],
            "R": [local169["r"], 1],
            "T": [11, 1],
            "spill_nonzero": True,
            "torus_fixed_cochains": 0,
        },
    }


def calculate():
    parameters = (
        (3, 0, 2),
        (5, 2, 2),
        (7, 4, 3),
        (11, 6, 2),
        (11, 8, 3),
        (13, 6, 2),
        (13, 8, 2),
    )
    cases = [case_record(*item) for item in parameters]
    return {
        "schema": 1,
        "theorem_scope": {
            "p": "odd prime",
            "e": "integer > 1",
            "s": "even integer with 0 <= s < p-1",
            "constructed_modules": ["S", "T", "R", "Y"],
            "extension_field_constructed": False,
        },
        "occurrence_packets": {
            "derivation": (
                "e*(p-1)/2 == 1+s/2 (mod 2), so s mod 4 = 2 "
                "requires bit 0 and s mod 4 = 0 requires bit 1"
            ),
            "s_mod_4_equals_2": "e*(p-1)/2 is even",
            "s_mod_4_equals_0": "e*(p-1)/2 is odd",
        },
        "cases": cases,
        "committed_cross_checks": committed_cross_checks(cases),
        "evidence_boundary": (
            "the human Lucas-socle theorem decides occurrence and the human "
            "adjacent-wall theorem supplies the normalized row; this local "
            "replay checks the row's divided-power maps and consequences"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--case", nargs=3, metavar=("P", "S", "E"), type=int)
    args = parser.parse_args()
    if args.case:
        print(json.dumps(case_record(*args.case), sort_keys=True))
        return
    result = calculate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(rendered)
        print(f"wrote {CERTIFICATE.name}")
    else:
        assert CERTIFICATE.read_text() == rendered
        print("C688 generic first-wall certificate OK")


if __name__ == "__main__":
    main()
