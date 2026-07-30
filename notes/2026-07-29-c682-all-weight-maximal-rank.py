#!/usr/bin/env python3
"""All-weight maximal rank for the C682 third transvectant."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c682-all-weight-maximal-rank.json"
FORCED = {0: 1, 1: 2, 2: 3, 6: 3, 10: 3, 11: 2, 12: 1}
EVEN_UNFORCED = (4, 8, 14, 16, 18)
ODD_UNFORCED_CHOICES = {
    3: ((1, "shift", 1), (0, "shift", 2)),
    5: ((2, "first", 1), (1, "shift", 2)),
    7: ((3, "first", 1), (0, "shift", 2)),
    9: ((0, "shift", 1), (1, "shift", 2)),
    13: ((1, "shift", 1), (0, "shift", 2)),
    15: ((2, "first", 1), (1, "shift", 2)),
    17: ((3, "first", 1), (0, "shift", 2)),
    19: ((0, "shift", 1), (1, "shift", 2)),
}
KOSTANT_GENERATORS = {
    "1": (1, [0, 30]),
    "2": (2, [1, 11, 19, 29]),
    "2p": (2, [7, 13, 17, 23]),
    "3": (3, [2, 10, 12, 18, 20, 28]),
    "3p": (3, [6, 10, 14, 16, 20, 24]),
    "4": (4, [6, 8, 12, 14, 16, 18, 22, 24]),
    "4s": (4, [3, 9, 11, 13, 17, 19, 21, 27]),
    "5": (5, [4, 8, 10, 12, 14, 16, 18, 20, 22, 26]),
    "6": (6, [5, 7, 9, 11, 13, 15, 15, 17, 19, 21, 23, 25]),
}
CERTIFIED_ENTRANCES = {
    "1": [4, 24, 44],
    "2": [3, 13, 23, 33, 43, 53],
    "3": [12, 14, 32, 34, 52, 54],
    "3p": [10, 14, 18, 30, 34, 38, 50, 54, 58],
}


def falling(value, order):
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def coefficients(degree, index):
    complement = degree - index
    d1 = 330 * falling(index, 2) * (degree - 4 * index + 6)
    d6 = 660 * (
        2 * falling(complement, 3)
        - 9 * falling(complement, 2) * index
        + 9 * complement * falling(index, 2)
        - 2 * falling(index, 3)
    )
    d11 = (
        -330
        * falling(complement, 2)
        * (3 * degree - 4 * index - 6)
    )
    return d1, d6, d11


def chain_matrix(degree, residue):
    source = list(range(residue, degree + 1, 5))
    target_residue = (residue + 3) % 5
    target = list(range(target_residue, degree + 7, 5))
    target_lookup = {index: row for row, index in enumerate(target)}
    matrix = [[0] * len(source) for _ in target]
    for column, index in enumerate(source):
        for target_index, value in zip(
            (index - 2, index + 3, index + 8),
            coefficients(degree, index),
        ):
            if target_index in target_lookup:
                matrix[target_lookup[target_index]][column] = value
    return source, target, matrix


def rank(matrix):
    if not matrix or not matrix[0]:
        return 0
    work = [row[:] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        for row in range(pivot_row + 1, len(work)):
            if not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left * pivot_value - value * right
                for left, right in zip(work[row], work[pivot_row])
            ]
            common = 0
            for entry in work[row]:
                common = gcd(common, abs(entry))
            if common > 1:
                work[row] = [entry // common for entry in work[row]]
        pivot_row += 1
    return pivot_row


def gcd(left, right):
    while right:
        left, right = right, left % right
    return left


def coefficient_count(value):
    if value < 0 or value % 4:
        return 0
    return sum(
        1
        for h_power in range(value // 20 + 1)
        if (value - 20 * h_power) % 12 == 0
    )


def multiplicity(label, degree):
    return sum(
        coefficient_count(degree - generator)
        for generator in KOSTANT_GENERATORS[label][1]
    )


def forced_dimension_from_mckay(degree):
    return sum(
        dimension
        * max(
            multiplicity(label, degree)
            - multiplicity(label, degree + 6),
            0,
        )
        for label, (dimension, _) in KOSTANT_GENERATORS.items()
    )


def forced_dimension(degree):
    return FORCED.get(degree % 20, 0)


def exact_kernel_dimension(degree):
    return sum(
        len(source) - rank(matrix)
        for residue in range(5)
        for source, _, matrix in [chain_matrix(degree, residue)]
    )


def source_target_gap(degree_residue, chain_residue):
    degree = 60 + degree_residue
    source, target, _ = chain_matrix(degree, chain_residue)
    return len(target) - len(source)


def weight(degree_residue, chain_residue):
    return (degree_residue - 2 * chain_residue) % 5


def first_diagonal_audit(degree_residue, chain_residue):
    assert chain_residue >= 2
    constant = degree_residue - 4 * chain_residue + 6
    for quotient in (3, 4):
        degree = degree_residue + 20 * quotient
        source, _, matrix = chain_matrix(degree, chain_residue)
        square = [row[: len(source)] for row in matrix[: len(source)]]
        assert all(
            not square[row][column]
            for row in range(len(square))
            for column in range(row + 1, len(square))
        )
        assert all(
            square[index][index]
            == coefficients(degree, source[index])[0]
            != 0
            for index in range(len(source))
        )
    return {
        "selection": "first |source| target rows",
        "diagonal": "d1(n,j)=330(j)_2(n-4j+6)",
        "source_residue_mod_5": chain_residue,
        "boundary_factors_nonzero": chain_residue >= 2,
        "linear_factor_constant_mod_20": constant % 20,
        "linear_factor_nonzero": constant % 20 != 0,
    }


def shifted_diagonal_audit(degree_residue, chain_residue, omit_last=False):
    assert chain_residue < 2
    degree = 100 + degree_residue
    source = list(range(chain_residue, degree + 1, 5))
    if omit_last:
        source = source[:-1]
    minimum_gap = min(degree - index for index in source)
    constant = 3 * degree_residue - 4 * chain_residue - 6
    for quotient in (3, 4):
        test_degree = degree_residue + 20 * quotient
        test_source, _, matrix = chain_matrix(
            test_degree, chain_residue
        )
        columns = len(test_source) - int(omit_last)
        square = [
            row[:columns] for row in matrix[1 : 1 + columns]
        ]
        assert all(
            not square[row][column]
            for row in range(len(square))
            for column in range(row)
        )
        assert all(
            square[index][index]
            == coefficients(test_degree, test_source[index])[2]
            != 0
            for index in range(columns)
        )
    return {
        "selection": (
            "target rows 1..|source|-1 and source columns 0..|source|-2"
            if omit_last
            else "target rows 1..|source|"
        ),
        "diagonal": "d11(n,j)=-330(n-j)_2(3n-4j-6)",
        "source_residue_mod_5": chain_residue,
        "minimum_n_minus_j": minimum_gap,
        "boundary_factors_nonzero": minimum_gap >= 2,
        "linear_factor_constant_mod_20": constant % 20,
        "linear_factor_nonzero": constant % 20 != 0,
    }


def even_unforced_audit():
    out = {}
    for degree_residue in EVEN_UNFORCED:
        chain_residue = 3 * degree_residue % 5
        assert weight(degree_residue, chain_residue) == 0
        audit = first_diagonal_audit(degree_residue, chain_residue)
        out[str(degree_residue)] = {
            "weight_class_mod_5": 0,
            **audit,
        }
    return out


def odd_unforced_audit():
    out = {}
    for degree_residue, choices in ODD_UNFORCED_CHOICES.items():
        rows = []
        observed_weights = set()
        for chain_residue, selection, absolute_weight in choices:
            actual_weight = weight(degree_residue, chain_residue)
            assert actual_weight in {
                absolute_weight,
                (-absolute_weight) % 5,
            }
            observed_weights.add(absolute_weight)
            assert source_target_gap(degree_residue, chain_residue) >= 1
            audit = (
                first_diagonal_audit(degree_residue, chain_residue)
                if selection == "first"
                else shifted_diagonal_audit(
                    degree_residue, chain_residue
                )
            )
            rows.append(
                {
                    "absolute_weight_class": absolute_weight,
                    "actual_weight_mod_5": actual_weight,
                    **audit,
                }
            )
        assert observed_weights == {1, 2}
        out[str(degree_residue)] = rows
    return out


def forced_one_audit():
    rows = {}
    for degree_residue, chain_residue in ((0, 0), (12, 1)):
        assert weight(degree_residue, chain_residue) == 0
        audit = shifted_diagonal_audit(
            degree_residue, chain_residue, omit_last=True
        )
        rows[str(degree_residue)] = {
            "forced_kernel_dimension": 1,
            "weight_class_mod_5": 0,
            "conclusion": "the weight-zero chain has nullity at most one",
            **audit,
        }
    return rows


def low_degree_audit():
    rows = []
    for degree in range(53):
        exact = exact_kernel_dimension(degree)
        forced = forced_dimension_from_mckay(degree)
        assert exact == forced
        rows.append(exact)
    return rows


def periodic_forced_audit():
    rows = []
    for degree in range(53, 173):
        observed = forced_dimension_from_mckay(degree)
        expected = forced_dimension(degree)
        assert observed == expected
        rows.append(observed)
    for degree in range(113, 173):
        assert all(
            multiplicity(label, degree + 60)
            - multiplicity(label, degree)
            == sum(
                (degree - generator) % 4 == 0
                for generator in generators
            )
            for label, (_, generators) in KOSTANT_GENERATORS.items()
        )
        assert all(
            sum(
                (degree - generator) % 4 == 0
                for generator in generators
            )
            == sum(
                (degree + 6 - generator) % 4 == 0
                for generator in generators
            )
            for _, generators in KOSTANT_GENERATORS.values()
        )
    return {
        "checked_degrees": "53..172",
        "eventual_multiplicity_translation": (
            "each degree-compatible free generator contributes one new "
            "solution under n -> n+60"
        ),
        "semigroup_identity": (
            "c(k+60)=c(k)+1 for every k>=0 divisible by 4, where "
            "c(k)=#{(a,b)>=0:12a+20b=k}; divide by 4 and use the "
            "unique new residue-class solution to 3a+5b"
        ),
        "balanced_generator_classes": (
            "for every irreducible, the numbers of generators compatible "
            "with n and n+6 modulo 4 agree"
        ),
        "forced_kernel_series": (
            "(1+2t+3t^2+3t^6+3t^10+2t^11+t^12)/(1-t^20)"
        ),
        "one_period_values_from_degree_53": rows[:20],
    }


def propagation_frontier():
    entrances = {}
    peaks = {}
    for label in KOSTANT_GENERATORS:
        label_entrances = []
        label_peaks = []
        for residue in range(60):
            degree = 120 + residue
            lower = multiplicity(label, degree - 6)
            current = multiplicity(label, degree)
            upper = multiplicity(label, degree + 6)
            if current == lower + 1 and upper >= current:
                label_entrances.append(residue)
            if current > max(lower, upper):
                label_peaks.append(residue)
        entrances[label] = label_entrances
        peaks[label] = label_peaks
    assert all(
        entrances[label] == residues
        for label, residues in CERTIFIED_ENTRANCES.items()
    )
    remaining = {
        label: residues
        for label, residues in entrances.items()
        if label not in CERTIFIED_ENTRANCES
    }
    assert sum(map(len, remaining.values())) == 63
    assert all(not peaks[label] for label in remaining)
    return {
        "certified_modules": sorted(CERTIFIED_ENTRANCES),
        "certified_entrance_phases": CERTIFIED_ENTRANCES,
        "consequence": (
            "With maximal rank, the certified entrances anchor every "
            "plateau in 1,2,3,3'; square edges transport fullness and the "
            "already controlled strict peaks close the remaining vertices."
        ),
        "remaining_monotone_modules": sorted(remaining),
        "remaining_entrance_phases": remaining,
        "remaining_phase_count": sum(map(len, remaining.values())),
        "remaining_modulo_20_types": {
            label: sorted({residue % 20 for residue in residues})
            for label, residues in remaining.items()
        },
        "claim_boundary": (
            "The maximal-rank theorem closes off-peak propagation in "
            "1,2,3,3' but does not itself mix the 63 plateau entrances in "
            "2',4,4s,5,6."
        ),
    }


def certificate():
    even = even_unforced_audit()
    odd = odd_unforced_audit()
    forced_one = forced_one_audit()
    assert all(
        row["linear_factor_nonzero"]
        and row["boundary_factors_nonzero"]
        for row in even.values()
    )
    assert all(
        row["linear_factor_nonzero"]
        and row["boundary_factors_nonzero"]
        for rows in odd.values()
        for row in rows
    )
    assert all(
        row["linear_factor_nonzero"]
        and row["boundary_factors_nonzero"]
        for row in forced_one.values()
    )
    return {
        "schema": "c682-all-weight-maximal-rank-v1",
        "operator": {
            "map": "Delta_n=(.,Phi_12)_3: Sym^n -> Sym^(n+6)",
            "dehomogenized_order": 3,
            "leading_coefficient": (
                "-1320(z+11z^6-z^11)"
            ),
            "kernel_dimension_upper_bound": 3,
        },
        "forced_dimension": periodic_forced_audit(),
        "low_degrees": {
            "range": "0..52",
            "exact_kernel_dimensions": low_degree_audit(),
        },
        "unforced_even_residues": even,
        "unforced_odd_residues": odd,
        "forced_dimension_one_residues": forced_one,
        "representation_argument": {
            "even_small_irreducibles": ["1", "3", "3p"],
            "odd_small_irreducibles": ["2", "2p"],
            "C5_restrictions": {
                "1": [0],
                "3_or_3p": [0, "plus/minus 1 or plus/minus 2"],
                "2": ["plus/minus 1"],
                "2p": ["plus/minus 2"],
            },
            "logic": (
                "At unforced even degrees, injectivity on the weight-zero "
                "chain excludes 1,3,3'. At unforced odd degrees, one "
                "injective chain in each absolute weight class excludes "
                "2 and 2'. Forced dimensions two and three fill the "
                "order-three solution bound after central parity. At "
                "forced dimension one, the weight-zero chain has nullity "
                "at most one, while any additional nontrivial even "
                "irreducible would exceed the order-three bound."
            ),
        },
        "propagation_frontier": propagation_frontier(),
        "claim": (
            "For every n and every binary-icosahedral irreducible rho, "
            "the rho-block of Delta_n has rank "
            "min(m_rho(n),m_rho(n+6))."
        ),
        "trusted_boundary": (
            "The proof combines the order-three ODE bound, the exact "
            "Kostant forced-defect series, central parity and C5 weights, "
            "and triangular chain minors whose diagonal factors are "
            "proved nonzero by boundary and residue arithmetic."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(
        certificate(), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    else:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 all-weight maximal rank")


if __name__ == "__main__":
    main()
