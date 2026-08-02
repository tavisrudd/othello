#!/usr/bin/env python3
"""Exact four-point row-transition diagnostic for C756 Route Q."""

from __future__ import annotations

import argparse
from collections import Counter
from hashlib import sha256
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
COFACTOR_SOURCE = HERE / "2026-08-02-c756-prime-field-lacunary-first-cofactor.py"
OUTPUT = HERE / "2026-08-02-c756-four-point-row-transitions.json"
FIELDS = (5, 7, 11, 19, 23, 31, 43)
ZERO = (0, 0)
ONE = (1, 0)

spec = spec_from_file_location("c756_cofactor", COFACTOR_SOURCE)
cofactor = module_from_spec(spec)
spec.loader.exec_module(cofactor)


def fadd(field, left, right):
    return field["add"](left, right)


def fneg(field, value):
    return field["sub"](ZERO, value)


def fsub(field, left, right):
    return field["sub"](left, right)


def fmul(field, left, right):
    return field["mul"](left, right)


def finv(field, p, value):
    assert value != ZERO
    return field["fpow"](value, p * p - 2)


def fdiv(field, p, left, right):
    return fmul(field, left, finv(field, p, right))


def fpow(field, value, exponent):
    result = ONE
    while exponent:
        if exponent & 1:
            result = fmul(field, result, value)
        value = fmul(field, value, value)
        exponent //= 2
    return result


def ptrim(poly):
    while len(poly) > 1 and poly[-1] == ZERO:
        poly.pop()
    return poly


def pdegree(poly):
    return len(ptrim(poly[:])) - 1


def peval(field, poly, value):
    result = ZERO
    for coefficient in reversed(poly):
        result = fadd(field, fmul(field, result, value), coefficient)
    return result


def pdivmod(field, p, dividend, divisor):
    remainder = ptrim(dividend[:])
    divisor = ptrim(divisor[:])
    assert divisor != [ZERO]
    quotient = [ZERO] * max(1, len(remainder) - len(divisor) + 1)
    inverse_lead = finv(field, p, divisor[-1])
    while len(remainder) >= len(divisor) and remainder != [ZERO]:
        shift = len(remainder) - len(divisor)
        coefficient = fmul(field, remainder[-1], inverse_lead)
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[index + shift] = fsub(
                field, remainder[index + shift], fmul(field, coefficient, value)
            )
        ptrim(remainder)
    return ptrim(quotient), remainder


def pgcd(field, p, left, right):
    left, right = ptrim(left[:]), ptrim(right[:])
    while right != [ZERO]:
        _, remainder = pdivmod(field, p, left, right)
        left, right = right, remainder
    scale = finv(field, p, left[-1])
    return ptrim([fmul(field, scale, value) for value in left])


def normalize_pair(field, p, numerator, denominator):
    common = pgcd(field, p, numerator, denominator)
    if pdegree(common):
        numerator, rem_n = pdivmod(field, p, numerator, common)
        denominator, rem_d = pdivmod(field, p, denominator, common)
        assert rem_n == [ZERO] and rem_d == [ZERO]
    scale = finv(field, p, denominator[-1])
    numerator = ptrim([fmul(field, scale, value) for value in numerator])
    denominator = ptrim([fmul(field, scale, value) for value in denominator])
    return numerator, denominator


def rref_nullspace(field, p, matrix):
    matrix = [[tuple(value) for value in row] for row in matrix]
    rows = len(matrix)
    columns = len(matrix[0]) if matrix else 0
    pivots = []
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if matrix[row][column] != ZERO),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = finv(field, p, matrix[pivot_row][column])
        matrix[pivot_row] = [
            fmul(field, scale, value) for value in matrix[pivot_row]
        ]
        for row in range(rows):
            if row == pivot_row or matrix[row][column] == ZERO:
                continue
            scale = matrix[row][column]
            matrix[row] = [
                fsub(field, value, fmul(field, scale, pivot_value))
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [ZERO] * columns
        vector[free_column] = ONE
        for row, pivot_column in reversed(list(enumerate(pivots))):
            vector[pivot_column] = fneg(field, matrix[row][free_column])
        basis.append(vector)
    return basis, len(pivots)


def linear_combination(field, left, scalar, right):
    return [fadd(field, a, fmul(field, scalar, b)) for a, b in zip(left, right)]


def valid_nullspace_vector(field, p, basis, degree, pairs):
    """Choose a nullspace vector whose denominator misses every input point."""
    denominator_values = [
        [peval(field, vector[degree + 1:], x) for x, _ in pairs]
        for vector in basis
    ]
    if any(all(values[index] == ZERO for values in denominator_values)
           for index in range(len(pairs))):
        return None
    current = [ZERO] * len(basis[0])
    current_values = [ZERO] * len(pairs)
    unused = set(range(len(basis)))
    while any(value == ZERO for value in current_values):
        zeros = [index for index, value in enumerate(current_values)
                 if value == ZERO]
        choice = max(
            unused,
            key=lambda row: sum(denominator_values[row][index] != ZERO
                                for index in zeros),
        )
        assert any(denominator_values[choice][index] != ZERO for index in zeros)
        unused.remove(choice)
        forbidden = set()
        for old, direction in zip(current_values, denominator_values[choice]):
            if old != ZERO and direction != ZERO:
                forbidden.add(fdiv(field, p, fneg(field, old), direction))
        scalar = next(
            (value for a in range(p) for b in range(p)
             if (value := (a, b)) != ZERO and value not in forbidden),
            None,
        )
        assert scalar is not None
        current = linear_combination(field, current, scalar, basis[choice])
        current_values = [
            fadd(field, old, fmul(field, scalar, direction))
            for old, direction in zip(current_values, denominator_values[choice])
        ]
    return current


def rational_interpolant(field, p, pairs):
    """Return a canonical reduced least-max-degree interpolant P/Q."""
    for degree in range(len(pairs)):
        matrix = []
        for x, y in pairs:
            powers = [ONE]
            for _ in range(degree):
                powers.append(fmul(field, powers[-1], x))
            matrix.append(powers + [fneg(field, fmul(field, y, value))
                                     for value in powers])
        basis, rank = rref_nullspace(field, p, matrix)
        if not basis:
            continue
        vector = valid_nullspace_vector(field, p, basis, degree, pairs)
        if vector is None:
            continue
        numerator = ptrim(vector[:degree + 1])
        denominator = ptrim(vector[degree + 1:])
        numerator, denominator = normalize_pair(field, p, numerator, denominator)
        actual_degree = max(pdegree(numerator), pdegree(denominator))
        assert actual_degree == degree
        assert all(
            fdiv(field, p, peval(field, numerator, x),
                 peval(field, denominator, x)) == y
            for x, y in pairs
        )
        return {
            "degree": degree,
            "numerator": numerator,
            "denominator": denominator,
            "interpolation_rank": rank,
            "interpolation_nullity": len(basis),
        }
    raise AssertionError("polynomial interpolation must succeed")


def angle(field, p, zi, zj):
    value = fmul(
        field,
        fsub(field, zi, zj),
        fsub(field, zi, field["conj"](zj)),
    )
    return field["fpow"](value, p * p - p)


def odd_torus(field, p):
    half = (p + 1) // 2
    values = []
    for a in range(p):
        for b in range(p):
            value = (a, b)
            if value == ZERO:
                continue
            if fmul(field, value, field["conj"](value)) != ONE:
                continue
            if fpow(field, value, half) == fneg(field, ONE):
                values.append(value)
    assert len(values) == half
    return values


def transition_pairs(matrix, source, target):
    pairs = []
    for label in range(len(matrix)):
        if label == source:
            continue
        image_label = source if label == target else label
        pairs.append((matrix[source][label], matrix[target][image_label]))
    return pairs


def four_point_defect(field, pairs):
    defective = 0
    total = 0
    for indexes in combinations(range(len(pairs)), 4):
        a, b, c, d = [pairs[index] for index in indexes]
        left = fmul(
            field,
            fmul(field, fsub(field, a[0], c[0]), fsub(field, b[0], d[0])),
            fmul(field, fsub(field, a[1], d[1]), fsub(field, b[1], c[1])),
        )
        right = fmul(
            field,
            fmul(field, fsub(field, a[0], d[0]), fsub(field, b[0], c[0])),
            fmul(field, fsub(field, a[1], c[1]), fsub(field, b[1], d[1])),
        )
        total += 1
        defective += left != right
    return defective, total


def encoded_poly(poly):
    return [[a, b] for a, b in poly]


def histogram(values):
    return dict(sorted(Counter(str(value) for value in values).items()))


def aggregate_histogram(profiles, key):
    total = Counter()
    for profile in profiles:
        total.update({name: count for name, count in profile[key].items()})
    return dict(sorted(total.items()))


def candidate_profile(candidate, field, p, torus, norm_one):
    size = len(candidate)
    matrix = [
        [None if i == j else angle(field, p, candidate[i], candidate[j])
         for j in range(size)]
        for i in range(size)
    ]
    odd = set(torus)
    row_image_sizes = [len({value for value in row if value is not None})
                       for row in matrix]
    bijective_rows = [
        {value for value in row if value is not None} == odd for row in matrix
    ]

    row_sums = []
    for row in matrix:
        total = ZERO
        for value in row:
            if value is not None:
                total = fadd(field, total, value)
        row_sums.append(total)

    transition_degrees = []
    denominator_degrees = []
    norm_one_poles = []
    four_point_defects = []
    four_point_totals = []
    divisor_stream = []
    nonfunctional_transitions = 0
    nonpermutation_transitions = 0
    complete_permutation_transitions = 0
    injective_function_transitions = 0
    for source in range(size):
        for target in range(size):
            if source == target:
                continue
            pairs = transition_pairs(matrix, source, target)
            relation = {}
            functional = True
            for x, y in pairs:
                if x in relation and relation[x] != y:
                    functional = False
                    break
                relation[x] = y
            if not functional:
                nonfunctional_transitions += 1
                continue
            reduced_pairs = sorted(relation.items())
            injective = len({y for _, y in reduced_pairs}) == len(reduced_pairs)
            permutation = injective and len(reduced_pairs) == len(pairs)
            if not permutation:
                nonpermutation_transitions += 1
            else:
                complete_permutation_transitions += 1
            interpolant = rational_interpolant(field, p, reduced_pairs)
            denominator = interpolant["denominator"]
            transition_degrees.append(interpolant["degree"])
            denominator_degrees.append(pdegree(denominator))
            norm_one_poles.append(sum(peval(field, denominator, value) == ZERO
                                      for value in norm_one))
            divisor_stream.append(encoded_poly(denominator))

            if injective:
                injective_function_transitions += 1
                defective, total = four_point_defect(field, reduced_pairs)
                four_point_defects.append(defective)
                four_point_totals.append(total)
                # Independent linear-algebra check of the Möbius/four-point boundary.
                mobius_matrix = []
                for x, y in reduced_pairs:
                    mobius_matrix.append([ONE, x, fneg(field, y),
                                          fneg(field, fmul(field, x, y))])
                _, mobius_rank = rref_nullspace(field, p, mobius_matrix)
                assert (defective == 0) == (mobius_rank <= 3)
                assert (defective == 0) == (interpolant["degree"] <= 1)

    serialized_divisors = json.dumps(divisor_stream, separators=(",", ":"))
    return {
        "vanishing_first_angle_rows": sum(value == ZERO for value in row_sums),
        "bijective_angle_rows": sum(bijective_rows),
        "angle_row_image_size_histogram": histogram(row_image_sizes),
        "ordered_transition_count": size * (size - 1),
        "functional_transition_count": len(transition_degrees),
        "nonfunctional_transition_count": nonfunctional_transitions,
        "complete_permutation_transition_count": complete_permutation_transitions,
        "injective_function_transition_count": injective_function_transitions,
        "functional_nonpermutation_transition_count": nonpermutation_transitions,
        "least_rational_degree_histogram": histogram(transition_degrees),
        "maximum_least_rational_degree": max(transition_degrees, default=None),
        "pole_divisor_degree_histogram": histogram(denominator_degrees),
        "norm_one_torus_pole_count_histogram": histogram(norm_one_poles),
        "pole_divisor_stream_sha256": sha256(serialized_divisors.encode()).hexdigest(),
        "four_point_comparisons": sum(four_point_totals),
        "four_point_defects": sum(four_point_defects),
        "defective_transition_count": sum(value != 0 for value in four_point_defects),
        "maximum_defects_in_one_transition": max(four_point_defects, default=0),
        "all_transitions_mobius": (
            nonfunctional_transitions == 0
            and nonpermutation_transitions == 0
            and all(value == 0 for value in four_point_defects)
        ),
    }


def field_profile(p, expected_candidates):
    candidates, field = cofactor.source.saturated_candidates(p)
    assert len(candidates) == expected_candidates
    torus = odd_torus(field, p)
    norm_one = [
        (a, b) for a in range(p) for b in range(p)
        if (a, b) != ZERO
        and fmul(field, (a, b), field["conj"]((a, b))) == ONE
    ]
    assert len(norm_one) == p + 1
    profiles = [candidate_profile(candidate, field, p, torus, norm_one)
                for candidate in candidates]
    return {
        "q": p,
        "candidate_count": len(candidates),
        "all_transition_mobius_candidates": sum(
            row["all_transitions_mobius"] for row in profiles
        ),
        "all_rows_vanishing_candidates": sum(
            row["vanishing_first_angle_rows"] == len(candidates[0])
            for row in profiles
        ),
        "maximum_degree_across_candidates": histogram(
            row["maximum_least_rational_degree"]
            if row["maximum_least_rational_degree"] is not None else "none"
            for row in profiles
        ),
        "ordered_transition_count": sum(
            row["ordered_transition_count"] for row in profiles
        ),
        "functional_transition_count": sum(
            row["functional_transition_count"] for row in profiles
        ),
        "nonfunctional_transition_count": sum(
            row["nonfunctional_transition_count"] for row in profiles
        ),
        "complete_permutation_transition_count": sum(
            row["complete_permutation_transition_count"] for row in profiles
        ),
        "least_rational_degree_histogram": aggregate_histogram(
            profiles, "least_rational_degree_histogram"
        ),
        "pole_divisor_degree_histogram": aggregate_histogram(
            profiles, "pole_divisor_degree_histogram"
        ),
        "norm_one_torus_pole_count_histogram": aggregate_histogram(
            profiles, "norm_one_torus_pole_count_histogram"
        ),
        "four_point_comparisons": sum(
            row["four_point_comparisons"] for row in profiles
        ),
        "four_point_defects": sum(
            row["four_point_defects"] for row in profiles
        ),
        "candidate_profiles": profiles,
    }


def generate():
    expected = {
        row["q"]: row["candidates"]
        for row in json.loads(cofactor.AUDIT.read_text())["rows"]
    }
    rows = [field_profile(p, expected[p]) for p in FIELDS]
    assert rows[0]["all_transition_mobius_candidates"] == 2
    assert rows[0]["all_rows_vanishing_candidates"] == 2
    assert all(row["all_transition_mobius_candidates"] == 0 for row in rows[1:])
    assert all(row["all_rows_vanishing_candidates"] == 0 for row in rows[1:])
    return {
        "schema": "c756-four-point-row-transitions-v1",
        "scope": (
            "every ordered row transition of every normalized pairwise-character "
            "candidate in prime q in {5,7,11,19,23,31,43}"
        ),
        "transition_completion": (
            "common label j maps alpha_ij to alpha_lj; the deleted label l maps "
            "alpha_il to the inserted value alpha_li"
        ),
        "least_degree_convention": (
            "minimum max(deg P,deg Q) among exact P/Q interpolants with no pole "
            "on the odd norm-one input coset; the first valid interpolant in a "
            "deterministic RREF projective basis fixes the reported pole divisor"
        ),
        "inputs": [COFACTOR_SOURCE.name, cofactor.SOURCE.name, cofactor.AUDIT.name],
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
